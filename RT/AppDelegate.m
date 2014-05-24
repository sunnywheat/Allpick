//
//  AppDelegate.m
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//


#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Colours.h"
#import <Mixpanel.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Define color.
    UIColor *barTintColor = [UIColor black25PercentColor];
    UIColor *tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UITabBar appearance] setTintColor:barTintColor];
    // White or black
    [[UINavigationBar appearance] setTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : tintColor}];
    // Set status bar style
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Parse.com
    [Parse setApplicationId:@"k0QlMNHfsjaER2oY0DlZI7nB9B0xs2kgDpPcicDe"
                  clientKey:@"mEOp2cVa2wCZtWSHqVlTpeXdQIps8w3O88oUzT6c"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Test Parse.com
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    NSDictionary *dimensions = @{
                                 // What type of news is this?
                                 @"category": @"politics",
                                 // Is it a weekday or the weekend?
                                 @"dayType": @"weekday",
                                 };
    // Send the dimensions to Parse along with the 'read' event
    
    [PFAnalytics trackEvent:@"read" dimensions:dimensions];
    
    // Mixpanel
    [Mixpanel sharedInstanceWithToken:@"0e27a8b5b6dcf19dba41a6c118a1d354"];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    // Track an event in Mixpanel Engagement
    [mixpanel identify:[[UIDevice currentDevice] name]];
    [mixpanel.people set:@{@"Plan": @"Early Version"}];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
