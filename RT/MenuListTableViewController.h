//
//  MenuListTableViewController.h
//  RT
//
//  Created by yiqin on 5/25/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface MenuListTableViewController : PFQueryTableViewController <UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *cart;

@end
