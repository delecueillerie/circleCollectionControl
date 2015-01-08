//
//  ViewController.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "ViewController.h"
#import "circleCollectionView.h"

#import "circleCollectionViewCell.h"




#import "UIImage+Extended.h"


@interface ViewController ()
@property (strong, nonatomic) NSArray *items;

@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIImage *cherries = [UIImage imageNamed:@"Cherries"];
    self.imageView.image = [cherries rounded];
    //[self roundedImage:cherries];
    //self.imageView.image = [UIImage imageNamed:@"Cherries"];
    
    
    
    
    
    //Content extraction
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"objects" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"jsonString:%@",jsonString);
    
    self.items = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
    NSLog(@"JSON Serialization Error %@", [error description]);
    }
    //View loading
    //(self.view.bounds.size.height/2)-100
    circleCollectionView *collectionView = [circleCollectionView newCircleCollectionViewWithData:self.items withFrame:self.collectionViewContainer.frame];

    //NSArray *array = [[UINib nibWithNibName:@"circleCellView" bundle:[NSBundle mainBundle]]instantiateWithOwner:self options:nil];
    //NSArray *array = [[UINib nibWithNibName:@"View" bundle:[NSBundle mainBundle]]instantiateWithOwner:self options:nil];

    //NSLog(@"array count %li", [array count] );
    //UIView *collectionView = [array firstObject];
    NSLog(@"view frame %f %f %f %f", collectionView.frame.origin.x,collectionView.frame.origin.y,collectionView.frame.size.width,collectionView.frame.size.height);

    [self.view addSubview:collectionView];
    //layout constraint settings
    //collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    //collectionView.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
    /*[self.view addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:collectionView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0 constant:0.0]];
*/
    

}

- (void) viewWillAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)roundedImage:(UIImage *)image {
    //resize image to small square
    UIImage *roundedImage = [UIImage new];
    UIImage *squareImage = [self squareImageFromImage:image scaledToSize:MIN(image.size.width, image.size.height)];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(squareImage.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect theRect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:theRect
                                cornerRadius:image.size.width/2] addClip];
    // Draw your image
    [image drawInRect:theRect];
    
    // Get the image, here setting the UIImageView image
    roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
@end
