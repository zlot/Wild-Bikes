//
//  myAnnotation.m
//  MapKitH
//
//  Created by Hanley Weng on 26/07/2014.
//  Copyright (c) 2014 Hanley Weng. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate = coordinate;
        self.title = title;
    }
    return self;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString *)title bike:(Bicycle *)bike {
    if ((self = [super init])) {
        self.coordinate = coordinate;
        self.title = title;
        self.bike = bike;
    }
    return self;
}

@end
