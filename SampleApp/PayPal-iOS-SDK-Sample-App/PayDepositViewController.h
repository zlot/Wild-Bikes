

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

#import "Bicycle.h"

@interface PayDepositViewController : UIViewController <PayPalPaymentDelegate, UIPopoverControllerDelegate>

@property (nonatomic, retain) Bicycle *bike;

@property (weak, nonatomic) IBOutlet UILabel *bikeName;


/* PayPal stuff */
@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

- (IBAction)pay:(id)sender;

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property (weak, nonatomic) IBOutlet UIView *successView;


@end
