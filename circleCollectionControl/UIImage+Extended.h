//
//  UIImage+Extended.h
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extended)
- (UIImage *)squareImageScaledToSize:(CGFloat)newSize;
- (UIImage *)rounded;
- (UIImage *)imageWithBorderWidth:(float)lineWidth red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
@end
