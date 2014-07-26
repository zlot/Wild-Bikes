//
//  ViewController.h
//  MapKitH
//
//  Created by Hanley Weng on 26/07/2014.
//  Copyright (c) 2014 Hanley Weng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    NSMutableArray *bikes;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
