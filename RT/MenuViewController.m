//
//  MenuViewController.m
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuListTableViewController.h"
#import <dispatch/dispatch.h>


#import <stdlib.h>
#import <unistd.h>

@interface MenuViewController ()
@property (nonatomic, strong) MenuListTableViewController *childViewController;
@property (strong, nonatomic) IBOutlet UILabel *cartLabel;

@end

@implementation MenuViewController

@synthesize delegate;

@synthesize test2;

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
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.childViewController = (MenuListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuListTableViewController"];
    [self addChildViewController:self.childViewController];
    [self.view addSubview:self.childViewController.view];
    [self.childViewController didMoveToParentViewController:self];

    self.cartLabel.text = [NSString stringWithFormat:@"The cart is: %@", self.childViewController.cart];

}



- (void)viewWillAppear:(BOOL)animated {
    self.childViewController.view.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 300);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
}

-(void)fetchingText
{
    [self.delegate updateCartSummary:self fetchedText:@"great"];
    
    NSLog(@"finally, here it is.");
    self.cartLabel.text = @"finally";
    [_cartLabel setText:@"Why"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.cartLabel.text = @"finally";
    });
    
    
}


@end
