//
//  myAnnotation.h
//  MapKitH
//
//  Created by Hanley Weng on 26/07/2014.
//  Copyright (c) 2014 Hanley Weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "Bicycle.h"

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) Bicycle *bike;

- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString *)title;
- (id) initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString *)title bike:(Bicycle *) bike;

@end
