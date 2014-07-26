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
//    self.bikeDescription.text = _bike.bikeDescription;

    
    [self.bikeImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@".png"]]];
    
    if(_bike.hasHelmet == 1) {
        [self.helmetImage setImage:[UIImage imageNamed: @"Helmet.png"]];
    }
        
    NSString *appendedText = [@"Released into the wild by " stringByAppendingString:_bike.originalOwnerName];
    self.releasedText.text = appendedText;

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
