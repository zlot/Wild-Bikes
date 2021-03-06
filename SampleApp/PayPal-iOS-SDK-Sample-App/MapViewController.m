//
//  ViewController.m
//  MapKitH
//
//  Created by Hanley Weng on 26/07/2014.
//  Copyright (c) 2014 Hanley Weng. All rights reserved.
//

#import "MapViewController.h"

#import <Parse/Parse.h>

#import "MyAnnotation.h"

#import "BikeDetailViewController.h"

#import "Bicycle.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // LOCAL VARS
    bikes = [[NSMutableArray alloc] init];
    
    // MAP
    // Set the mapView delegate to this View Controller
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    // UPDATES
    // update repetetively
    [self repeatingFetchBikesAndUpdateAllAnnotations];
    
    
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
    
    // Create MKPinAnnotationView - for custom annotations
    
    MyAnnotation *ann = (MyAnnotation *) annotation;
    Bicycle *bike = ann.bike;
    
    MKAnnotationView * annotationView;
    
    if ([bike.isAvailable boolValue] == NO) {
        
        static NSString *identifier = @"myAnnotation-inUse";
        annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
            
            annotationView.image = [UIImage imageNamed:@"MiniBike3.png"];
            
        }else {
            annotationView.annotation = annotation;
        }
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
    } else {
        
        static NSString *identifier = @"myAnnotation-available";
        annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
            
            annotationView.image = [UIImage imageNamed:@"MiniBike2.png"];
            
        }else {
            annotationView.annotation = annotation;
        }
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    }
    
    return annotationView;

}

// Delegate method - handle annotation tap
- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//    NSLog(@"calloutAccessoryControlTapped: annotation = %@", view.annotation);
    
    // don't segue if bike is in use
    MyAnnotation *annotation = (MyAnnotation *) view.annotation;
    if ([annotation.bike.isAvailable boolValue] == NO) {
        return;
    }
    
    [self performSegueWithIdentifier:@"MapToBikeSegue" sender:view]; // Note - sending view rather than self - in order to gain access to annotation
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    if ([segue.identifier isEqualToString:@"MapToBikeSegue"])
    {
        BikeDetailViewController *destinationViewController = segue.destinationViewController;
        
        MyAnnotation *annotation = (MyAnnotation *) sender.annotation;
        
//        destinationViewController.uiNavigationItem.title = [annotation title];
        
        destinationViewController.bike = [annotation bike];
        
    } else {
        NSLog(@"PFS:something else");
    }
}

// DATA
- (void) repeatingFetchBikesAndUpdateAllAnnotations
{
    
    float timeToWait = 2.0;
    int totalBikesFetched = (int) bikes.count;
    if (totalBikesFetched > 0) {
        timeToWait = 20.0;
    }
    
    [self fetchBikesAndupdateAllAnnotations];
    
    // Constantly call self.
    [NSTimer scheduledTimerWithTimeInterval:timeToWait
                                     target:self
                                   selector:@selector(repeatingFetchBikesAndUpdateAllAnnotations)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) fetchBikesAndupdateAllAnnotations
{
    //reset bikes
    bikes = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bicycle2"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            for (PFObject *object in objects) {
                
                // Create Coordinate
                PFGeoPoint *point = object[@"location"];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = point.latitude;
                coordinate.longitude = point.longitude;
                
                // Create Bike of Bikes
                Bicycle *bike = [[Bicycle alloc] init];
                bike.name = object[@"name"];
                bike.passcode = object[@"passcode"];
                bike.originalOwnerName = object[@"originalOwnerName"];
                bike.bikeDescription = object[@"bikeDescription"];
                bike.isAvailable = [NSNumber numberWithBool:[object[@"isAvailable"] boolValue]];
                bike.hasHelmet = [NSNumber numberWithBool:[object[@"hasHelmet"] boolValue]];
                bike.latitude = [NSNumber numberWithDouble:point.latitude];
                bike.longitude = [NSNumber numberWithDouble:point.longitude];
                [bikes addObject:bike];
            }
            
            [self updateAnnotationsFromBikes];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        NSLog(@"--Fetched-Bikes--");
        
    }];
}

- (void) updateAnnotationsFromBikes
{
    
    // remove all annotations (for now)
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    // Fill Annotations
    for (Bicycle *bike in bikes) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([bike.latitude doubleValue], [bike.longitude doubleValue]);
        NSString *text = @"In Use";
        if ([bike.isAvailable boolValue] == YES) {
            text = @"Available";
        }
        // Create Annotation
        MyAnnotation *annotation;
        annotation = [[MyAnnotation alloc] initWithCoordinate:coordinate title:text bike:bike];
        [self.mapView addAnnotation:annotation];
    }
}
@end
