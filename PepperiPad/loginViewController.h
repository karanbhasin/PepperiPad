//
//  loginViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    /*
	NSString		*username;
	NSString		*password;
	NSString		*entityCode;
	NSArray         *textLabels;
	UIView			*myView;*/
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *entityCode;
@property (nonatomic, retain) NSArray *textLabels;
@property (nonatomic, retain) UIView *myView;

@end
