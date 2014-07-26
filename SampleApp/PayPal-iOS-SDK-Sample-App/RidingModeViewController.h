//
//  RidingModeViewController.h
//  WildBikesPaypalParse
//
//  Created by Mark C Mitchell on 27/07/2014.
//  Copyright (c) 2014 WildBikes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bicycle.h"

@interface RidingModeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *bikeName;

@property (nonatomic, retain) Bicycle *bike;
@property (weak, nonatomic) IBOutlet UILabel *passcode;

@end
