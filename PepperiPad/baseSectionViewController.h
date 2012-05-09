//
//  baseSectionViewController.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pepperAppDelegate.h"

@interface baseSectionViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    pepperAppDelegate *appDelegate;
}
- (NSString *)labelForIndexPath :(NSIndexPath *)indexPath ;    
- (NSString *)textForIndexPath:(NSIndexPath *)indexPath;    
- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath ;
@property (nonatomic, readonly) pepperAppDelegate *appDelegate;
@property (nonatomic) int selectedID;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@end
