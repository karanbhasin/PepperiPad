//
//  capitalCallViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "capitalCallViewController.h"
#import "capitalCallDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"
#import "PCPieChart.h"

@interface capitalCallViewController()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSDictionary* json;
- (void)drawGraph;
@end

@implementation capitalCallViewController

@synthesize selectedFundID = _selectedFundID;
@synthesize sections = _sections;
@synthesize dictionary = _dictionary;
@synthesize activityDetails = _activityDetails;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize hostingView = _hostingView;
@synthesize json = _json;



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
    
    /*
     lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
     lblTemp.tag = 4;
     //lblTemp.font = [UIFont boldSystemFontOfSize:12];
     lblTemp.textColor = [UIColor lightGrayColor];
     [cell.contentView addSubview:lblTemp];
     */
    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-(NSData*) GetCapitalCalls:(int) fundId{

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetCapitalCalls:self.selectedFundID];
    NSError* error;
    self.json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"FundId":25,"FundName":"Amberbrook (MK Test #2)","DetailType":0,"CapitalCommitted":10000000.0000,"CapitalCalled":3000000.0000,"UnfundedAmount":7773999.9999,"ManagementFees":324000.0000,"FundExpenses":450000.0000,"CapitalCalls":[{"CapitalCallId":37,"Number":"3","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":36000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1317423600000)\/","CapitalCallDueDate":"\/Date(1318201200000)\/"},{"CapitalCallId":36,"Number":"2","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":144000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1320105600000)\/","CapitalCallDueDate":"\/Date(1320969600000)\/"},{"CapitalCallId":35,"Number":"1","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":144000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1317423600000)\/","CapitalCallDueDate":"\/Date(1318201200000)\/"}],"CapitalDistributed":2000000.0000,"ReturnManagementFees":165000.0000,"ReturnFundExpenses":75000.0000,"ProfitsReturned":52500.0000,"CapitalDistributions":[{"CapitalDistrubutionId":14,"Number":"3","InvestorName":null,"CapitalDistributed":500000.0000,"ReturnManagementFees":15000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":139500.0000,"ProfitReturn":17500.0000,"LPProfit":117180.0000,"CostReturn":null},{"CapitalDistrubutionId":13,"Number":"2","InvestorName":null,"CapitalDistributed":1000000.0000,"ReturnManagementFees":75000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325203200000)\/","CapitalDistributionDueDate":"\/Date(1325203200000)\/","Profit":79500.0000,"ProfitReturn":17500.0000,"LPProfit":66780.0000,"CostReturn":null},{"CapitalDistrubutionId":12,"Number":"1","InvestorName":null,"CapitalDistributed":500000.0000,"ReturnManagementFees":75000.0000,"ReturnFundExpenses":25000.0000,"CapitalDistributionDate":"\/Date(1325116800000)\/","CapitalDistributionDueDate":"\/Date(1325116800000)\/","Profit":79500.0000,"ProfitReturn":17500.0000,"LPProfit":66780.0000,"CostReturn":null}]}
    // The above response is dictionary
    NSLog(@"JSon recieved: %@", self.json);
    
    
    // Prepare data for the table view
    // Aggregate the datasets to bind to the table view. 
    // Sections will contain the name of different sections, like fund info, bank info etc
	self.sections = [[NSMutableArray alloc] init];
    // dictionary will contain the values that make up a section. the key for the dictionary will be the section name
	self.dictionary = [[NSMutableDictionary alloc] init];
    
    self.activityDetails = [self getDetails:self.json];
    //NSDictionary* detailsDict = [self getDetails:json];
    NSString* sectionName =  @"Summary";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:self.activityDetails forKey:sectionName];

    NSMutableArray* capitalCalls = [self.json objectForKey:@"CapitalCalls"];
    sectionName =  @"Capital Calls";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:capitalCalls forKey:sectionName];
    
    
    //NSLog(@"All Sections %@", self.sections);
    //NSLog(@"Dictionary: %@", self.dictionary);
    
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    table.delegate = self;
    table.dataSource = self;
    // Make the table fill the whole screen
    //table.frame = CGRectMake(0, 0, 320, 480);
    [self drawGraph];
}

- (void)drawGraph
{
    [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height/2,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [self.view addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    NSMutableArray *components = [NSMutableArray array];
    
    NSDictionary* graphData = [Util getGraphData2:self.json withContainerName:@"CapitalCalls" withKeyName:@"Number" withValueName:@"CapitalCallAmount" ];    
    NSLog(@"Graph data: %@", graphData);
    int i = 0;
    for (id key in graphData) {
        NSLog(@"Key: %@", key);
        NSLog(@"Value :%@", [graphData objectForKey:key]);
        NSString* lbl = @"#";
        lbl = [lbl stringByAppendingString:[key description]];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:lbl value:[[graphData objectForKey:key]floatValue]];
        [components addObject:component];
        if (i==0)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1)
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else if (i==4)
        {
            [component setColour:PCColorBlue];
        }
        i++;
    }
        
    [pieChart setComponents:components];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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
         // #3 for CapitalCallAmount
         // on CapitalCallDate
         // Due on CapitalCallDueDate
        {"CapitalCallId":37,"Number":"3","InvestorName":null,"CapitalCallAmount":1000000.0000,"ManagementFees":36000.0000,"FundExpenses":150000.0000,"CapitalCallDate":"\/Date(1317423600000)\/","CapitalCallDueDate":"\/Date(1318201200000)\/"}
         */
        UILabel *lblTemp1 = (UILabel *)[currentCell viewWithTag:1];
        UILabel *lblTemp2 = (UILabel *)[currentCell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[currentCell viewWithTag:3];
        //UILabel *lblTemp4 = (UILabel *)[currentCell viewWithTag:4];
        NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
        NSMutableArray* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        NSString* number = [Util formattedString:[sdict objectForKey:@"Number"]];
        NSString* amount = [Util formattedString:[sdict objectForKey:@"CapitalCallAmount"]];
        lblTemp1.text = [NSString stringWithFormat:@"#%@ for %@",number, amount];
        
        NSString* callDate = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)[sdict objectForKey:@"CapitalCallDate"]]];
        NSString* dueDate = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)[sdict objectForKey:@"CapitalCallDueDate"]]];
        lblTemp2.text = [NSString stringWithFormat:@"on %@", callDate];
        lblTemp3.text = [NSString stringWithFormat:@"due on %@", dueDate];
    }	
	return currentCell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    if(section == 1){
        //Presents a modal screen, we have to wire up to go back. For now, giving up on the seque implementation
        //[self performSegueWithIdentifier:@"fundActivityToDetail" sender:self];
        capitalCallDetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"capitalCallDetailsViewController"];
        detail.activityDetails = self.activityDetails;
        // Pass in the activityId selected
        NSString *sectionKey = [self.sections objectAtIndex:section];
        NSMutableArray* sectionRows = [self.dictionary objectForKey:sectionKey];
        NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        detail.selectedActivityID = (int)[sdict objectForKey:@"CapitalCallId"];
        [self.navigationController pushViewController:detail animated:YES];
    }
    // INFO: Do this no matter what. When you come back to this view controller again, the row you selected should be de-selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ([self.sections count] - 1)) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    return UITableViewCellAccessoryNone;
}

@end
