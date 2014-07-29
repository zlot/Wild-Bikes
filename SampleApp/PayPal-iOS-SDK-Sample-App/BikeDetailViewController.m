//
//  BikeDetailViewController.m
//  WildBikes-Paypal-Parse
//
//  Created by Mark C Mitchell on 26/07/2014.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "BikeDetailViewController.h"

#import "RidingModeViewController.h"
#import "MapViewController.h"

#import <Parse/Parse.h>

#import "MyAnnotation.h"

#import "Bicycle.h"

#define METERS_PER_MILE 1609.344

@implementation BikeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // LOCAL VARS
    bikes = [[NSMutableArray alloc] init];
    
    
    // set bike name
    NSString *myBikeName = _bike.name;
    self.bikeName.text = myBikeName;
    
    // set title
    self.uiNavigationItem.title = myBikeName;
//    self.bikeDescription.text = _bike.bikeDescription;

    
    [self.bikeImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@".png"]]];
    
    if([_bike.hasHelmet intValue] == 1) {
        [self.helmetImage setImage:[UIImage imageNamed: @"Helmet.png"]];
    }
    
    [self.bikeOwnerImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@".png"]]];
    
    [self.bikeOwnerImage setImage:[UIImage imageNamed: [myBikeName stringByAppendingString:@"_Owner.png"]]];
        
    NSString *appendedText = [@"Released into the wild by " stringByAppendingString:_bike.originalOwnerName];
    self.releasedText.text = appendedText;
 
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    
    tempScrollView.contentSize=CGSizeMake(320,850);
    
    // LOAD LOCATION - INIT
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    // MAP
    // Set the mapView delegate to this View Controller
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    
    // UPDATES
    // update repetetively
    [self repeatingFetchBikesAndUpdateAllAnnotations];
    
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
            annotationView.canShowCallout = NO;
            
            annotationView.image = [UIImage imageNamed:@"BikeLocation.png"];
            
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
            annotationView.canShowCallout = NO;
            
            annotationView.image = [UIImage imageNamed:@"BikeLocation.png"];
            
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



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BikeToRiding"])
    {
        RidingModeViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.bike = self.bike;
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
    
//    // Constantly call self.
//    [NSTimer scheduledTimerWithTimeInterval:timeToWait
//                                     target:self
//                                   selector:@selector(repeatingFetchBikesAndUpdateAllAnnotations)
//                                   userInfo:nil
//                                    repeats:NO];
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
    
    ///////////////////////////// PROOF OF CONCEPT LOCATIONS!
    for (int i=0; i<10; i++) {
        
        float low_bound = -33.87;
        float high_bound = -33.88;
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        
                double latitude = rndValue;
        
        low_bound = 151.21;
        high_bound = 151.22;
        rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        
        double longitude = rndValue;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MyAnnotation *annotation;
        annotation = [[MyAnnotation alloc] initWithCoordinate:coordinate title:@""];
        [self.mapView addAnnotation:annotation];
    }
    
}








// LOCATION FUNCTIONS
// callback

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    // Calculate distance between coordinates
    CLLocation *bikeLocation = [[CLLocation alloc] initWithLatitude:[_bike.latitude doubleValue] longitude:[_bike.longitude doubleValue]];
    
    CLLocationDistance distance = [bikeLocation distanceFromLocation:newLocation];
    int distanceMetres = distance;
    if (distanceMetres > 70) {
        NSString *text = [ NSString stringWithFormat:@"You are %d m away! Get nearer to ride.", distanceMetres];
//        NSLog(@"%@", text);
        
        // FAR MODE
//        [_farText setText:text];
//        [_farText setAlpha:1];
        [_nearButton setAlpha:0];
        [_nearButton setUserInteractionEnabled:NO];
        _farText.text = text;

        
    } else {
        NSLog(@"Good to go! %d", distanceMetres);
        
        // NEAR MODE
        [_farText setAlpha:0];
        [_nearButton setAlpha:1];
        [_nearButton setUserInteractionEnabled:YES];
    }
}

@end
