//
//  circleCollectionViewCell.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionViewCell.h"
#import "UIImage+Extended.h"

@interface circleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation circleCollectionViewCell

#pragma mark - Accessors
-(void) setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    //self.imageView.clipsToBounds = YES;
    //self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2;
    //self.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    //self.imageView.layer.shadowOpacity = 0.5;
    //self.imageView.layer.borderWidth = 2;
    /*self.imageView.layer.borderColor = [[UIColor colorWithRed:[(NSNumber *)self.RGBColor[0] floatValue]
                                                        green:[(NSNumber *)self.RGBColor[1] floatValue]
                                                         blue:[(NSNumber *)self.RGBColor[2] floatValue]
                                                        alpha:1.0] CGColor];
*/
    
}
-(void) setTextLabel:(NSString *)textLabel {
    _textLabel = textLabel;
    self.label.text = _textLabel;
}

-(void) setImage:(UIImage *)image {
    _image = [image rounded];
    self.imageView.image = _image;
}

#pragma mark - Initializer

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //self.contentMode = UIViewContentModeScaleAspectFit;


        //self.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return self;
}

-(void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        
        //self.imageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectInset(self.imageView.bounds,1,1)] CGPath];
        
    }
    
}

+(float) nativeRatioHeightWidth {
    NSArray *viewArray = [[UINib nibWithNibName:@"circleCellView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil];
    UIView *view = [viewArray firstObject];
    float ratio = view.bounds.size.height/view.bounds.size.width;
    NSLog(@"cell ratio %f", ratio);
    return (ratio);
}
  
@end
