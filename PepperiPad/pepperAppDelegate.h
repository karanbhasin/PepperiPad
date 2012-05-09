//
//  pepperAppDelegate.h
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "loginViewController.h"

@interface pepperAppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) API *api;
// management of the UISplitViewController button and popover
@property (strong,nonatomic) UIBarButtonItem* masterBarButtonItem;
@property (strong,nonatomic) UIPopoverController* masterPopoverController;

@property (nonatomic, assign) loginViewController *loginViewController;
//@property (nonatomic, assign) LoginLoadingViewController *loginLoadingViewController;

- (void) openSplitViewController;
- (void) showActivityViewer:(NSString *)text;
- (void) hideActivityViewer;
- (void) returnToLogin;
@end
