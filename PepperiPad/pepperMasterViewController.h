//
//  pepperMasterViewController.h
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pepperDetailViewController;

@interface pepperMasterViewController : UITabBarController<UISplitViewControllerDelegate>
@property (strong, nonatomic) pepperDetailViewController *detailViewController;

@end

