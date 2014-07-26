//
//  ZZAppDelegate.m
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import "ZZAppDelegate.h"
#import "PayPalMobile.h"

@implementation ZZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#warning "Enter your credentials"
  [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"ASMhlxAMQU2G7pPdnVlJdvIsrfDVKHbvo9QlITudnHccHTRyMtMVfIDcwzyN",
                                                         PayPalEnvironmentSandbox : @"AWlyDRDv9N6I3TywZEAk0G5sZBZJPnZTCkTN5kRCiAVuNTeqVEoqxO2kwqp1"}];
  return YES;
}

@end
