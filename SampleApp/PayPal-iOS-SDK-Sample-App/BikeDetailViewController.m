//
//  BikeDetailViewController.m
//  WildBikes-Paypal-Parse
//
//  Created by Mark C Mitchell on 26/07/2014.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "BikeDetailViewController.h"

#import "RidingModeViewController.h"

@implementation BikeDetailViewController

- (void)viewDidLoad
{
    // set bike name
    NSString *myBikeName = _bike.name;
    self.bikeName.text = myBikeName;
    
    // set title
    self.uiNavigationItem.title = myBikeName;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BikeToRiding"])
    {
        RidingModeViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.bike = self.bike;
    } else {
        NSLog(@"PFS:something else");
    }
}

@end
