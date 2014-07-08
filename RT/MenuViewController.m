//
//  MenuViewController.m
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import "MenuViewController.h"
#import <dispatch/dispatch.h>
#import "MenuListTableViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "CartSummary.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface MenuViewController ()
@property (nonatomic, strong) MenuListTableViewController *childViewController;
@property (nonatomic, strong) IBOutlet UILabel *cartLabel;
@property (nonatomic, assign) BOOL cartIsReady;
@property (nonatomic, assign) int dishCount;
@property (nonatomic, strong) NSNumber *orderNumber;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    self.cartIsReady = NO;
    
    // Do any additional setup after loading the view.
    self.childViewController = (MenuListTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuListTableViewController"];
    
    // Wonderful !
    [self.childViewController setDelegate:self];
    
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    [self.childViewController didMoveToParentViewController:self];
}



- (void)viewWillAppear:(BOOL)animated {
    self.childViewController.view.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 205);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confirmOrder:(id)sender {
    // Get the current date.
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    int i = [[dateFormat stringFromDate:date] intValue];
    
    // 11
    if (i < 11) {
        if (self.cartIsReady) {
            UIAlertView *confirmOrderAlert = [[UIAlertView alloc] initWithTitle:@"Your Cart" message:self.cartLabel.text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
            [confirmOrderAlert setTag:1];
            [confirmOrderAlert show];
        }
        else {
            UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:@"Your Cart" message:@"Please make an order. The cart is empty." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [continueAlert setTag:2];
            [continueAlert show];
        }
    }
    else {
        UIAlertView *shutDownAlert = [[UIAlertView alloc] initWithTitle:@"Your Cart" message:@"Please make the order between before 11:00 am" delegate:self cancelButtonTitle:@"See you tomorrow." otherButtonTitles: nil];
        [shutDownAlert setTag:3];
        [shutDownAlert show];
    }
}


- (void) saveCartToParse {
    [SVProgressHUD show];
    
    PFObject *orderPFObject = [PFObject objectWithClassName:@"OrdersGreatWall"];
    PFQuery *orderCount = [PFQuery queryWithClassName:@"OrdersGreatWall"];
    PFQuery *orderSaveOrderNumber = [PFQuery queryWithClassName:@"OrdersGreatWall"];
    
    orderPFObject[@"order"] = self.cartLabel.text;
    // id didn't work.
    orderPFObject[@"ID"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    // Get the current date.
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM dd, yyyy"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];

    NSString *dateString = [dateFormat stringFromDate:date];
    
    orderPFObject[@"date"] = dateString;
    
    // 1
    [orderPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
        if (succeeded) {

            // 2
            [orderCount whereKey:@"createdAt" lessThan:[orderPFObject createdAt]];
            [orderCount whereKey:@"date" equalTo:dateString];
            
            [orderCount countObjectsInBackgroundWithBlock:^(int count, NSError *error2) {
                if (!error2) {
                    self.orderNumber = [NSNumber numberWithInt:count+1];
                    NSString* currentOrder = [NSString stringWithFormat:@"NUMBER:#%i %@", count+1, self.cartLabel.text];
                    [[NSUserDefaults standardUserDefaults] setObject:currentOrder forKey:@"currentOrder"];
                    
                    // Send a message
                    [PFCloud callFunctionInBackground:@"sendMessageToTwillio"
                                       withParameters:@{@"order":currentOrder}
                                                block:^(NSString *result, NSError *error3) {
                                                    if (!error3) {
                                                        // NSLog(@"The message is sent.");
                                                    }
                                                }];
                    
                    // 3
                    [orderSaveOrderNumber getObjectInBackgroundWithId:[orderPFObject objectId] block:^(PFObject *currentOrderPFObject, NSError *error4) {
                        if (!error4) {
                            currentOrderPFObject[@"orderNumber"] = self.orderNumber;
                            [currentOrderPFObject saveInBackground];
                        }
                    }];
                    
                    // 4
                    // A bug is here.
                    // [self onPurchaseCompletedGATracking:[orderPFObject objectId]];
                    
                    // https://developers.google.com/analytics/devguides/collection/ios/v2/ecommerce
                    
                    // Assumes a tracker has already been initialized with a property ID, otherwise
                    // this call returns null.
                    id tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker send:[[GAIDictionaryBuilder createTransactionWithId:[orderPFObject objectId]
                                                                     affiliation:@"GreatWall"
                                                                         revenue:[NSNumber numberWithInt:(self.dishCount*5)]
                                                                             tax:0
                                                                        shipping:0
                                                                    currencyCode:@"USD"] build]];
                    
                    // 5
                    [self performSegueWithIdentifier:@"moveToRestaurant" sender:self];
                    [SVProgressHUD dismiss];
                }
            }];
        }
    }];
    
}

/*
 * Called when a purchase is processed and verified.
 */
- (void)onPurchaseCompletedGATracking: (NSString *) objectId {
    // Assumes a tracker has already been initialized with a property ID, otherwise
    // this call returns null.
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createTransactionWithId:objectId
                                                     affiliation:@"GreatWall"
                                                         revenue:[NSNumber numberWithInt:(self.dishCount*5)]
                                                             tax:0
                                                        shipping:0
                                                    currencyCode:@"USD"] build]];
}

#pragma mark - UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self saveCartToParse];
                break;
            default:
                break;
        }
    }
    else if (alertView.tag == 2) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Confirm");
                break;
            default:
                break;
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - MenuListTableViewController delegate
-(void) updateCartSummary:(MenuListTableViewController *)f fetchedText:(NSString *)cart dishCount:(int)i notEmpty:(BOOL)ready{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cartLabel.text = cart;
        self.cartIsReady = ready;
        self.dishCount = i;
    });

}

@end
