//
//  RestaurantViewController.m
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import "RestaurantViewController.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)greatWall:(id)sender {
    [self performSegueWithIdentifier:@"moveToLocation" sender:self];
}

- (IBAction)orderHistory:(id)sender {
    [self performSegueWithIdentifier:@"moveToOrderHistory" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
}


@end
