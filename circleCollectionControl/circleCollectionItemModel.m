//
//  circleCollectionItemModel.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 15/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionItemModel.h"

@implementation circleCollectionItemModel


+(instancetype)newWithName:(NSString *)name picture:(UIImage *)picture color:(UIColor *)color {
    circleCollectionItemModel *newItem = [[circleCollectionItemModel alloc] init];
    newItem.name = name;
    newItem.picture = picture;
    if (color) {
        newItem.color = color;
    } else {
        newItem.color = [UIColor blackColor];
    }

    
    return newItem;
}
@end
