//
//  circleCollectionView.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "circleCollectionViewLayout.h"

@interface circleCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+(circleCollectionView *) newCircleCollectionViewWithData:(NSArray *)data withFrame:(CGRect)frame;

@end
