#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>



@interface MainViewController ()


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Wild Bikes!";

    ///// PARSE DATA
//    [self deleteAllBikes]; // NOT REQUIRED
//    [self initializeNewBikes]; // ONLY REQUIRED TO RUN ONCE – AT INITIALIZE OF CLOUD-DB
    [self printAllBikes];
    
}


- (IBAction)logOut:(id)sender {
    //    bool didUnlink = [PFFacebookUtils unlinkUser:[PFUser currentUser]];
    //    NSLog(didUnlink ? @"Did unlink from fb" : @"Did not unlink from fb");
    //    [self reauthenticateUser];
    [PFUser logOut];
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

#pragma mark -
#pragma mark CloudData methods
- (void) deleteAllBikes {
    
    // NOTE - this delete function doesn't seem to work / be able to delete all users. Could be a ACL/user issue.
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bicycle2"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            //            [PFObject deleteAll:objects];
//                        [PFObject deleteAllInBackground:objects];
            
            for (PFObject *object in objects) {
//                NSLog(@"%@", object[@"name"]);
                [object deleteInBackground];
//                [object deleteEventually];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void) printAllBikes {
    NSLog(@"---");
    PFQuery *query = [PFQuery queryWithClassName:@"Bicycle2"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"name"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        NSLog(@"--");
        
    }];
    
}

- (void) initializeNewBikes {
    // PARSE STUFF
    //   [self authenticateUser];
    
    // how to create e.g. a post specific to a user, and retreive all their posts:
    // Make a new object
    PFObject *bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    
//    PFObject *bicycle = [PFObject objectWithClassName:@"Bicycle2"]; [bicycle.ACL setPublicWriteAccess:YES]; [bicycle save];
    
    [bicycle.ACL setPublicWriteAccess:YES];
    
    NSString *name;
    NSNumber *isAvailable;
    
    PFGeoPoint *point;
    
    // Make a new object
    name = @"Speedster";
    point = [PFGeoPoint geoPointWithLatitude:-33.877212 longitude:151.213796];
    isAvailable = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"location"] = point;
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Sally";
    point = [PFGeoPoint geoPointWithLatitude:-33.878610 longitude:151.215856];
    isAvailable = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"location"] = point;
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Pikachu";
    point = [PFGeoPoint geoPointWithLatitude:-33.877255 longitude:151.216540];
    isAvailable = @0;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"location"] = point;
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Dragon";
    point = [PFGeoPoint geoPointWithLatitude:-33.877477 longitude:151.215682];
    isAvailable = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"location"] = point;
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Black Rider";
    point = [PFGeoPoint geoPointWithLatitude:-33.875313 longitude:151.215145];
    isAvailable = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"location"] = point;
    [bicycle save];
    
}


@end
