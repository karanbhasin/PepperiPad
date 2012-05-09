//
//  Util.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

@implementation Util

// http://stackoverflow.com/questions/1757303/parsing-json-dates-on-iphone
+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)string {
    if(string != nil){
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    }
    return nil;
}

+ (NSString *) toFormattedDateString:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *string=[dateFormatter stringFromDate:date];
    return string;
}

+(NSString*) toFormattedCurrency:(int) val{
    NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:0];
    NSString *formatted = [frm stringFromNumber:[NSNumber numberWithInt:val]];
    return formatted;
    
}

+(NSString*) toDecimalString:(NSString*) val{
    //return [NSString stringWithFormat: @"%.2f", val];
    
    NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:val];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    return [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:someAmount]];
}

+(NSString*) toDecimalStringFromNumber:(double) val{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0.00" ];
    
    NSString *string = [formatter stringFromNumber:[ NSNumber numberWithDouble:val ] ];
    return string;
    // string is now "1,234,567.89"
}

+ (NSString*) formattedString:(id) val{
    return [NSString stringWithFormat:@"%@",val];
}

+(NSString*) getSeperatedString: (NSString*) string{
    // http://stackoverflow.com/questions/7322498/insert-or-split-string-at-uppercase-letters-objective-c
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:NULL];
    NSString *newString = [regexp stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"$1 $2"];
    NSLog(@"Changed '%@' -> '%@'", string, newString);
    return newString;
}

// The returned json sometimes has format like "Carry":null, in which case we dont want to set
+ (id) getValueFromJson:(id) val {
    if([val isKindOfClass:[NSString class]]){ 
        return val;
    }
    return nil;
}

// The returned json sometimes has format like "Carry":null, in which case we dont want to parse the value
+ (BOOL) isValidValue : (id) val{
    // NSLog(@"Class name %@", [val class]);
    if([val isKindOfClass:[NSString class]] && [val length] > 0) {
        return true;
    } else if([val isKindOfClass:[NSNumber class]]){
        return true;
    }
    return false;
}

+ (NSMutableDictionary* ) getFilteredDictionary : (NSDictionary*) original
                               withPropertyNames: (NSArray*)properties 
                                withOverrideKeys: (NSDictionary*) overrideKeys  
                                withDateKeys    : (NSArray*) dateKeys  {
    NSMutableDictionary* filteredDictionary = [[NSMutableDictionary alloc] init];
    NSEnumerator *enumerator = [original keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id val = [original objectForKey:key];
        if([Util isValidValue:val]){
            // Its a valid value
            if([properties containsObject:key]){
                NSString* overrideKey = (NSString*)key;
                // see if we have the override key
                if(overrideKeys){
                    if([[overrideKeys allKeys] containsObject:key]){
                        overrideKey = (NSString*)[overrideKeys objectForKey:key];
                    } else {
                        overrideKey = [Util getSeperatedString:overrideKey];
                    }
                }
                if(dateKeys && [dateKeys containsObject:key]){
                    val = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)val]];
                } else {
                    val = [Util formattedString:val];
                }
                [filteredDictionary setValue:val forKey:overrideKey];
            }
        }
    }
    return filteredDictionary;
}

