//
//  fundsViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fundInvestorsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    UIView *hostingView;
    NSMutableArray *myData;
}
@property (nonatomic) int selectedFundID;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) IBOutlet UIView *hostingView;
@end
