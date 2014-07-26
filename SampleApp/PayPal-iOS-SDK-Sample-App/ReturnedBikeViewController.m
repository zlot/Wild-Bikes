//
//  ReturnedBikeViewController.m

#import "ReturnedBikeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
#define kPayPalEnvironment PayPalEnvironmentSandbox

#define kOFFSET_FOR_KEYBOARD 110.0

@interface ReturnedBikeViewController ()


@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation ReturnedBikeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    self.donationAmount.keyboardType = UIKeyboardTypeNumberPad;
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




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:self.environment];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}




-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}





#pragma mark - Receive Single Payment

- (IBAction)pay:(id)sender {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Donation to Charity"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"15"]
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


- (IBAction)payWithDonationAmount:(id)sender {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Donation to Charity"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:self.donationAmount.text]
                                    withCurrency:@"AUD"
                                         withSku:@"WILD-001"];
    NSArray *items = @[item1];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [PayPalItem totalPriceForItems:items];
    payment.currencyCode = @"AUD";
    payment.shortDescription = @"Charity Donation";
    payment.items = items;
    payment.paymentDetails = nil;
    
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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
