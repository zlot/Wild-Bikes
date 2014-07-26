#import "PayDepositViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
#define kPayPalEnvironment PayPalEnvironmentSandbox

#define kOFFSET_FOR_KEYBOARD 110.0

@interface PayDepositViewController ()


@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation PayDepositViewController

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
    
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    // set bike name
    NSString *myBikeName = _bike.name;
    self.bikeName.text = myBikeName;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:self.environment];
}


#pragma mark - Receive Single Payment

- (IBAction)pay:(id)sender {
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Bike Deposit"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"15"]
                                    withCurrency:@"AUD"
                                         withSku:@"WILD-001"];
    NSArray *items = @[item1];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [PayPalItem totalPriceForItems:items];
    payment.currencyCode = @"AUD";
    payment.shortDescription = @"Bike Deposit";
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
    
    [self performSegueWithIdentifier:@"DepositToUnlockBikeSegue" sender:self];
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
