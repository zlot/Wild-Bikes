//
//  ZZAppDelegate.m
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import "ZZAppDelegate.h"
#import "PayPalMobile.h"
#import <Parse/Parse.h>

@implementation ZZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Parse setApplicationId:@"AxG1hPF80f8qyw9GR9L0l25nV2vArzX6aV7t32Se"
                  clientKey:@"RUb3mhez4QHgc8SlRjAaQsFou3SoTYhzZ4h7LsbZ"];
    
#warning "Enter your credentials"
  [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"ASMhlxAMQU2G7pPdnVlJdvIsrfDVKHbvo9QlITudnHccHTRyMtMVfIDcwzyN",
                                                         PayPalEnvironmentSandbox : @"AWlyDRDv9N6I3TywZEAk0G5sZBZJPnZTCkTN5kRCiAVuNTeqVEoqxO2kwqp1"}];
  return YES;
}

@end
