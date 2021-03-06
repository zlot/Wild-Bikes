//
//  Bicycle.h
//  WildBikesPaypalParse
//
//  Created by Hanley Weng on 27/07/2014.
//  Copyright (c) 2014 WildBikes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bicycle : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * passcode;
@property (nonatomic, retain) NSString * originalOwnerName;
@property (nonatomic, retain) NSString * bikeDescription;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * isAvailable;
@property (nonatomic, retain) NSNumber * hasHelmet;

@end
