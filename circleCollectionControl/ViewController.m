//
//  ViewController.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "ViewController.h"
#import "circleCollectionView.h"


@interface ViewController ()
@property (strong, nonatomic) NSArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    circleCollectionView *collectionView = [circleCollectionView newCircleCollectionViewWithData:self.items withFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100.0)];
    [self.view addSubview:collectionView];
    
    
    //layout constraint settings
    [NSLayoutConstraint constraintWithItem:collectionView
                                 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
}

- (void) viewWillAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
