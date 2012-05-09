//
//  UserDefaults.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

@synthesize entityCode = _entityCode;;
@synthesize password = _password;
@synthesize userName = _userName;

+ (UserDefaults *)sharedInstance {
	static UserDefaults *sharedInstance;
	
	@synchronized(self) {
		if (!sharedInstance) {
			sharedInstance = [[UserDefaults alloc] init];
		}
	}
	
	return sharedInstance;
}


+ (void)removeDefaults {
	if (![[UserDefaults sharedInstance] rememberUser]) {
		[UserDefaults killAllDefaults];
	}
}

+ (void)killAllDefaults {
	// Remove all the defaults currently shown in this file, currently
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"entityCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)entityCode {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *returnVal = [userDefaults stringForKey:@"entityCode"];
	
	if (returnVal != NULL) {
		return returnVal;
	}
	else {
		return(nil);
	}
    
	return returnVal;
}

- (void)setEntityCode: (NSString*)aValue {
	
	[[NSUserDefaults standardUserDefaults] setObject:aValue forKey:@"entityCode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *returnVal = [userDefaults stringForKey:@"password"];
	
	if (returnVal != NULL) {
		return returnVal;
	}
	else {
		return(nil);
	}
    
	return returnVal;
}

- (void)setPassword: (NSString*)aValue {
	
	[[NSUserDefaults standardUserDefaults] setObject:aValue forKey:@"password"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userName {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *returnVal = [userDefaults stringForKey:@"username"];
	
	if (returnVal != NULL) {
		return returnVal;
	}
	else {
		return(nil);
	}
    
	return returnVal;
}

- (void)setUserName: (NSString*)aValue {
	
	[[NSUserDefaults standardUserDefaults] setObject:aValue forKey:@"username"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)rememberUser {	
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"remember_me"];
}

- (void)setRememberUser: (BOOL)aValue {
	[[NSUserDefaults standardUserDefaults] setBool:aValue forKey:@"remember_me"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)loggedUser {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	// Get the data representation of the person
	NSData *data = [userDefaults objectForKey:@"logged_user"];
	// decode the data
	id returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	if (returnValue) {
		return returnValue;
	}
	else {	
		return nil;
	}
}

- (void) setLoggedUser: (id)aValue {
	
	// This is a way of serializing the data for saving
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aValue];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"logged_user"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}


@end

