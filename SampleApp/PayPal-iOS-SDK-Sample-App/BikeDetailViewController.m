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
    
    if([_bike.hasHelmet intValue] == 1) {
        [self.helmetImage setImage:[UIImage imageNamed: @"Helmet.png"]];
    }
    
    [self.bikeOwnerImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@".png"]]];
    
    [self.bikeOwnerImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@"_Owner.png"]]];
        
    NSString *appendedText = [@"Released into the wild by " stringByAppendingString:_bike.originalOwnerName];
    self.releasedText.text = appendedText;
    
    // LOAD LOCATION - INIT
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

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

// LOCATION FUNCTIONS
// callback

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    // Calculate distance between coordinates
    CLLocation *bikeLocation = [[CLLocation alloc] initWithLatitude:[_bike.latitude doubleValue] longitude:[_bike.longitude doubleValue]];
    
    CLLocationDistance distance = [bikeLocation distanceFromLocation:newLocation];
    int distanceMetres = distance;
    if (distanceMetres > 70) {
        NSString *text = [ NSString stringWithFormat:@"You are %d m away! Come closer to ride.", distanceMetres];
        NSLog(@"%@", text);
        
        // FAR MODE
        [_farText setAlpha:1];
        [_nearButton setAlpha:0];
        [_nearButton setUserInteractionEnabled:NO];
        
    } else {
        NSLog(@"Good to go! %d", distanceMetres);
        
        // NEAR MODE
        [_farText setAlpha:0];
        [_nearButton setAlpha:1];
        [_nearButton setUserInteractionEnabled:YES];
    }
}

@end
