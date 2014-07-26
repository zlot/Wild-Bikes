//
//  BikeDetailViewController.m
//  WildBikes-Paypal-Parse
//
//  Created by Mark C Mitchell on 26/07/2014.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "BikeDetailViewController.h"

@implementation BikeDetailViewController

- (void)viewDidLoad
{
    self.uiNavigationItem.title = @"Dragon";
    
    NSString *bikeName = _bike.name;
    self.uiNavigationItem.title = bikeName;
}


@end
