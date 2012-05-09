//
//  UserDefaults.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

@property (readwrite, retain) NSString *entityCode;
@property (readwrite, retain) NSString *password;
@property (readwrite, retain) NSString *userName;
@property (readwrite, assign) BOOL rememberUser;

+ (UserDefaults *)sharedInstance; 
+ (void)removeDefaults;
+ (void)killAllDefaults;


@end
