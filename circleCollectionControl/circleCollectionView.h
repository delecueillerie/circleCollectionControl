//
//  circleCollectionView.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "circleCollectionViewLayout.h"

@protocol circleCollectionViewDelegate <NSObject>

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface circleCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, circleCollectionViewLayoutDelegate>

+(circleCollectionView *) newCircleCollectionViewWithData:(NSArray *) data embeddedIn:(UIView *)viewContainer delegatedBy:(id)delegate;

@property (weak, nonatomic) id <circleCollectionViewDelegate> delegateCircleCollectionView;
@end
