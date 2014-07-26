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

    //////////// PARSE stuff
    [Parse setApplicationId:@"AxG1hPF80f8qyw9GR9L0l25nV2vArzX6aV7t32Se"
                  clientKey:@"RUb3mhez4QHgc8SlRjAaQsFou3SoTYhzZ4h7LsbZ"];
    
    [PFFacebookUtils initializeFacebook];
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    /////////// END PARSE STUFF
    
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"ASMhlxAMQU2G7pPdnVlJdvIsrfDVKHbvo9QlITudnHccHTRyMtMVfIDcwzyN",
                                                         PayPalEnvironmentSandbox : @"AWlyDRDv9N6I3TywZEAk0G5sZBZJPnZTCkTN5kRCiAVuNTeqVEoqxO2kwqp1"}];
    return YES;
}

@end
