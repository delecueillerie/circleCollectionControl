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
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

#pragma mark - Attributes management

- (void)setLineAttributes:(UICollectionViewLayoutAttributes *)attributes visibleRect:(CGRect)visibleRect {
    
    
    CGFloat distance = (CGRectGetMidX(visibleRect) - attributes.center.x);
    CGFloat normalizedDistance = ABS(distance) / (visibleRect.size.width/2.0);
    CGFloat zoom = 1 - 0.8*normalizedDistance;
    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
}

#pragma mark - Scrolling Experience

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
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
    CGSize contentSize = CGSizeMake((numberOfPages +2)* pageWidth, pageHeight);

    return contentSize;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    //NSLog(@"Visible rect x%f y%f w%f h%f",visibleRect.origin.x,visibleRect.origin.y,visibleRect.size.width,visibleRect.size.height);
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                [self setLineAttributes:attributes visibleRect:visibleRect];
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView)
        {
            //
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
