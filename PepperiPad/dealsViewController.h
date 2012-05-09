//
//  dealsViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dealsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    //UIView *hostingView;
    UIScrollView* scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic) int selectedFundID;
//@property (nonatomic, retain) IBOutlet UIView *hostingView;
@end
