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



@end

@implementation circleCollectionViewLayout


-(instancetype) init {
    self = [super init];
    if (self) {
        //self.insets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        BOOL iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        self.itemSize = (CGSize){170, 200};
        self.sectionInset = UIEdgeInsetsMake(iPad? 225 : 0, 35, iPad? 225 : 0, 35);
        self.minimumLineSpacing = 30.0;
        self.minimumInteritemSpacing = 200;
        self.headerReferenceSize = iPad? (CGSize){50, 50} : (CGSize){43, 43};
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
}

#pragma mark - Attributes management

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect
{
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
    if (ABS(distance) < ACTIVE_DISTANCE) {
        CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.zIndex = 1;
    }
    else
    {
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
    }
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
    NSLog(@"inRect call");
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self setLineAttributes:attributes visibleRect:visibleRect];
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            [self setHeaderAttributes:attributes];
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

/*
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    
    float minX = CGRectGetMinX(rect);
    float maxX = CGRectGetMaxX(rect);
    
    int firstIndex = floorf(minX / [self.dataSource cellSize].width);
    int lastIndex = floorf(maxX / [self.dataSource cellSize].width);
    int activeIndex = (int)(firstIndex + lastIndex)/2;
    
    int maxVisibleOnScreen = 5;
    
    int firstItem = fmax(0, activeIndex - (int)(maxVisibleOnScreen/2) );
    int lastItem = fmin( [self.dataSource itemsNumber]-1 , activeIndex + (int)(maxVisibleOnScreen/2) );
    
 
    
    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    
    
    return [theLayoutAttributes copy];
}
*/

/*
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //double newIndex = (indexPath.item + self.offset);
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = [self.dataSource cellSize];;
    float scaleFactor;
    float deltaX;
    CGAffineTransform translationT;
    //CGAffineTransform rotationT = CGAffineTransformMakeRotation(self.AngularSpacing* newIndex *M_PI/180);
    

    if( self.wheelType == WHEELALIGNMENTLEFT){
        scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
        deltaX = self.cellSize.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset  , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius + (deltaX*scaleFactor) , 0);
    }else  {
        scaleFactor = fmax(0.4, 1 - fabs( newIndex *0.50));
        deltaX =  self.collectionView.bounds.size.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius  + ((1 - scaleFactor) * -30) , 0);
    }

    
    
    //CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    //theAttributes.alpha = scaleFactor;
    
    //theAttributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    //theAttributes.zIndex = indexPath.item;
    
    return attributes;
}
*/

/*
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
*/
@end
