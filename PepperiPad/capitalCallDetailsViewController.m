//
//  fundActivityDetails.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "capitalCallDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"

@implementation capitalCallDetailsViewController

@synthesize activityDetails = _activityDetails;
@synthesize sections = _sections;
@synthesize dictionary = _dictionary;
@synthesize selectedActivityID = _selectedActivityID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helpers

- (NSString *)labelForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSString *sectionKey = [self.sections objectAtIndex:section];
    // Get the index into the dictionary
    // Since we cant get an object by index, we get the key by index, and then get the value from the dictionary
    NSString* label = @"label";
    if(section == 0){
        NSDictionary* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSArray *keys = [sectionRows allKeys];
        int row = indexPath.row;
        label = (NSString*)[keys objectAtIndex:row];
    } else {
        label = @"CapitalDistrubutionId";
    }
    return label;
}

- (id)getObjectForIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Section is : %@", [indexPath section]);
	NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
    NSLog(@"Section: %@", sectionKey);
    
    // Get the index into the dictionary
    // Since we cant get an object by index, we get the key by index, and then get the value from the dictionary
    NSDictionary* sectionRows = [self.dictionary objectForKey:sectionKey];
    NSArray *keys = [sectionRows allKeys];
    NSLog(@"All keys: @%", keys);
    int row = indexPath.row;
    id aKey = [keys objectAtIndex:row];
    id objectToReturn = [sectionRows objectForKey:aKey];
    return objectToReturn;
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath {
	NSString *text = @"value";
    //NSLog(@"Section is : %@", [indexPath section]);
    NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
    NSLog(@"Section: %@", sectionKey);
    if([indexPath section] == 0){
        // Get the index into the dictionary
        // Since we cant get an object by index, we get the key by index, and then get the value from the dictionary
        NSDictionary* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSArray *keys = [sectionRows allKeys];
        //NSLog(@"All keys: @%", keys);
        int row = indexPath.row;
        id aKey = [keys objectAtIndex:row];
        id obj = [sectionRows objectForKey:aKey];
        if(obj){
            // I was getting the following exception when the app ran ( on displaying details)
            // [NSCFNumber isEqualToString:]: unrecognized selector sent to instance
            // The following code was being used
            // text = (NSString *)obj;
            // I used formattedString and it worked fine
            text = [Util formattedString:obj];
            //text = (NSString *)obj;
        }
    } else {
        NSMutableArray* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        text = [Util formattedString:[sdict objectForKey:@"CapitalDistrubutionId"]];
    }
    
	return text;
}

- (CGFloat)getHeightForText:(NSString *)text {
    
	CGSize aSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:UILineBreakModeWordWrap];
	
	return aSize.height;
    
    // return 24;
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


