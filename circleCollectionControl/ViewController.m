//
//  ViewController.m
//  circleCollectionControl
//
//  Created by Olivier Delecueillerie on 02/01/2015.
//  Copyright (c) 2015 lagspoon. All rights reserved.
//

#import "ViewController.h"
#import "circleCollectionItemModel.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSArray *jsonArray;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) circleCollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Content extraction
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"objects" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"jsonString:%@",jsonString);
    
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
        NSLog(@"JSON Serialization Error %@", [error description]);
    }
    
    self.items = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary *dic in self.jsonArray) {
        [self.items addObject:[circleCollectionItemModel newWithName:[dic valueForKey:@"name"]
                                                            picture:[UIImage imageNamed:[dic valueForKey:@"picture"]]
                                                              color:[dic valueForKey:@"color"]]];
    }
    
    self.collectionView = [circleCollectionView newCircleCollectionViewEmbeddedIn:self.collectionViewContainer
                                                                      includeData:self.items
                                                               withAddButtonImage:[UIImage imageNamed:@"Add"]
                                                                      delegatedBy:self];
}

-(void) viewDidLayoutSubviews {
    //NSLog(@"view frame %f %f %f %f", self.collectionView.frame.origin.x,self.collectionView.frame.origin.y,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - circleCollectionView Delegate

-(void) addItem:(circleCollectionView *)collectionView {
    [collectionView addItemWithName:@"newItem" picture:[UIImage imageNamed:@"r2d2"] color:nil];
}


-(void) collectionView:(circleCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    circleCollectionItemModel *itemSelected = [self.collectionView.items objectAtIndex:indexPath.row];
    self.imageView.image = itemSelected.picture;
}

-(void) collectionView:(circleCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    circleCollectionItemModel *itemSelected = [self.collectionView.items objectAtIndex:indexPath.row];
    self.imageView.image = itemSelected.picture;
}



#pragma mark - Trigerred action
-(void) showDestructiveAlertVC {
    
    NSString *title = @"Delete player";
    NSString *message = @"The user and the scores will be deleted. This action cannot be undone.";
    NSString *cancelTitle =@"Cancel";
    NSString *destructiveTitle = @"Delete player";
    //UIAlertController for iOS 8
    if ([UIAlertController class]) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        [alertC addAction:[UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.collectionView deleteSelectedItem];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //NSLog(@"Cancel");
        }]];
        
        [self presentViewController:alertC animated:YES completion:^{
            //
        }];
    } else if ([UIActionSheet class]) {
        //UIAction sheet for previous version of iOS8
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self.collectionView deleteSelectedItem];
            break;
        case 1:
            //NSLog(@"Cancel");
            break;
        default:
            break;
    }
}
@end
