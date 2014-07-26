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
//    [self printAllBikes];
    
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
    NSNumber *hasHelmet;
    
    PFGeoPoint *point;
    
    // Make a new object
    name = @"Speedster";
    point = [PFGeoPoint geoPointWithLatitude:-33.877212 longitude:151.213796];
    isAvailable = @1;
    hasHelmet = @0;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"hasHelmet"] = hasHelmet;
    bicycle[@"location"] = point;
    bicycle[@"passcode"] = @"1322";
    bicycle[@"originalOwnerName"] = @"Flash";
    bicycle[@"bikeDescription"] = @"With 8 speeds to choose from, this valiant bike will blaze through the toughest of hills.";
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Sally";
    point = [PFGeoPoint geoPointWithLatitude:-33.878610 longitude:151.215856];
    isAvailable = @1;
    hasHelmet = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"hasHelmet"] = hasHelmet;
    bicycle[@"location"] = point;
    bicycle[@"passcode"] = @"4028";
    bicycle[@"originalOwnerName"] = @"Clare";
    bicycle[@"bikeDescription"] = @"This bike always makes for an enjoyable ride.";
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Pikachu";
    point = [PFGeoPoint geoPointWithLatitude:-33.877255 longitude:151.216540];
    isAvailable = @0;
    hasHelmet = @0;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"hasHelmet"] = hasHelmet;
    bicycle[@"location"] = point;
    bicycle[@"passcode"] = @"7534";
    bicycle[@"originalOwnerName"] = @"Ash";
    bicycle[@"bikeDescription"] = @"An electric ride.";
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Dragon";
    point = [PFGeoPoint geoPointWithLatitude:-33.877477 longitude:151.215682];
    isAvailable = @1;
    hasHelmet = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"hasHelmet"] = hasHelmet;
    bicycle[@"location"] = point;
    bicycle[@"passcode"] = @"221";
    bicycle[@"originalOwnerName"] = @"SwordSmith06";
    bicycle[@"bikeDescription"] = @"Slay those rode demons.";
    [bicycle save];
    
    bicycle = [PFObject objectWithClassName:@"Bicycle2"];
    name = @"Black Rider";
    point = [PFGeoPoint geoPointWithLatitude:-33.875313 longitude:151.215145];
    isAvailable = @1;
    hasHelmet = @1;
    bicycle[@"name"] = name;
    bicycle[@"isAvailable"] = isAvailable;
    bicycle[@"hasHelmet"] = hasHelmet;
    bicycle[@"location"] = point;
    bicycle[@"passcode"] = @"634";
    bicycle[@"originalOwnerName"] = @"Alan T";
    bicycle[@"bikeDescription"] = @"Smooth.";
    [bicycle save];
    
}


@end
