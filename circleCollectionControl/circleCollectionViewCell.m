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

@property (strong, nonatomic) UIImage *imageSelected;

@end

@implementation circleCollectionViewCell

@synthesize selected = _selected;
#pragma mark - Accessors



-(UIImage *) imageSelected {
    if (!_imageSelected) {
        if (self.borderColor) {
            CGFloat red, green, blue, alpha;
            [self.borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
            _imageSelected = [self.image imageWithBorderWidth:25.0f red:red green:green blue:blue alpha:alpha];
        } else {
            _imageSelected = self.image;
        }
    }
    return _imageSelected;
}

-(void) setTextLabel:(NSString *)textLabel {
    _textLabel = textLabel;
    self.label.text = _textLabel;
}

-(void) setImage:(UIImage *)image {
    _image = [image rounded];
    self.imageSelected = nil;
    self.imageView.image = _image;

}

-(void) setSelected:(BOOL)selectedValue {
    _selected = selectedValue;
    if (_selected) {
        self.imageView.image = self.imageSelected;
    } else {
        self.imageView.image = self.image;
    }
}
-(void) setCollectionView:(circleCollectionView *)collectionView {
    _collectionView = collectionView;
    for (UIGestureRecognizer *gReco in self.gestureRecognizers) {
        [self removeGestureRecognizer:gReco];
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:_collectionView action:@selector(longPressOnItem:)];
    [self addGestureRecognizer:longPress];
}




#pragma mark - Initializer

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}


#pragma mark - Utilities
+(float) nativeRatioHeightWidth {
    NSArray *viewArray = [[UINib nibWithNibName:@"circleCellView" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil];
    UIView *view = [viewArray firstObject];
    float ratio = view.bounds.size.height/view.bounds.size.width;
    //NSLog(@"cell ratio %f", ratio);
    return (ratio);
}

-(void) roundedEdge {
   // NSLog(@"Corner Radius %f", self.label.frame.size.width/2.0f);
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView.layer setNeedsDisplay];
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.clipsToBounds = YES;
    
}


@end
