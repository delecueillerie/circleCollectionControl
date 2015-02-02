//
//  circleCollectionViewCell.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "circleCollectionView.h"

@interface circleCollectionViewCell : UICollectionViewCell





@property (weak, nonatomic) circleCollectionView *collectionView;
@property (strong, nonatomic) NSString *textLabel;
@property (strong, nonatomic) UIImage *image;
@property (strong ,nonatomic) UIColor *borderColor;


-(void) roundedEdge;

+(float) nativeRatioHeightWidth;
@end
