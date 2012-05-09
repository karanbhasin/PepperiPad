//
//  API.h
//  Calculator
//
//  Created by Singh, Jaskaran on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject
-(BOOL) logInUser:(NSString*)uname 
     withPassword:(NSString*)pwd
        forEntity:(NSString*)entity;
-(void) Print;
-(NSData*) GetFunds:(NSString*) fundName;
-(NSData*) GetFundsWithDetails:(int) fundId;
-(NSData*) GetFundDetail:(int) fundId;
-(NSData*) GetInvestorsInFund:(int) fundId;
-(NSData*) GetCapitalCalls:(int) fundId;
-(NSData*) GetCapitalDistributions:(int) fundId;
-(NSData*) GetDeals:(int) fundId;
-(NSData*) GetDealDetails:(int) dealId;
-(NSData*) GetCapitalDistributionInvestors:(int) capitalDistributionId;
-(NSData*) GetUnderlyingFunds;
-(NSData*) GetDirects ;
-(NSData*) GetDirectDetails:(int) directId ;
-(NSData*) GetInvestors ;

@property (nonatomic, retain) NSError* LastError;
@property (nonatomic, retain) NSString* LastRequestURL;
@property (nonatomic, retain) NSString* LastRedirectLocation;
@property (nonatomic) BOOL IsAuthenticated;
@end
