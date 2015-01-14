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
@property (strong, nonatomic) circleCollectionView *collectionView;

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
    
    self.collectionView = [circleCollectionView newCircleCollectionViewWithData:self.items embeddedIn:self.collectionViewContainer];

}

-(void) viewDidLayoutSubviews {
    NSLog(@"view frame %f %f %f %f", self.collectionView.frame.origin.x,self.collectionView.frame.origin.y,self.collectionView.frame.size.width,self.collectionView.frame.size.height);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
