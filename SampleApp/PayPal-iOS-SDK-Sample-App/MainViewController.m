#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface MainViewController ()

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Wild Bikes!";
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Wild Bikes";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    
    
    ///// PARSE DATA
//    [self deleteAllBikes]; // NOT REQUIRED
//    [self initializeNewBikes]; // ONLY REQUIRED TO RUN ONCE – AT INITIALIZE OF CLOUD-DB
    [self printAllBikes];
    
}

- (void)authenticateUser {
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser.username != nil) {
        // can use this session token to get info out of core database?
        NSLog(@"currentUser.sessionToken: %@",currentUser.sessionToken);
        
    } else {
        [PFFacebookUtils logInWithPermissions:@[@"publish_actions"] block:^(PFUser *user, NSError *error) {
            // link existing PFUser to Facebook account.
            //on successful login, the existing PFUser is updated with the Facebook information. Future logins via Facebook will now log in the user to their existing account.
            if (![PFFacebookUtils isLinkedWithUser:user]) {
                [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Woohoo, user logged in with Facebook!");
                    }
                }];
            }
            
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                // succeeded!
                NSLog(@"User logged in through Facebook!");
                NSLog(@"currentUser.sessionToken: %@",currentUser.sessionToken);
            }
        }];
    }
}

- (void)reauthenticateUser {
    [PFFacebookUtils reauthorizeUser:[PFUser currentUser]
              withPublishPermissions:@[@"publish_actions"]
                            audience:FBSessionDefaultAudienceFriends
                               block:^(BOOL succeeded, NSError *error) {
                                   if (succeeded) {
                                       NSLog(@"Woohoo, user logged in with Facebook!");
                                   }
                               }];
}

- (IBAction)logOut:(id)sender {
    //    bool didUnlink = [PFFacebookUtils unlinkUser:[PFUser currentUser]];
    //    NSLog(didUnlink ? @"Did unlink from fb" : @"Did not unlink from fb");
    //    [self reauthenticateUser];
    [PFUser logOut];
    
    [self authenticateUser];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:self.environment];
}

#pragma mark - Receive Single Payment

- (IBAction)pay {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Donation to Charity"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.01"]
                                    withCurrency:@"AUD"
                                         withSku:@"WILD-001"];
    NSArray *items = @[item1];
    //NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items]; //NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [PayPalItem totalPriceForItems:items];
    payment.currencyCode = @"AUD";
    payment.shortDescription = @"Charity Donation";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}



#pragma mark -
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}



#pragma mark -
#pragma mark Helpers

- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
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