+ (NSMutableDictionary* ) getGraphData : (NSDictionary*) json
                           withKeyIndex: (int) keyIndex
                           withValueIndex: (int) valueIndex
{
        
    NSMutableDictionary *keyValueDict = [[NSMutableDictionary alloc] init];
    
    // the data will be of the following format
    //{"page":1,"total":6,"rows":[{"cell":[42,"AMBERBROOK II LLC","82677f098e5e47ebb3c2526ff","\/Date(874882800000)\/","\/Date(1093993200000)\/",19000000.0000,16663986.3074]},{"cell":[43,"AMBERBROOK III LLC","4d17e7eef6794885aed6f3cb1","\/Date(962319600000)\/","\/Date(1183158000000)\/",75000000.0000,119014.7249]},{"cell":[44,"AMBERBROOK IV LLC","48e0f36fd3dc4d8bb0c0e4077","\/Date(1097708400000)\/","\/Date(1425168000000)\/",134062269.6600,-2844649.6808]},{"cell":[41,"AMBERBROOK LLC","2424a2ace6484276888ffb865","\/Date(804553200000)\/",null,5000000.0000,4979490.6098]},{"cell":[45,"AMBERBROOK V LLC","14f820143e3e46acb09cdd556","\/Date(1204070400000)\/","\/Date(1520899200000)\/",301650000.0000,46750285.9667]},{"cell":[46,"TEST AMBERBROOK FUND","12345","\/Date(1335394800000)\/","\/Date(1335394800000)\/",null,null]}]}
    
    NSMutableArray *myData = [json objectForKey:@"rows"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[myData count]; i++){        
        NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:i];
        if([[dict objectForKey:@"cell"] objectAtIndex:valueIndex] != (id)[NSNull null]){
            NSString* desc = [[[dict objectForKey:@"cell"] objectAtIndex:valueIndex] description];
            if([desc hasPrefix:@"$"]){
                desc = [desc substringFromIndex:1];
            }
            //float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:valueIndex] floatValue];
            float totalCommitment = [desc floatValue];
            NSNumber *num = [NSNumber numberWithFloat:totalCommitment];
            [array addObject:num];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray* sortedValues = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSLog(@"Sorted Values: %@", sortedValues);
    int counter = 0;
    NSMutableArray* copyDict = (NSMutableArray*)[myData mutableCopy];
    NSMutableArray* sortedKeys = [[NSMutableArray alloc] init];
    float rest = 0;
    for (NSNumber* num in sortedValues) {
        NSLog(@"%f", [num floatValue]);
        if(counter < 5){
            for (int i=0; i<[copyDict count]; i++){
                NSDictionary* dict = (NSDictionary*)[copyDict objectAtIndex:i];
                if([[dict objectForKey:@"cell"] objectAtIndex:5] != (id)[NSNull null]){
                    //float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:valueIndex] floatValue];
                    NSString* desc = [[[dict objectForKey:@"cell"] objectAtIndex:valueIndex] description];
                    if([desc hasPrefix:@"$"]){
                        desc = [desc substringFromIndex:1];
                    }
                    //float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:valueIndex] floatValue];
                    float totalCommitment = [desc floatValue];
                    if(totalCommitment == [num floatValue]){
                        NSString* key = [[dict objectForKey:@"cell"] objectAtIndex:keyIndex];
                        [sortedKeys addObject:key];
                        [copyDict removeObject:dict];
                        break;
                    }
                }
            }
        } else {
            rest+= [num floatValue];
        }
        counter++;
    }
    NSLog(@"Sorted Keys: %@", sortedKeys);
    
    
    for (int i=0; i<[sortedKeys count]; i++){
        [keyValueDict setObject:[sortedValues objectAtIndex:i] forKey: [sortedKeys objectAtIndex:i]];
    }
    if(counter > 5){
       [keyValueDict setObject:[NSNumber numberWithFloat:rest] forKey: @"Others"];
    }
    
    return keyValueDict;
    
}

+ (NSMutableDictionary* ) getGraphData2 : (NSDictionary*) json
                                            withContainerName:(NSString*) containerName
                                            withKeyName:(NSString*)keyName
                                            withValueName:(NSString*)valueName

{
    
    NSMutableDictionary *keyValueDict = [[NSMutableDictionary alloc] init];
    
    // the data will be of the following format
    // {"FundId":25,"FundName":"Amberbrook (MK Test #2)","DetailType":0,"CapitalCommitted":10000000.0000,"CapitalCalled":3000000.0000,"UnfundedAmount":7773999.9999,"ManagementFees":324000.0000,"FundExpenses":450000.0000,"CapitalCalls":[{"CapitalCallId":37,"Number":"3","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":36000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1317423600000)\/","CapitalCallDueDate":"\/Date(1318201200000)\/"},{"CapitalCallId":36,"Number":"2","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":144000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1320105600000)\/","CapitalCallDueDate":"\/Date(1320969600000)\/"},{"CapitalCallId":35,"Number":"1","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":144000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1317423600000)\/","CapitalCallDueDate":"\/Date(1318201200000)\/"}],"CapitalDistributed":2000000.0000,"ReturnManagementFees":165000.0000,"ReturnFundExpenses":75000.0000,"ProfitsReturned":52500.0000,"CapitalDistributions":[{"CapitalDistrubutionId":14,"Number":"3","InvestorName":null,"CapitalDistributed":500000.0000,"ReturnManagementFees":15000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":139500.0000,"ProfitReturn":17500.0000,"LPProfit":117180.0000,"CostReturn":null},{"CapitalDistrubutionId":13,"Number":"2","InvestorName":null,"CapitalDistributed":1000000.0000,"ReturnManagementFees":75000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":79500.0000,"ProfitReturn":17500.0000,"LPProfit":66780.0000,"CostReturn":null},{"CapitalDistrubutionId":12,"Number":"1","InvestorName":null,"CapitalDistributed":500000.0000,"ReturnManagementFees":75000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325116800000)\/","CapitalDistributionDueDate":"\/Date(1325116800000)\/","Profit":79500.0000,"ProfitReturn":17500.0000,"LPProfit":66780.0000,"CostReturn":null}]}
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSMutableArray* capitalCalls = [json objectForKey:containerName];
    for (int i=0; i<[capitalCalls count]; i++){        
        NSDictionary* dict = (NSDictionary*)[capitalCalls objectAtIndex:i];
        //CapitalCallAmount
        if([dict objectForKey:valueName] != (id)[NSNull null]){
            float value = [[dict objectForKey:valueName] floatValue];
            NSNumber *num = [NSNumber numberWithFloat:value];
            [array addObject:num];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray* sortedValues = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    int counter = 0;
    NSMutableArray* copyDict = (NSMutableArray*)[capitalCalls mutableCopy];
    NSMutableArray* sortedKeys = [[NSMutableArray alloc] init];
    float rest = 0;
    for (NSNumber* num in sortedValues) {
        NSLog(@"%f", [num floatValue]);
        if(counter < 5){
            for (int i=0; i<[copyDict count]; i++){
                NSDictionary* dict = (NSDictionary*)[copyDict objectAtIndex:i];
                if([dict objectForKey:valueName] != (id)[NSNull null]){
                    float value = [[dict objectForKey:valueName] floatValue];
                    if(value == [num floatValue]){
                        NSString* key = [dict objectForKey:keyName];
                        [sortedKeys addObject:key];
                        [copyDict removeObject:dict];
                        break;
                    }
                }
            }
        } else {
            rest+= [num floatValue];
        }
        counter++;
    }
    
    
    for (int i=0; i<[sortedKeys count]; i++){
        NSLog(@"Sorted Key:%@", [sortedKeys objectAtIndex:i]);
        NSLog(@"Sorted Value:%@", [sortedValues objectAtIndex:i]);
        [keyValueDict setObject:[sortedValues objectAtIndex:i] forKey: [sortedKeys objectAtIndex:i]];
    }
    if(counter > 5){
        [keyValueDict setObject:[NSNumber numberWithFloat:rest] forKey: @"Others"];
    }
    
    return keyValueDict;
    
}



@end
