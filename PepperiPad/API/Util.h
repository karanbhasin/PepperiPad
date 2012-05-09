//
//  Util.h
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;
+ (NSString *) toFormattedDateString:(NSDate *)date ;
+ (NSString*) formattedString:(id) val;
+ (NSString*) toFormattedCurrency:(int) val;
+ (NSString*) toDecimalString:(id) val;
+ (NSString*) toDecimalStringFromNumber:(double) val;
+ (NSString*) getSeperatedString: (NSString*) string;
+ (NSMutableDictionary* ) getFilteredDictionary : (NSDictionary*) original;
+ (NSMutableDictionary* ) getFilteredDictionary : (NSDictionary*) original
                               withPropertyNames: (NSArray*)properties
                                withOverrideKeys: (NSDictionary*) overrideKeys 
                                withDateKeys    : (NSArray*) dateKeys;
+ (BOOL) isValidValue : (id) val;
+ (NSMutableDictionary* ) getGraphData : (NSDictionary*) json
                           withKeyIndex: (int) keyIndex
                         withValueIndex: (int) valueIndex;
+ (NSMutableDictionary* ) getGraphData2 : (NSDictionary*) json
                             withContainerName:(NSString*) containerName
                             withKeyName:(NSString*)keyName
                           withValueName:(NSString*)valueName;
@end
