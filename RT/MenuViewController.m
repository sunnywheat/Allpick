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

@interface MenuViewController ()
@property (nonatomic, strong) MenuListTableViewController *childViewController;
@property (nonatomic, strong) IBOutlet UILabel *cartLabel;
@property (nonatomic, assign) BOOL cartIsReady;
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
    self.childViewController.view.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 255);
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
    int i = [[dateFormat stringFromDate:date] intValue];
    // 11
    if (i < 24) {
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
    NSString *dateString = [dateFormat stringFromDate:date];
    
    orderPFObject[@"date"] = dateString;
    
    // 1
    [orderPFObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // create at time
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
            
            // 2
            [orderCount whereKey:@"createdAt" lessThan:[orderPFObject createdAt]];
            [orderCount whereKey:@"date" equalTo:dateString];
            
            [orderCount countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (!error) {
                    self.orderNumber = [NSNumber numberWithInt:count+1];
                    
                    NSString* currentOrder = [NSString stringWithFormat:@"%@\nNUMBER:%i\n\n%@",[formatter stringFromDate:[orderPFObject createdAt]], count+1, self.cartLabel.text];
                    [[NSUserDefaults standardUserDefaults] setObject:currentOrder forKey:@"currentOrder"];
                    
                    // 3
                    [orderSaveOrderNumber getObjectInBackgroundWithId:[orderPFObject objectId] block:^(PFObject *currentOrderPFObject, NSError *error) {
                        currentOrderPFObject[@"orderNumber"] = self.orderNumber;
                        [currentOrderPFObject saveInBackground];
                    }];
                    
                    [self performSegueWithIdentifier:@"moveToRestaurant" sender:self];
                    [SVProgressHUD dismiss];
                }
            }];
        }
    }];
    
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
-(void) updateCartSummary:(MenuListTableViewController *)f fetchedText:(NSString *)cart notEmpty:(BOOL)ready{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cartLabel.text = cart;
        self.cartIsReady = ready;
    });

}

@end
