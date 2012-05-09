//
//  API.m
//  Calculator
//
//  Created by Singh, Jaskaran on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "API.h"

// Private variables. To declare private variables, you use the interface keyword with the name of your class followed by closed braces
@interface API()
// nonatomic means that this property is not thread safe
@property (nonatomic, retain) NSString* URL;
//@property (nonatomic, retain) NSString* Username;
//@property (nonatomic, retain) NSString* Password;
@property (nonatomic, retain) NSString* LoginURL;
@property (nonatomic, retain) NSString* ListFundsURL;
@property (nonatomic, retain) NSString* ListFundsWithDetailsURL;
@property (nonatomic, retain) NSString* FundDetaiURL;
@property (nonatomic, retain) NSString* FundInvestorsURL;
@property (nonatomic, retain) NSString* CapitalCallURL;
@property (nonatomic, retain) NSString* DealsURL;
@property (nonatomic, retain) NSString* DealDetailsURL;
@property (nonatomic, retain) NSString* CapitalDistributionInvestorsURL;
@property (nonatomic, retain) NSString* UnderlyingFundsURL;
@property (nonatomic, retain) NSString* DirectsURL;
@property (nonatomic, retain) NSString* DirectDetailsURL;
@property (nonatomic, retain) NSString* InvestorsURL;
@property (nonatomic, retain) NSString* CapitalDistributionURL;
@property (nonatomic, retain) NSString* UserAgent;
@property (nonatomic, retain) NSString* ContentType;
@property (nonatomic, retain) NSDictionary* AuthCookie;@end

@implementation API
// The private property declared above has to be implemented. To provider default getters and setters use the synthesize keyword
@synthesize URL = _URL;
//@synthesize Username = _Username;
//@synthesize Password= _Password;
@synthesize LoginURL= _LoginURL;
@synthesize ListFundsURL= _ListFundsURL;
@synthesize ListFundsWithDetailsURL= _ListFundsWithDetailsURL;
@synthesize FundDetaiURL = _FundDetaiURL;
@synthesize FundInvestorsURL = _FundInvestorsURL;
@synthesize CapitalCallURL = _CapitalCallURL;
@synthesize CapitalDistributionURL = _CapitalDistributionURL;
@synthesize DealsURL = _DealsURL;
@synthesize DealDetailsURL = _DealDetailsURL;
@synthesize CapitalDistributionInvestorsURL = _CapitalDistributionInvestorsURL;
@synthesize UnderlyingFundsURL = _UnderlyingFundsURL;
@synthesize DirectsURL = _DirectssURL;
@synthesize DirectDetailsURL = _DirectDetailsURL;
@synthesize InvestorsURL = _InvestorsURL;
@synthesize UserAgent = _UserAgent;
@synthesize ContentType = _ContentType;
@synthesize AuthCookie = _AuthCookie;
@synthesize LastError = _LastError;
@synthesize LastRequestURL = _LastRequestURL;
@synthesize LastRedirectLocation = _LastRedirectLocation;
@synthesize  IsAuthenticated = _IsAuthenticated;

NSString* AuthCookieName = @".ASPXAUTH";

-(NSDictionary * )AuthCookie{
    NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:self.URL]];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
    return headers;
}

