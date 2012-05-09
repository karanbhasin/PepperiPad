//
//  fundDetailsViewController.h
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fundDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>
{
    IBOutlet UITableView *table;
    UIView *hostingView;
}

@property (nonatomic) int selectedFundID;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) IBOutlet UIView *hostingView;
@end
