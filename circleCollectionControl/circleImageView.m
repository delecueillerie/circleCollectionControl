//
//  circleImageView.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 08/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleImageView.h"
#import "UIImage+Extended.h"

@interface circleImageView ()

@property (strong, nonatomic) UIImage *roundedImage;
@end

@implementation circleImageView


-(void) setImage:(UIImage *)image {
    self.roundedImage = [image squareImageScaledToSize:image.size.width];
    NSLog(@"rounded Image W:%f H:%f",self.roundedImage.size.width,self.roundedImage.size.height);
    [super setImage:self.roundedImage];
}
-(void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