-(BOOL) IsAuthenticated{
    NSDictionary* cookies = self.AuthCookie;
    /* {
    Cookie = ".ASPXAUTH=634264DAED21327F8C1C4FBE1F24F077D3F7F599BC8CD584C0D8A5F3B961287CE3BC7267C4F71099B80222F96B52E5BA4CD20B6B66E2641E77172CA0287413F538DA12BB2FA5F3B7C0A4E9F74D783CCAAE8A0E7C6190AF79A7CD9085AA7B175E4171CD6070F3345CD02880361A01C44DA5FEDAB1615F9216119DBB1190514797DE964E31E5C3B3B5BF6D55F2CA94EFAE; ASP.NET_SessionId=ac3gvyvi5fctjs3pggx1erdv; mnuresize=";
     }
     */
    NSLog(@"AuthCookies: %@", cookies);
    NSString* cookie = (NSString*)[cookies objectForKey:@"Cookie"];
    if(cookie != nil){
        if ([cookie rangeOfString:AuthCookieName options:(NSCaseInsensitiveSearch)].location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
}


- (id)init
{
    NSLog(@"In API.Init");
    self = [super init];
    //self.URL = @"http://ec2-107-21-154-104.compute-1.amazonaws.com";
    self.URL = @"http://ec2-184-73-10-134.compute-1.amazonaws.com";
    //self.URL = @"http://www.harmeetnandrey.com";
    self.LoginURL = @"Account/LogOn";    
    self.ListFundsURL = @"Fund/FindFunds?term=";
    self.ListFundsWithDetailsURL = @"Fund/List?pageIndex=1&pageSize=500&sortName=FundName&sortOrder=asc&fundId=0";
    self.FundDetaiURL = @"Fund/FindFund/%@";
    self.FundInvestorsURL = @"Fund/InvestorFundList?pageIndex=1&pageSize=25&sortName=InvestorName&sortOrder=asc&fundId=%@";
    self.CapitalCallURL = @"CapitalCall/FindDetail?fundId=%@";
    self.CapitalDistributionURL = @"CapitalCall/FindDetail?fundId=%@";
    self.DealsURL = @"Deal/ActivityDealsList?pageIndex=1&pageSize=500&sortName=&sortOrder=asc&fundId=%@";
    self.CapitalDistributionInvestorsURL = @"CapitalCall/GetCapitalDistributionInvestors?capitalDistributionId=%@";
    self.UnderlyingFundsURL = @"Deal/UnderlyingFundList?pageIndex=1&pageSize=500&sortName=FundName&sortOrder=asc&isGP=true&gpId=0&underlyingFundID=0&companyId=0";
    self.DirectsURL = @"/Deal/DirectList?pageIndex=1&pageSize=50&sortName=DirectName&sortOrder=asc&isGP=false&companyId=0";
    self.DirectDetailsURL = @"/Deal/UnderlyingDirectList?pageIndex=1&pageSize=500&sortName=Symbol&sortOrder=asc&companyId=%@";
    self.InvestorsURL = @"/Investor/InvestorLibraryList?pageIndex=1&pageSize=500";
    self.ContentType = @"application/json; charset=utf-8";
    self.UserAgent = @"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; SLCC1; .NET CLR 2.0.50727; InfoPath.2; .NET CLR 3.5.21022;";
    
    /*
    List of open deals for a particular fund
        /Deal/DealList?pageIndex=1&pageSize=25&sortName=DealName&sortOrder=asc&isNotClose=true&fundId=32&dealId=0
        
        Deal details, including the underlying funds and directs in the deal
        /Deal/FindDeal/?dealId=607
        
        List of all deals for a fund, with details about the deal like its NPP, GPP, Commited Amount, FMV
            /Deal/ActivityDealsList?pageIndex=1&pageSize=25&sortName=&sortOrder=asc&fundId=32
            
            Details about underlying funds and directs in the deal
            /Deal/DealUnderlyingDetails/?dealId=58
            
            Detail about Capital Call for the underlying fund in the deal
                /Deal/GetUnderlyingFundCapitalCalls?pageIndex=1&pageSize=25&sortName=UnderlyingFundName&sortOrder=asc&underlyingFundID=1162&dealID=588&dealUnderlyingDirectID=0
                
       */         
                

    return self;
}

-(void)Print{
    NSLog(@"In Print");
}


-(NSString*)GetUrl:(NSString*) relativeURL{
    return [self.URL stringByAppendingString:[NSString stringWithFormat: @"/%@", relativeURL] ];
}

-(NSData*) GetFunds:(NSString*) fundName{
    NSString * fundURL = [self GetUrl:self.ListFundsURL];
    NSError *error;
    NSURLResponse *response;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fundURL]];
    // Set the auth cookie
    [request setAllHTTPHeaderFields:self.AuthCookie];

    
    [ request setHTTPMethod: @"GET" ];
    [ request setValue:self.ContentType forHTTPHeaderField:@"content-type"];
    // No need for this
    [request setValue:self.UserAgent forHTTPHeaderField:@"user-agent"];
    
    //NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    //NSLog(@"responseData: %@", content);
    
    NSLog(@"Request being sent to url:%@", fundURL);
    
    [NSURLConnection connectionWithRequest:request delegate:nil];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    // Debugging code
    NSString * stringReply = (NSString *)[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    // Some debug code, etc.
    NSLog(@"reply from server: %@", stringReply);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode]; 
    /*
     if(statusCode != 200){
     NSLog(@"There was an error. The Status code is: %@", statusCode);
     return NO;
     }*/
    NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
    NSLog(@"HTTP Status code: %d", statusCode);
    // End debugging code
    return returnData;

}

-(NSData*) GetFundsWithDetails:(int) fundId {
    NSString * fundURL = [self GetUrl:self.ListFundsWithDetailsURL];
    NSError *error;
    NSURLResponse *response;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: fundURL]];
    // Set the auth cookie
    [request setAllHTTPHeaderFields:self.AuthCookie];
    
    
    [ request setHTTPMethod: @"GET" ];
    [ request setValue:self.ContentType forHTTPHeaderField:@"content-type"];
    // No need for this
    [request setValue:self.UserAgent forHTTPHeaderField:@"user-agent"];
    
    NSLog(@"Request being sent to url:%@", fundURL);
    
    [NSURLConnection connectionWithRequest:request delegate:nil];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    // Debugging code
    NSString * stringReply = (NSString *)[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    // Some debug code, etc.
    NSLog(@"reply from server: %@", stringReply);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode]; 
    /*
     if(statusCode != 200){
     NSLog(@"There was an error. The Status code is: %@", statusCode);
     return NO;
     }*/
    NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
    NSLog(@"HTTP Status code: %d", statusCode);
    // End debugging code
    return returnData;
    
}


