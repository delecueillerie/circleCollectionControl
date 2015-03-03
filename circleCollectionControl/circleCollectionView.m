//
//  circleCollectionView.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionView.h"
#import "circleCollectionViewCell.h"
#import "circleCollectionItemModel.h"

#import "UIImage+Extended.h"

@interface circleCollectionView ()

@property(strong, nonatomic) UIImage *addButtonImage;
@property (strong, nonatomic) circleCollectionItemModel *addItem;
@property (strong, nonatomic) circleCollectionItemModel *selectedItem;



@property (strong, nonatomic) circleCollectionViewLayout *circleLayout;

@end


static NSString *cellId = @"Cell";


@implementation circleCollectionView


#pragma mark - Accessors

-(void) setAddButtonImage:(UIImage *)addButtonImage {
    _addButtonImage = addButtonImage;
    if (_addButtonImage) {
        self.addItem = [circleCollectionItemModel newWithName:@"Add" picture:_addButtonImage color:nil];
    } else {
        self.addItem = nil;
    }
}


-(void) setAddItem:(circleCollectionItemModel *)addItem {
    _addItem = addItem;
    if (_addItem) {
        [self.items addObject:_addItem];
    } else {
        [self.items removeObject:_addItem];
    }
    
}

-(NSMutableArray *) items {
    if (!_items) {
        _items = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _items;
}

#pragma mark - Initializer

+(circleCollectionView *) newCircleCollectionViewEmbeddedIn:(UIView *)viewContainer includedData:(NSArray * )data withOptionalAddButtonImage:(UIImage *)addButtonImage delegatedBy:(id)delegate isAllowingMultiSelection:(BOOL)isALlowingMultiSelection {

    circleCollectionViewLayout *circleLayout = [[circleCollectionViewLayout alloc] init];
    circleCollectionView * collectionView = [[circleCollectionView alloc] initWithFrame:viewContainer.frame collectionViewLayout:circleLayout];
    collectionView.circleLayout = circleLayout;
    [collectionView.items addObjectsFromArray:data];
    collectionView.addButtonImage = addButtonImage;
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

#pragma mark - item Manipulation

-(void)addItemWithName:(NSString *)name picture:(UIImage *)picture color:(UIColor *)color {
    circleCollectionItemModel *newItem = [circleCollectionItemModel newWithName:name picture:picture color:color];
    
    if (self.addItem) {
        [self.items insertObject:newItem atIndex:[self.items indexOfObject:self.addItem]];
    } else {
        [self.items addObject:newItem];
    }
    
    NSIndexPath *iP = [NSIndexPath indexPathForItem:[self.items indexOfObject:newItem] inSection:0];
    if ([self.items count] > 1) {
        [self insertItemsAtIndexPaths:[NSArray arrayWithObject:iP]];
    } else {
        [self reloadData];
    }
}

-(void) deleteSelectedItem {
    if (![self.selectedItem isEqual:self.addItem]) {
        NSIndexPath *selectedIP = [NSIndexPath indexPathForItem:[self.items indexOfObject:self.selectedItem] inSection:0];
        [self.items removeObject:self.selectedItem];
        [self deleteItemsAtIndexPaths:[NSArray arrayWithObject:selectedIP]];
        
        NSIndexPath *nextIP;
        
        if (selectedIP.row <[self.items count]) {
            nextIP = selectedIP;
        } else {
             nextIP = [NSIndexPath indexPathForItem:([self.items count]-1) inSection:0];
        }
        [self selectItemAtIndexPath:nextIP animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.delegateCircleCollectionView collectionView:self didSelectItemAtIndexPath:nextIP];

    }

}

-(void) longPressOnItem:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"UIGestureRecognizerStateEnded");
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){

        circleCollectionViewCell *cell = (circleCollectionViewCell *)sender.view;
        NSIndexPath *IP = [self indexPathForCell:cell];
        self.selectedItem = [self.items objectAtIndex:IP.row];
        if ((![self.selectedItem isEqual:self.addItem]) && [self.delegateCircleCollectionView respondsToSelector:@selector(showDestructiveAlertVC)] ) {
            [self.delegateCircleCollectionView showDestructiveAlertVC];
        }
        //NSLog(@"UIGestureRecognizerStateBegan.");
    }
}

#pragma mark - CollectionView DataSource

-(circleCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    circleCollectionViewCell *cell;
    cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    circleCollectionItemModel *item = [self.items objectAtIndex:indexPath.item];

    cell.collectionView = self;
    cell.textLabel = item.name ;
    cell.image = item.picture;
    cell.borderColor = item.color;
    
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

#pragma mark - UIViewCollectionViewDelegate


-(void) collectionView:(circleCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //UICollectionViewCell *selectedCell = [collectionView.dataSource  collectionView:collectionView cellForItemAtIndexPath:indexPath];
    self.circleLayout.transparency = YES;
    
    //NSLog(@"item selected index %ld", (long)indexPath.row);
    
    
    
    
    
    self.selectedItem = [self.items objectAtIndex:indexPath.row];
    if ([self.addItem isEqual:self.selectedItem] && [self.delegateCircleCollectionView respondsToSelector:@selector(addItem:)]) {
        [self.delegateCircleCollectionView addItem:collectionView];
    } else {
        [self.delegateCircleCollectionView collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

-(void) collectionView:(circleCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.circleLayout.transparency = NO;

    [self.delegateCircleCollectionView collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //locate the scrollview which is in the centre
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2 + scrollView.contentOffset.x, self.frame.size.height /2 + scrollView.contentOffset.y);
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:centerPoint];
    
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self.delegate collectionView:self didSelectItemAtIndexPath:indexPath];
    //[self.delegateCircleCollectionView collectionView:self didSelectItemAtIndexPath:indexPath];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.delegate collectionView:self didDeselectItemAtIndexPath:[[self indexPathsForSelectedItems] firstObject]];
    
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

#pragma mark - 
-(UIImage *) selectedUserIcon {
    //return [[self.selectedItem.picture squareImageScaledToSize:22.0f] rounded];
    return [self.selectedItem.picture iconForNavBarItem];
}

@end
