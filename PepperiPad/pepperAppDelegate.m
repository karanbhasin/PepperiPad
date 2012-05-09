//
//  pepperAppDelegate.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "pepperAppDelegate.h"

@implementation pepperAppDelegate

@synthesize window = _window;
@synthesize api = _api;
@synthesize splitViewController = _splitViewController;
@synthesize masterBarButtonItem = __masterBarButtonItem;
@synthesize masterPopoverController = __masterPopoverController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    // NOTE: By default when you create a Master Detail application, the UISplitViewController is set as the 
    // root controller, as the following code sets the master and detail. Since we have a login screen before the user can
    // actually use the application, comment this code out. HOWEVER, REMEMBER to initialize the delegate using the same following code after the user
    // logs in ( in loginViewController.authenticateUser)
    /*
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
     */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) showActivityViewer:(NSString *)text {	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	UIView *activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
	activityView.tag = 100;
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activityViewBg.png"]];
	backgroundImageView.frame = CGRectMake(0, 0, backgroundImageView.frame.size.width, backgroundImageView.frame.size.height);
	
	UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.window.bounds.size.width / 2 - 18, 208, 36, 36)];
	activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									  UIViewAutoresizingFlexibleRightMargin |
									  UIViewAutoresizingFlexibleTopMargin |
									  UIViewAutoresizingFlexibleBottomMargin);
	[activityWheel startAnimating];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, self.window.bounds.size.width, 40)];
	label.font = [UIFont boldSystemFontOfSize:18];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.text = text;
	label.backgroundColor = [UIColor clearColor];
    
	[activityView addSubview:backgroundImageView];
	[activityView addSubview:activityWheel];
	[activityView addSubview:label];
	
	[self.window addSubview:activityView];
}

- (void) hideActivityViewer {
	UIView *activityView = (UIView *)[self.window viewWithTag:100];
	activityView.hidden = YES;
	[activityView removeFromSuperview];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) openSplitViewController {
    [self.window addSubview:self.splitViewController.view];
    // Remove the login view
    // [self.loginViewController.view removeFromSuperview];
}

@end
