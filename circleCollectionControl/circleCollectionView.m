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

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    NSLog(@"setFrame W%f H%f", frame.size.width ,frame.size.height);
}







#pragma mark - Initializer
+(circleCollectionView *) newCircleCollectionViewWithData:(NSArray *) data withFrame:(CGRect)frame {
    
    circleCollectionViewLayout *circleLayout = [[circleCollectionViewLayout alloc] init];

    circleCollectionView * collectionView = [[circleCollectionView alloc] initWithFrame:frame collectionViewLayout:circleLayout];
    collectionView.dataArray = data;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    return collectionView;
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(circleCollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"circleCellView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];

        
        //[self registerClass:[circleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
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


#pragma mark - UIViewCollectionDelegateFlowLayout

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    float viewWidth = self.bounds.size.width;
    if (viewWidth == 0.0) {
        size = CGSizeMake(10.0, 10.0);
    } else {
        float height = self.bounds.size.height*0.6;
        float width = height/[self cellRatioLengthWidth];
        size = CGSizeMake(width,height);
        NSLog(@"item Size W%f H%f",size.width,size.height);
    }
    return size;
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
