//
//  circleCollectionView.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionView.h"
#import "circleCollectionViewCell.h"


@interface circleCollectionView ()
@property (strong, nonatomic) NSArray *dataArray;


//@property (nonatomic) CGSize viewSize;
@end



static NSString *cellId = @"Cell";


@implementation circleCollectionView


#pragma mark - Accessors



#pragma mark - Initializer
+(circleCollectionView *) newCircleCollectionViewWithData:(NSArray *) data embeddedIn:(UIView *)viewContainer delegatedBy:(id)delegate {
    
    circleCollectionViewLayout *circleLayout = [[circleCollectionViewLayout alloc] init];

    circleCollectionView * collectionView = [[circleCollectionView alloc] initWithFrame:viewContainer.frame collectionViewLayout:circleLayout];

    
    [viewContainer addSubview:collectionView];
    //layout constraint settings
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;

    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewContainer
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0.0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewContainer
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0.0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewContainer
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0 constant:0.0]];
    [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewContainer
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0 constant:0.0]];
    
    
    
    collectionView.dataArray = data;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegateCircleCollectionView = delegate;
    
    return collectionView;
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(circleCollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"circleCellView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    }
    return self;
}


#pragma mark - CollectionView DataSource

-(circleCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    circleCollectionViewCell *cell;

    cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.item];
    
    cell.textLabel = [item valueForKey:@"name"];
    cell.image = [UIImage imageNamed:[item valueForKey:@"picture"]];
    cell.borderRGBColor = [item valueForKey:@"color"];
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
    
    
}

#pragma mark - UIViewCollectionViewDelegate


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    NSLog(@"item selected index %ld", (long)indexPath.row);
    [self.delegateCircleCollectionView collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //locate the scrollview which is in the centre
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2 + scrollView.contentOffset.x, self.frame.size.height /2 + scrollView.contentOffset.y);
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:centerPoint];
    NSLog(@"indexpath row %ld",(long)indexPath.row);
    [self.delegateCircleCollectionView collectionView:self didSelectItemAtIndexPath:indexPath];
}

#pragma mark - UIViewCollectionDelegateFlowLayout

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    
    float viewWidth = self.bounds.size.width;
    if (viewWidth == 0.0) {
        size = CGSizeMake(10.0, 10.0);
    } else {
        float height = self.bounds.size.height*0.8;
        float width = height/[self cellRatioLengthWidth];
        size = CGSizeMake(width,height);
        //NSLog(@"item Size W%f H%f",size.width,size.height);
    }
    return size;
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float inset = collectionView.bounds.size.width/2.0f;
    return UIEdgeInsetsMake(0, inset, 0, inset);
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20.0f;
}


#pragma mark - circleCollectionViewLayoutDelegate
- (float) cellRatioLengthWidth {
    return [circleCollectionViewCell nativeRatioHeightWidth];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
