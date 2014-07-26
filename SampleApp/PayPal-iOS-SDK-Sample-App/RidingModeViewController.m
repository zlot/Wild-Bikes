//
//  RidingModeViewController.m
//  WildBikesPaypalParse
//
//  Created by Mark C Mitchell on 27/07/2014.
//  Copyright (c) 2014 WildBikes. All rights reserved.
//

#import "RidingModeViewController.h"
#import "ReturnedBikeViewController.h"

@interface RidingModeViewController ()

@end

@implementation RidingModeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set bike name
    NSString *myBikeName = _bike.name;
    self.bikeName.text = myBikeName;
    
	self.passcode.text = _bike.passcode;

    // DISABLE BACK
    // set the left bar button to a nice trash can
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:nil];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RidingToDonation"])
    {
        ReturnedBikeViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.bike = self.bike;
    } else {
        NSLog(@"PFS:something else");
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
