//
//  circleCollectionItemModel.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 15/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface circleCollectionItemModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *picture;
@property (strong, nonatomic) UIColor *color;

+(instancetype)newWithName:(NSString *)name picture:(UIImage *)picture color:(UIColor *)color;

@end
