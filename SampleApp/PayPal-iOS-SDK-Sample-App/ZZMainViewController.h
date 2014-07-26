//
//  ZZMainViewController.h
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import "PayPalMobile.h"

@interface ZZMainViewController : UIViewController <PayPalPaymentDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@end
