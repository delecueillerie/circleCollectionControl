//
//  circleCollectionViewLayout.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 03/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol circleCollectionViewLayoutDelegate <NSObject>

//- (float) cellRatioLengthWidth;

@end


@interface circleCollectionViewLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<circleCollectionViewLayoutDelegate> delegate;

@end
