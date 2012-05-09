//
//  investorFundDetails.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface investorFundDetails : UIViewController <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>
{
    IBOutlet UITableView *table;
    UIView *hostingView;
}

@property (nonatomic, retain) IBOutlet UIView *hostingView;
@property (nonatomic, retain) NSMutableArray *fundsForinvestor;
@end
