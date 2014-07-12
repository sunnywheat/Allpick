//
//  MenuViewController.h
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MenuListTableViewController.h"
#import "GAITrackedViewController.h"

@class MenuListTableViewController;

@interface MenuViewController : GAITrackedViewController <MenuListTableViewControllerDelegate, UIAlertViewDelegate>
{
    @private
    MenuListTableViewController *menuListTableViewController;
}

@end
