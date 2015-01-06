//
//  circleCollectionViewCell.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "circleCollectionViewCell.h"

@implementation circleCollectionViewCell


#pragma mark - Accessors


-(UIView *) borderView {
    if (!_borderView) {
        _borderView = [self viewWithTag:0];
    }
    return _borderView;
}


-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = (UIImageView*) [self viewWithTag:1];
    }
    return _imageView;
}

-(UILabel *) label {
    if ((!_label)) {
        _label = (UILabel *) [self viewWithTag:2];
    }
    return _label;
}

/*
 @property (weak, nonatomic) IBOutlet UIImageView *imageView;
 @property (weak, nonatomic) IBOutlet UILabel *label;
 @property (weak, nonatomic) IBOutlet UIView *borderView;
*/

#pragma mark - Initializer
-(instancetype) init {
    
    self = [super init];
    
    if (self) {
        //
        
        
        
    }
    
    return self;
}
@end
