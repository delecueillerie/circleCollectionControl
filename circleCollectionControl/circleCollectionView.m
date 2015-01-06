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


@property (nonatomic) CGSize viewSize;
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
    
    collectionView.backgroundColor = [UIColor grayColor];
    
    return collectionView;
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    circleCollectionViewCell *cell;

    cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.item];
    
    cell.label.text = [item valueForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:[item valueForKey:@"picture"]];
    cell.borderView.layer.borderWidth = 1;
    
    NSArray *RGBColor = [item valueForKey:@"color"];
    cell.borderView.layer.borderColor = [[UIColor colorWithRed:[(NSNumber *)RGBColor[0] floatValue]
                                                   green:[(NSNumber *)RGBColor[0] floatValue]
                                                    blue:[(NSNumber *)RGBColor[0] floatValue]
                                                   alpha:1.0] CGColor];
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
    
    
}


#pragma mark - UIViewCollectionDelegateFlowLayout

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize viewSize = self.bounds.size;
    CGSize size = CGSizeMake(viewSize.width/5, viewSize.height);
    NSLog(@"item Size W%f H%f",size.width,size.height);
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
