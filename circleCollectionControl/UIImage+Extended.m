//
//  UIImage+Extended.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "UIImage+Extended.h"

@implementation UIImage (Extended)


- (UIImage *)squareImageScaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (self.size.width > self.size.height) {
        CGFloat scaleRatio = newSize / self.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(self.size.width - self.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / self.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(self.size.height - self.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    UIImage *image = [UIImage new];
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)rounded {
    //resize image to small square
    UIImage *roundedImage = [UIImage new];
    float size = MIN(self.size.width, self.size.height);
    UIImage *squareImage = [self squareImageScaledToSize:size];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(squareImage.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect theRect = CGRectMake(0, 0, size, size);
    [[UIBezierPath bezierPathWithRoundedRect:theRect
                                cornerRadius:size/2] addClip];
    // Draw your image
    [self drawInRect:theRect];
    
    // Get the image, here setting the UIImageView image
    roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

@end
