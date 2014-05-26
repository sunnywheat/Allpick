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

@class MenuListTableViewController;

@interface MenuViewController : UIViewController <MenuListTableViewControllerDelegate>
{
    @private
    MenuListTableViewController *menuListTableViewController;
}


@end
