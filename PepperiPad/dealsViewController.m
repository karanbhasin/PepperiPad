//
//  dealsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dealsViewController.h"
#import "capitalCallDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"
#import "dealDetailsViewController.h"
#import "PCPieChart.h"
#import "Constants.h"

@interface dealsViewController()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSMutableDictionary *activityDetails;
@property (nonatomic, retain) NSMutableArray *deals;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSDictionary* json;
- (void)drawGraph;
- (void)drawGraph:(int)x
            withY:(int)y
        withwidth:(int)width
       withHeight:(int)height
     withKeyIndex:(int)keyIndex
   withValueIndex:(int)valueIndex
        withTitle:(NSString*) title;
@end

@implementation dealsViewController

@synthesize selectedFundID = _selectedFundID;
@synthesize sections = _sections;
@synthesize dictionary = _dictionary;
@synthesize activityDetails = _activityDetails;
@synthesize deals = _deals;
@synthesize masterPopoverController = _masterPopoverController;
//@synthesize hostingView = _hostingView;
@synthesize scrollView = _scrollView;

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
    
     lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
     lblTemp.tag = 4;
     lblTemp.font = [UIFont boldSystemFontOfSize:12];
     //lblTemp.textColor = [UIColor lightGrayColor];
     [cell.contentView addSubview:lblTemp];
     
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetDeals:self.selectedFundID];
    NSError* error;
    self.json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"page":1,"total":13,"rows":[{"cell":[575,1,"Brooks Fiber","03/07/2012","","","","",""]},{"cell":[576,2,"Olympus","03/07/2012","","","$300,000.00","",""]},{"cell":[577,3,"Miami Corp.","03/07/2012","$170,000.00","$170,000.00","$400,000.00","",""]},{"cell":[578,4,"Key Trust/Society","03/07/2012","$670,785.00","$670,785.00","$5,550,000.00","",""]},{"cell":[579,5,"Michelin","03/07/2012","$347,131.00","$425,000.00","$5,000,000.00","",""]},{"cell":[580,6,"C.H. Robinson","03/07/2012","$386,150.00","$386,150.00","$300,000.00","",""]},{"cell":[581,7,"Consolidated Freight","03/07/2012","$1,135,688.00","$1,163,188.00","$4,420,000.00","",""]},{"cell":[582,8,"Brown & Williamson","03/07/2012","$299,415.00","$299,415.00","$299,415.00","",""]},{"cell":[583,9,"Peoples Bank","03/07/2012","$500,000.00","$500,000.00","$2,000,000.00","",""]},{"cell":[584,10,"Jamba Juice","03/07/2012","","","","",""]},{"cell":[585,11,"Levine Purch","03/07/2012","$185,000.00","$185,000.00","$500,000.00","",""]},{"cell":[586,12,"Met Life/Paul Revere","03/07/2012","$410,000.00","$410,000.00","$9,000,000.00","",""]},{"cell":[587,14,"Picis","03/07/2012","","","","70,253","$235,165.65"]}]}
    // The above response is dictionary
    NSLog(@"JSon recieved: %@", self.json);
    
    self.deals = [self.json objectForKey:@"rows"];
    NSLog(@"Deals: %@", self.deals);
    /*
    // Prepare data for the table view
    // Aggregate the datasets to bind to the table view. 
    // Sections will contain the name of different sections, like fund info, bank info etc
	self.sections = [[NSMutableArray alloc] init];
    // dictionary will contain the values that make up a section. the key for the dictionary will be the section name
	self.dictionary = [[NSMutableDictionary alloc] init];
    
    self.activityDetails = [self getDetails:json];
    //NSDictionary* detailsDict = [self getDetails:json];
    NSString* sectionName =  @"Summary";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:self.activityDetails forKey:sectionName];
    
    NSMutableArray* capitalCalls = [json objectForKey:@"CapitalCalls"];
    sectionName =  @"Capital Calls";
    [self.sections addObject:sectionName];
    [self.dictionary setObject:capitalCalls forKey:sectionName];
    
    
    //NSLog(@"All Sections %@", self.sections);
    //NSLog(@"Dictionary: %@", self.dictionary);
    
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    */
    table.delegate = self;
    table.dataSource = self;
    // Make the table fill the whole screen
    table.frame = CGRectMake(0, 0, iPad_Width, iPad_Height/2);
    [self drawGraph];
    self.scrollView.contentSize = CGSizeMake(iPad_Width, iPad_Height*2);
    
}


