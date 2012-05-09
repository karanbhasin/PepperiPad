//
//  capitalCallViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface capitalCallViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    UIView *hostingView;
}
@property (nonatomic) int selectedFundID;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) IBOutlet UIView *hostingView;
@property (nonatomic, retain) NSMutableDictionary *activityDetails;
@end
