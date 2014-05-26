//
//  MenuViewController.h
//  RT
//
//  Created by yiqin on 5/23/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void)updateCartSummary: (MenuViewController *)f
             fetchedText: (NSString *)s;

@end


@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *test2;

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;


-(void) fetchingText;


@end
