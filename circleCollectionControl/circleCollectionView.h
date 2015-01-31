//
//  circleCollectionView.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "circleCollectionViewLayout.h"
@class circleCollectionView;

@protocol circleCollectionViewDelegate <NSObject>

-(void) collectionView:(circleCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
-(void) collectionView:(circleCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
-(void) addItem:(circleCollectionView *)collectionView;
-(void) showDestructiveAlertVC;
//-(void) collectionView:(circleCollectionView *)collectionView didLongPressItemAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface circleCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+(circleCollectionView *) newCircleCollectionViewEmbeddedIn:(UIView *)viewContainer includeData:(NSArray * )data withAddButtonImage:(UIImage *)addButtonImage delegatedBy:(id)delegate;
-(void)addItemWithName:(NSString *)name picture:(UIImage *)picture color:(UIColor *)color;
-(void) deleteSelectedItem;
-(void) longPressOnItem:(UILongPressGestureRecognizer *)sender;


@property (weak, nonatomic) id <circleCollectionViewDelegate> delegateCircleCollectionView;
@property (strong, nonatomic) NSMutableArray *items;
@end
