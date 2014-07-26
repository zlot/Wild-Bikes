//
//  ViewController.m
//  MapKitH
//
//  Created by Hanley Weng on 26/07/2014.
//  Copyright (c) 2014 Hanley Weng. All rights reserved.
//

#import "MapViewController.h"

#import "myAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the mapView delegate to this View Controller
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;

    
    
    // Set some coordinates
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = -33.877212;
    coordinate1.longitude = 151.213796;
    myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate1 title:@"Speedster"];
    [self.mapView addAnnotation:annotation];
    
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude = -33.878610;
    coordinate2.longitude = 151.215856;
    myAnnotation *annotation2 = [[myAnnotation alloc] initWithCoordinate:coordinate2 title:@"Sally"];
    [self.mapView addAnnotation:annotation2];
    
    CLLocationCoordinate2D coordinate3;
    coordinate3.latitude = -33.877255;
    coordinate3.longitude = 151.216540;
    myAnnotation *annotation3 = [[myAnnotation alloc] initWithCoordinate:coordinate3 title:@"Pikachu"];
    [self.mapView addAnnotation:annotation3];
    
    CLLocationCoordinate2D coordinate4;
    coordinate4.latitude = -33.877477;
    coordinate4.longitude = 151.215682;
    myAnnotation *annotation4 = [[myAnnotation alloc] initWithCoordinate:coordinate4 title:@"Dragon"];
    [self.mapView addAnnotation:annotation4];
    
    CLLocationCoordinate2D coordinate5;
    coordinate5.latitude = -33.875313;
    coordinate5.longitude = 151.215145;
    myAnnotation *annotation5 = [[myAnnotation alloc] initWithCoordinate:coordinate5 title:@"Black Rider"];
    [self.mapView addAnnotation:annotation5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set zoom location
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -33.877497;
    zoomLocation.longitude= 151.216027;
    
    // Set region show
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}


// Delegate method - returns the drawn view for an annotation to draw to mapView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    
    // Don't show the default annotation
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Create MKPinAnnotationView
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.pinColor = MKPinAnnotationColorGreen;// MKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

// Delegate method - handle annotation tap
- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped: annotation = %@", view.annotation);
    [self performSegueWithIdentifier:@"MapToBikeSegue" sender:self];
}

@end
