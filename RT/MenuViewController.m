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

#import <stdlib.h>
#import <unistd.h>

@interface MenuViewController ()
@property (nonatomic, strong) MenuListTableViewController *childViewController;
@property (nonatomic, strong) IBOutlet UILabel *cartLabel;
@property (nonatomic, assign) BOOL cartIsReady;

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
    
    self.cartIsReady = YES;
    
    // Do any additional setup after loading the view.
    self.childViewController = (MenuListTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuListTableViewController"];
    
    // Wonderful !
    [self.childViewController setDelegate:self];
    
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    [self.childViewController didMoveToParentViewController:self];
}



- (void)viewWillAppear:(BOOL)animated {
    self.childViewController.view.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 250);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmOrder:(id)sender {
    if (self.cartIsReady) {
        NSLog(@"Thank you.");
    }
    else {
        NSLog(@"make more");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
}



#pragma mark -
-(void) updateCartSummary:(MenuListTableViewController *)f fetchedText:(NSString *)cart notEmpty:(BOOL)ready{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cartLabel.text = cart;
        self.cartIsReady = ready;
    });

}

@end
