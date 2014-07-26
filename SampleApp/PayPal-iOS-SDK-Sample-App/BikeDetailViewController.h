//
//  BikeDetailViewController.h
//  WildBikes-Paypal-Parse
//
//  Created by Mark C Mitchell on 26/07/2014.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "Bicycle.h"

@interface BikeDetailViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) Bicycle *bike;

@property (strong, nonatomic) IBOutlet UINavigationItem *uiNavigationItem;

@property (weak, nonatomic) IBOutlet UIImageView *bikeImage;

@property (weak, nonatomic) IBOutlet UILabel *bikeName;

@property (weak, nonatomic) IBOutlet UITextView *bikeDescription;

@property (weak, nonatomic) IBOutlet UIImageView *helmetImage;

@property (weak, nonatomic) IBOutlet UITextView *releasedText;

@end