- (void)drawGraph{
    // 768×1024
    [self.scrollView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    //int width = [self.scrollView bounds].size.width; //320;
    int width = iPad_Width;
    //int height = [self.view bounds].size.width/3*2.; // 220;
    int height = 460;
    int x=0;
    int spacer = 20;
    //int y = [self.view bounds].size.height/2;
    int y = table.frame.size.height + spacer*4;
    [self drawGraph:x withY:y withwidth:width withHeight:height withKeyIndex:2 withValueIndex:6 withTitle:@"Top 5 deals by commitment amount"];
    y = y + height + spacer;
    //NPP
    [self drawGraph:x withY:y withwidth:width withHeight:height withKeyIndex:2 withValueIndex:4 withTitle:@"Top 5 deals by NPP"];
    y = y + height + spacer;
    //GPP
    [self drawGraph:x withY:y withwidth:width withHeight:height withKeyIndex:2 withValueIndex:5 withTitle:@"Top 5 deals by GPP"];
    
}

- (void)drawGraph:(int)x
                 withY:(int)y
                withwidth:(int)width
                withHeight:(int)height
                withKeyIndex:(int)keyIndex
                withValueIndex:(int)valueIndex
                withTitle:(NSString*) title
{
    
    int lblHeight = 20;
    CGRect Label1Frame = CGRectMake(x+180, y, width, lblHeight);
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = title;
    lblTemp.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    int spacer = 30;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(x,y+lblHeight+spacer,width,height-lblHeight-spacer)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    
    
    CGRect frame;
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = width;
    frame.size.height = height;
    
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    //subview.backgroundColor = [UIColor colo
    [subview setBackgroundColor:[UIColor lightGrayColor]];
    [subview addSubview:pieChart];
    
    
    //[self.scrollView addSubview:subview];
    
    
    [self.scrollView addSubview:lblTemp];
    [self.scrollView addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    NSMutableArray *components = [NSMutableArray array];
    
    NSDictionary* graphData = [Util getGraphData:self.json withKeyIndex:keyIndex withValueIndex:valueIndex ];
    NSLog(@"Graph data: %@", graphData);
    int i = 0;
    for (id key in graphData) {
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:key value:[[graphData objectForKey:key]floatValue]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self getCellContentView:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Get the cell label using it's tag and set it
    NSDictionary* dict = (NSDictionary*)[self.deals objectAtIndex:indexPath.row];
    NSLog(@"Dict %@", dict);
    // The returned dictionary will be of the format
    /*
     // Deal Name
     // Committed x on Date
     // Net purcahse price
     // Gross Purchase Price
     */
    // The value in the dictionary for the key "cell" is an array. we want the second item in the array as the investor name
    //cell.textLabel.text = [[dict objectForKey:@"cell"] objectAtIndex:2];
    //return cell;
    
    UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];

    lblTemp1.text = [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:2]];
    NSString* commitedAmount = (NSString*)[[dict objectForKey:@"cell"] objectAtIndex:6];
    NSString* prefix = @"";
    if([commitedAmount length]==0){
      prefix = @"closed on ";
    } else {
        prefix = [NSString stringWithFormat:@"committed %@ on ", commitedAmount];
    }
    
    lblTemp2.text = [NSString stringWithFormat:@"%@ %@", prefix, [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:3]]];
    
    bool nPPPresent = false;
    bool gPPPresent = false;
    int count = 0;
    NSString* nPP = (NSString*)[[dict objectForKey:@"cell"] objectAtIndex:4];
    NSString* gPP = (NSString*)[[dict objectForKey:@"cell"] objectAtIndex:5];
    if([nPP length]!=0){
        nPPPresent = true;
        count++;
    }
    if([gPP length] != 0){
        gPPPresent = true;
        count++;
    }
    
    if(count == 0){
        
    } else if(count == 1){
        if(nPPPresent){
            lblTemp3.text = [NSString stringWithFormat:@"%@ %@", @"net purchase price:", nPP ];
        } else {
            lblTemp3.text = [NSString stringWithFormat:@"%@ %@", @"net purchase price:", gPP ];
        }
    } else if (count == 2){
        lblTemp3.text = [NSString stringWithFormat:@"%@ %@", @"net purchase price:", nPP ];
        lblTemp4.text = [NSString stringWithFormat:@"%@ %@", @"gross purchase price:", gPP ];
    }
    
    return cell;
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
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //Presents a modal screen, we have to wire up to go back. For now, giving up on the seque implementation
        //[self performSegueWithIdentifier:@"fundActivityToDetail" sender:self];
        dealDetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"dealDetailsViewController"];
        NSDictionary* sectionRows = [self.deals objectAtIndex:indexPath.row];
        NSLog(@"Section rows: %@", sectionRows);
        //NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        detail.selectedID = (int)[[sectionRows objectForKey:@"cell"] objectAtIndex:5];
        [self.navigationController pushViewController:detail animated:YES];
    
    // INFO: Do this no matter what. When you come back to this view controller again, the row you selected should be de-selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    dealDetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"dealDetails"];
        NSInteger selectedIndex = [[table indexPathForSelectedRow] row];
        NSDictionary* sectionRows = [self.deals objectAtIndex:selectedIndex];
        NSLog(@"Section rows: %@", sectionRows);
        //NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        detail.selectedID = (int)[[sectionRows objectForKey:@"cell"] objectAtIndex:0];
        [self.navigationController pushViewController:detail animated:YES];
    // INFO: Do this no matter what. When you come back to this view controller again, the row you selected should be de-selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"dealToDetail"]) {
        
        // Get reference to the destination view controller
        dealDetailsViewController *detail = [segue destinationViewController];
        NSInteger selectedIndex = [[table indexPathForSelectedRow] row];
        NSDictionary* sectionRows = [self.deals objectAtIndex:selectedIndex];
        NSLog(@"Section rows: %@", sectionRows);
        //NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
        
        detail.selectedID = (int)[[sectionRows objectForKey:@"cell"] objectAtIndex:5];
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
}

@end