-(NSData*) SendRequest:(NSString*) url
                IsPost:(BOOL) isPost
{
    self.LastRedirectLocation = nil;
    self.LastRequestURL = nil;
    
    NSString* httpMethod = @"GET";
    if(isPost){
        httpMethod = @"POST";
    }
    
    NSString * urlToSendTo = [self GetUrl:url];
    NSError *error;
    NSURLResponse *response;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlToSendTo]];
    // Set the auth cookie
    [request setAllHTTPHeaderFields:self.AuthCookie];
    [ request setHTTPMethod: httpMethod ];
    [ request setValue:self.ContentType forHTTPHeaderField:@"content-type"];
    // No need for this
    [request setValue:self.UserAgent forHTTPHeaderField:@"user-agent"];
    
    NSLog(@"Request being sent to url:%@", urlToSendTo);
    NSLog(@"HTTP Method:%@", httpMethod);

    
    [NSURLConnection connectionWithRequest:request delegate:nil];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    // Debugging code
    NSString * stringReply = (NSString *)[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    // Some debug code, etc.
    NSLog(@"reply from server: %@", stringReply);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode]; 
    
    NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
    NSLog(@"HTTP Status code: %d", statusCode);
    // End debugging code
    return returnData;   
}

-(NSData*) GetCapitalCalls:(int) fundId{
    NSString* url = [NSString stringWithFormat: self.CapitalCallURL, fundId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetCapitalDistributions:(int) fundId{
    NSString* url = [NSString stringWithFormat: self.CapitalDistributionURL, fundId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetDeals:(int) fundId{
    NSString* url = [NSString stringWithFormat: self.DealsURL, fundId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetDealDetails:(int) dealId{
    NSString* url = [NSString stringWithFormat: self.DealDetailsURL, dealId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetCapitalDistributionInvestors:(int) capitalDistributionId{
    NSString* url = [NSString stringWithFormat: self.CapitalDistributionInvestorsURL, capitalDistributionId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetInvestorsInFund:(int) fundId{
    NSString* url = [NSString stringWithFormat: self.FundInvestorsURL, fundId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetFundDetail:(int) fundId{
    NSString* url = [NSString stringWithFormat: self.FundDetaiURL, fundId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetUnderlyingFunds {
    return [self SendRequest:self.UnderlyingFundsURL IsPost:NO];
}

-(NSData*) GetDirects {
    return [self SendRequest:self.DirectsURL IsPost:NO];
}

-(NSData*) GetDirectDetails:(int) directId {
    NSString* url = [NSString stringWithFormat: self.DirectDetailsURL, directId];
    return [self SendRequest:url IsPost:NO];
}

-(NSData*) GetInvestors {
    return [self SendRequest:self.InvestorsURL IsPost:NO];
}

-(BOOL) logInUser:(NSString*)uname 
     withPassword:(NSString*)pwd
        forEntity:(NSString*)entity{

    self.LastRedirectLocation = nil;
    self.LastRequestURL = nil;
    NSString *loginURL = [self GetUrl:self.LoginURL];
    
    // Prepare the data to be sent
    NSError *error;
    NSURLResponse *response;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: loginURL]];
    NSString* myRequestString = [NSString stringWithFormat: @"UserName=%@&Password=%@&EntityCode=%@", uname, pwd, entity];
    
    
    NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
    // No need for this
    //[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"]; 
    [ request setHTTPMethod: @"POST" ];
    [ request setHTTPBody: myRequestData ];
    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // No need for this
    [request setValue:self.UserAgent forHTTPHeaderField:@"user-agent"];
    
    //NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    //NSLog(@"responseData: %@", content);
    
    NSLog(@"Data To Send %@, url:%@", myRequestString, loginURL);
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    // Debugging code
    NSString * stringReply = (NSString *)[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    // Some debug code, etc.
    NSLog(@"reply from server: %@", stringReply);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode]; 
    /*
    if(statusCode != 200){
        NSLog(@"There was an error. The Status code is: %@", statusCode);
        return NO;
    }*/
    NSLog(@"HTTP Response Headers %@", [httpResponse allHeaderFields]); 
    NSLog(@"HTTP Status code: %d", statusCode);
    // End debugging code
    // Check to make sure that the we got a redirect from the server. The server would redirect only if the login was successful
    /*
    if(self.LastRedirectLocation != nil){
        return YES;
    }*/
    return YES;
}

    
// Delegate method to intercept a 302 redirect
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response {
    NSLog(@"In the connection delegate");
    if (response) {
        if([response statusCode] == 302){
            NSLog(@"This is a redirect");
            // Get the Cookie
            NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:self.URL]];
            NSLog(@"How many Cookies: %d", all.count);
            // Store the cookies:
            // NSHTTPCookieStorage is a Singleton.
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:self.URL] mainDocumentURL:nil];
            
            // Now we can print all of the cookies we have:
            for (NSHTTPCookie *cookie in all)
                NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate);
            // Also print all the headers
            NSDictionary *fields = [response allHeaderFields];
            self.LastRedirectLocation = [fields objectForKey:@"Location"];
            NSLog(@"Headers: %@", fields);
            NSURL* requestURL = [request URL];
            NSLog(@"The request url is: %@", [requestURL absoluteString]);
        }
        NSMutableURLRequest *r = [request mutableCopy]; // original request
        [r setURL: [request URL]];
        return r;
    } else {
        return request;
    }    
}
@end
