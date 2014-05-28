//
//  MenuListTableViewController.h
//  RT
//
//  Created by yiqin on 5/25/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@class MenuListTableViewController;

@protocol MenuListTableViewControllerDelegate <NSObject>

-(void)updateCartSummary: (MenuListTableViewController *)f
             fetchedText: (NSString *)cart
               dishCount: (int)i
                notEmpty: (BOOL)ready;


@end

@interface MenuListTableViewController : PFQueryTableViewController <UITableViewDelegate>


@property (nonatomic, strong) NSMutableDictionary *cart;

@property (nonatomic, assign) id<MenuListTableViewControllerDelegate> delegate;

-(void) fetchingText;

@end
