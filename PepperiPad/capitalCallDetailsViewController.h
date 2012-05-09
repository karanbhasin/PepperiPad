//
//  capitalCallDetailsViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface capitalCallDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
}
@property (nonatomic, retain) NSMutableDictionary *activityDetails;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic) int selectedActivityID;
@end
