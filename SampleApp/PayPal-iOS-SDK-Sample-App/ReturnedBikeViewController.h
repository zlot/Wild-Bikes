//
//  ReturnedBikeViewController.h
//  WildBikesPaypalParse
//
//  Created by Mark C Mitchell on 27/07/2014.
//  Copyright (c) 2014 WildBikes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

#import "Bicycle.h"

@interface ReturnedBikeViewController : UIViewController <PayPalPaymentDelegate, UIPopoverControllerDelegate>

@property (nonatomic, retain) Bicycle *bike;

@property (weak, nonatomic) IBOutlet UILabel *bikeName;


@property (weak, nonatomic) IBOutlet UITextField *donationAmount;

- (IBAction)payWithDonationAmount:(id)sender;


/* PayPal stuff */
@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

- (IBAction)pay:(id)sender;

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property (weak, nonatomic) IBOutlet UIView *successView;


@end