-(NSDictionary*) getDetails: (NSDictionary*) json{
    //NSArray *fundProperties = [NSArray arrayWithObjects:@"FundId",@"FundName",@"TaxId",@"NumofAutoExtensions",@"RecycleProvision",@"Carry",@"InceptionDate",@"ScheduleTerminationDate",@"FinalTerminationDate",@"DateClawbackTriggered",@"MgmtFeesCatchUpDate", nil];
    NSArray *properties = [NSArray arrayWithObjects:@"CapitalCommitted",@"CapitalCalled",@"UnfundedAmount",@"ManagementFees",@"FundExpenses", nil];
    
    NSMutableDictionary* detailsDict = 
    [Util getFilteredDictionary:json withPropertyNames:properties withOverrideKeys:nil withDateKeys:nil];
    NSLog(@"Filtered fund dictionary %@", detailsDict);
    return detailsDict;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    CGRect Label1Frame = CGRectMake(10, 10, 290, 25);
    CGRect Label2Frame = CGRectMake(10, 33, 290, 25);
    CGRect Label3Frame = CGRectMake(10, 56, 290, 25);
    CGRect Label4Frame = CGRectMake(10, 79, 290, 25);
    UILabel *lblTemp;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];
    
    //Initialize Label with tag 1.
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.tag = 1;
    [cell.contentView addSubview:lblTemp];
    
    //Initialize Label with tag 2.
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.tag = 2;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    //lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
    lblTemp.tag = 3;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    //lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    
    lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
    lblTemp.tag = 4;
    //lblTemp.font = [UIFont boldSystemFontOfSize:12];
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    return cell;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetCapitalDistributionInvestors:self.selectedActivityID];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // {"Investors":[{"InvestorName":"Investor 1 (MK Test #2)","CapitalDistributed":150000.0000,"ReturnManagementFees":4999.9999,"ReturnFundExpenses":8333.3333,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":39059.9999,"ProfitReturn":5833.3333,"LPProfit":null,"CostReturn":0.0000},{"InvestorName":"Investor 2 (MK Test #2)","CapitalDistributed":300000.0000,"ReturnManagementFees":10000.0000,"ReturnFundExpenses":16666.6666,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":78120.0000,"ProfitReturn":11666.6666,"LPProfit":null,"CostReturn":0.0000},{"InvestorName":"Willowridge (MK Test #2)","CapitalDistributed":50000.0000,"ReturnManagementFees":null,"ReturnFundExpenses":null,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":22320.0000,"ProfitReturn":null,"LPProfit":null,"CostReturn":0.0000}]}
    // The above response is dictionary with one key "Investors". The value is an array of investors
    NSLog(@"JSon recieved capital dist: %@", json);
    
    
    
    // Prepare data for the table view
    // Aggregate the datasets to bind to the table view. 
    // Sections will contain the name of different sections, like fund info, bank info etc
	self.sections = [[NSMutableArray alloc] init];
    // dictionary will contain the values that make up a section. the key for the dictionary will be the section name
	self.dictionary = [[NSMutableDictionary alloc] init];
    
    //self.activityDetails = [self getDetails:json];
    NSString* sectionName =  @"Summary";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:self.activityDetails forKey:sectionName];
    NSLog(@"Summary dictionary: %@", self.activityDetails);
    
    NSMutableArray* investors = [json objectForKey:@"Investors"];
    sectionName =  @"Investors";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:investors forKey:sectionName];
    NSLog(@"Capital Distribution array: %@", investors);
    
    table.delegate = self;
    table.dataSource = self;
    // Make the table fill the whole screen
    //table.frame = CGRectMake(0, 0, 320, 480);
}


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = [self.sections count];
    // INFO:
    // The following code was failing due to reason below
    // count gives an int, but you print with %@, expecting a pointer to an object. Use %d instead.    
    //NSLog(@"Number of sections = %@", sectionCount);
    NSLog(@"Number of sections = %d", sectionCount);
	return  sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [[self.dictionary objectForKey:[self.sections objectAtIndex:section]] count];
    NSLog(@"# of Row = %d in section %d", numberOfRows, section);
	return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionHeader = [self.sections objectAtIndex:section];
    NSLog(@"Section header: %@ for section:%d", sectionHeader, section);
	return sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section] == 0){
        // Need to get the text that will be displayed in order to calculate the height
        NSString *text = [self textForIndexPath:indexPath];
        // add 24 for padding
        CGFloat returnHeight = [self getHeightForText:text] + 24;
        return returnHeight;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    /*
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableIdentifier"];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableIdentifier"];
     }
     
     cell.textLabel.text = @"blah blah";
     
     return cell;
     
     */
    NSString* cellIdentifier = @"TableIdentifier";
    UITableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // If it is the last section (More actions, then we need to just display the key
    /*
     if (indexPath.section == ([self.sections count] - 1)) {
     UILabel *rowText = [[UILabel alloc] init];
     rowText.textAlignment = UITextAlignmentLeft;
     rowText.font = [UIFont boldSystemFontOfSize:14.0];
     rowText.textColor = [UIColor blackColor];
     rowText.highlightedTextColor = [UIColor whiteColor];
     rowText.numberOfLines = 0;
     rowText.lineBreakMode = UILineBreakModeWordWrap;
     rowText.text = text;
     [currentCell.contentView addSubview:rowText];
     
     // This is the last section
     // Adjust the frame to account for height of text to be displayed
     //currentCell.frame = CGRectMake(0, 0, tableView.bounds.size.width, myTextHeight);
     [currentCell sizeToFit];
     //currentCell.detailTextLabel.text = text;
     //currentCell.textLabel.text =      text;
     NSLog(@"Last section Label: %@, Text: %@", label, text);
     } else {*/
    
    
	if (currentCell == nil) {
        currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section == 0){
        NSString *label = [self labelForIndexPath:indexPath];
        NSString *text = [self textForIndexPath:indexPath];
        NSLog(@"Label: %@, Text: %@", label, text);
        NSLog(@"Section:%@",[NSString stringWithFormat:@"%d", indexPath.section]);
        
        UILabel *rowLabel = [[UILabel alloc] init];
        rowLabel.textAlignment = UITextAlignmentLeft;
        rowLabel.font = [UIFont boldSystemFontOfSize:12.0];
        rowLabel.tag = 1;
        rowLabel.textColor = [UIColor colorWithRed:.32 green:.40 blue:.57 alpha:1];
        rowLabel.highlightedTextColor = [UIColor whiteColor];
        rowLabel.numberOfLines = 0;
        [currentCell.contentView addSubview:rowLabel];
        
        UILabel *rowText = [[UILabel alloc] init];
        rowText.textAlignment = UITextAlignmentLeft;
        rowText.font = [UIFont boldSystemFontOfSize:14.0];
        rowText.tag = 2;
        rowText.textColor = [UIColor blackColor];
        rowText.highlightedTextColor = [UIColor whiteColor];
        rowText.numberOfLines = 0;
        rowText.lineBreakMode = UILineBreakModeWordWrap;
        [currentCell.contentView addSubview:rowText];
        
        UILabel *myLabel = (UILabel *)[currentCell.contentView viewWithTag:1];
        UILabel *myText = (UILabel *)[currentCell.contentView viewWithTag:2];
        
        // Get the height of the text to be displayed
        CGFloat myTextHeight = [self getHeightForText:text];
        // Adjust the frame to account for height of text to be displayed
        currentCell.frame = CGRectMake(0, 0, tableView.bounds.size.width, myTextHeight);
        
        myLabel.frame = CGRectMake(5, 12, 120, 16);
        myText.frame = CGRectMake(140, 12, 160, myTextHeight);
        
        myLabel.text = [label lowercaseString];
        myText.text = text;
        
        [currentCell sizeToFit];
    } else {
        currentCell = [self getCellContentView:cellIdentifier];
        /*
         //{"InvestorName":"Investor 1 (MK Test #2)",
         //"CapitalDistributed":150000.0000,
         //"ReturnManagementFees":4999.9999,
         //"ReturnFundExpenses":8333.3333,
         //"Profit":39059.9999,
         //"ProfitReturn":5833.3333,
         //"LPProfit":null,
         //"CostReturn":0.0000}
         // investor name
         // amount
         // Fees and expnses
         // Profit ProfitReturn
         */
        UILabel *lblTemp1 = (UILabel *)[currentCell viewWithTag:1];
        UILabel *lblTemp2 = (UILabel *)[currentCell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[currentCell viewWithTag:3];
        UILabel *lblTemp4 = (UILabel *)[currentCell viewWithTag:4];
        
        NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
        NSMutableArray* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        NSString* investorName = [Util formattedString:[sdict objectForKey:@"InvestorName"]];
        NSString* amount = [Util formattedString:[sdict objectForKey:@"CapitalDistributed"]];
        NSString* mgmtFees = [Util formattedString:[sdict objectForKey:@"ReturnManagementFees"]];
        NSString* fundExpenses = [Util formattedString:[sdict objectForKey:@"ReturnFundExpenses"]];
        NSString* profit = [Util formattedString:[sdict objectForKey:@"Profit"]];
        NSString* profitReturn = [Util formattedString:[sdict objectForKey:@"ProfitReturn"]];
        //NSString* profit = [Util formattedString:[sdict objectForKey:@"Profit"]];
        //NSString* profitReturn = [Util formattedString:[sdict objectForKey:@"ProfitReturn"]];
        
        lblTemp1.text = investorName;
        
        lblTemp2.text = [NSString stringWithFormat:@"for $%@", amount];
        lblTemp3.text = [NSString stringWithFormat:@"fees:%@ expenses:%@", mgmtFees, fundExpenses];
        lblTemp4.text = [NSString stringWithFormat:@"profit:%@ return:%@", profit, profitReturn];
    }	
	return currentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
