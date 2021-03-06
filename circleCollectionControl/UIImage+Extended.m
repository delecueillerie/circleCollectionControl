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
    [self drawAtPoint:origin];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)rounded {
    //resize image to small square
    UIImage *roundedImage;
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


- (UIImage *) iconForNavBarItem {
    
    float width = 44.0f;
    float inset = 5.0f;
    UIImage *squared = [self squareImageScaledToSize:width];
    UIImage *rounded = [squared rounded];
    
    CGSize size = CGSizeMake(width+inset, width+2*inset);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [rounded drawAtPoint:CGPointMake(0, inset)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(inset, 0, inset, inset)];
    
    return image;
}

- (UIImage *)imageWithBorderWidth:(float)lineWidth red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    CGSize size = [self size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0+lineWidth/2, 0+lineWidth/2, size.width-lineWidth, size.height-lineWidth);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokeEllipseInRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

@end
