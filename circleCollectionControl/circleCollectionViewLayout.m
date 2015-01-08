//
//  circleCollectionViewLayout.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 03/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionViewLayout.h"


@interface circleCollectionViewLayout ()

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;


//float cellRatioHeightWidth;

@end

@implementation circleCollectionViewLayout

//#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3
-(instancetype) init {
    self = [super init];
    if (self) {
        //self.insets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        //self.sectionInset = UIEdgeInsetsMake(iPad? 225 : 0, 35, iPad? 225 : 0, 35);
        //self.headerReferenceSize = iPad? (CGSize){50, 50} : (CGSize){43, 43};
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    //cellRatioHeightWidth = [self.delegate cellRatioLengthWidth];
    
}

#pragma mark - Attributes management

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect
{
    
    
    //int activeDistance = floor(visibleRect.size.width*(5/30));
    
    CGFloat distance = (CGRectGetMidX(visibleRect) - attributes.center.x);
    //CGFloat normalizedDistance = distance / activeDistance;
    CGFloat normalizedDistance = ABS(distance) / (visibleRect.size.width/2.0);
    NSLog(@"normalizedDistance %f ", normalizedDistance);
    
    //if (normalizedDistance < 5.0/30.0) {
        CGFloat zoom = 1 + 0.3*(1-normalizedDistance);
        
        //1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
      //  attributes.zIndex = 1;
        //}
    /*
    else if (normalizedDistance < 11.0/30.0) {
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
        }
    else if (normalizedDistance < 15.0/30.0) {
        CGFloat zoom = 1 - ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.zIndex = 0;
    }*/
}

#pragma mark - Scrolling Experie ce

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

#pragma mark - Overriding

- (CGSize)collectionViewContentSize {
    
    // Ask the data source how many items there are (assume a single section)
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    NSInteger numberOfItems = [dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    // Determine how many pages are needed
    int numberOfPages = ceil((float)numberOfItems / 5.0);
    
    // Set the size
    float pageWidth = self.collectionView.frame.size.width;
    float pageHeight = self.collectionView.frame.size.height;
    CGSize contentSize = CGSizeMake(numberOfPages * pageWidth, pageHeight);
    //NSLog(@"collectionView size W %f - H %f", pageWidth, pageHeight);
    //NSLog(@"collectionView ContentSize %f - %f", contentSize.width, contentSize.height);

    return contentSize;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self setLineAttributes:attributes visibleRect:visibleRect];
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            //[self setHeaderAttributes:attributes];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Attribute @indexPath %@", [indexPath description]);
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    [self setLineAttributes:attributes visibleRect:visibleRect];
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end