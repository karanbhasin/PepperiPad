//
//  fundDetailsViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fundInvestorsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"
#import "PCPieChart.h"
//#import "VerticalBarChart.h"

@interface fundInvestorsViewController()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void) drawGraph;
@end

@implementation fundInvestorsViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize selectedFundID = _selectedFundID;
@synthesize sections = _sections;
@synthesize dictionary = _dictionary;
@synthesize hostingView = _hostingView;

#pragma mark - Managing the detail item

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Helpers

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Get the list of the Funds from the api
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetInvestorsInFund:self.selectedFundID];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // [{"id":2,"label":"AMBERBROOK II LLC","value":"AMBERBROOK II LLC"},{"id":3,"label":"AMBERBROOK III LLC","value":"AMBERBROOK III LLC"},{"id":4,"label":"AMBERBROOK IV LLC","value":"AMBERBROOK IV LLC"},{"id":1,"label":"AMBERBROOK LLC","value":"AMBERBROOK LLC"},{"id":5,"label":"AMBERBROOK V LLC","value":"AMBERBROOK V LLC"}]
    //{"page":1,"total":4,"rows":[{"cell":["American Legacy Foundation",1000000.0000,1000000.0000,"\/Date(1314831600000)\/"]},{"cell":["Blair Academy",2000000.0000,2000000.0000,"\/Date(1314831600000)\/"]},{"cell":["James Tannoy",3000000.0000,3000000.0000,"\/Date(1314831600000)\/"]},{"cell":["Willowridge V LLC",5645645564654.0000,5645645564654.0000,"\/Date(1314831600000)\/"]}]}
    // The above response is an array of dictionaries
    NSLog(@"JSon recieved: %@", json);
    // Create an array to hold all the funds
    //NSMutableArray* funds = [NSMutableArray arrayWithCapacity:[json count]];
    myData = [json objectForKey:@"rows"];
    NSLog(@"array received %@", myData);
    /*
     for (int i = 0; i < [json count]; i++)
     {
     // Each entry in the array is a dictionary
     NSDictionary *dict = [json objectAtIndex:i];
     //for(NSString *key in dict) {
     //[funds addObject:[dict objectForKey:@"value"]];
     [myData addObject:dict];        //}
     }
     
     
     
     NSArray* bankArray = [json objectForKey:@"BankDetail"];
     // Currently there is only 1 bank allowed per fund from the UI. However, the DB design allows for multiple banks
     if([bankArray count] > 0){
     NSDictionary *bank = (NSDictionary*)[bankArray objectAtIndex:0];
     // clean up the unwanted elements
     NSMutableDictionary* bankDict = [Util getFilteredDictionary:bank withPropertyNames:bankProperties withOverrideKeys:mapping withDateKeys:nil];
     NSLog(@"Filtered fund dictionary %@", bankDict);
     return bankDict;
     }
     */
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    table.delegate = self;
    table.dataSource = self;
    [self drawGraph];
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
    return YES;
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myData count];
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
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
    lblTemp.tag = 3;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
    lblTemp.tag = 4;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [self getCellContentView:CellIdentifier];
        
        
        // Configure the cell...
        
        // Get the cell label using it's tag and set it
        NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:indexPath.row];
        NSLog(@"Dict %@", dict);
        // The returned dictionary will be of the format
        /*
         {
         cell =     (
         "Jerrold M. Newman",
         125000,
         "6139.5357",
         "/Date(1328950536000)/"
         );
         }
         */
        // The value in the dictionary for the key "cell" is an array. we want the first item in the array as the investor name
        //cell.textLabel.text = [[dict objectForKey:@"cell"] objectAtIndex:0];
        
        /////
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
        UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];
        
        lblTemp1.text = [[dict objectForKey:@"cell"] objectAtIndex:0];
        NSString* closeDate = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)[[dict objectForKey:@"cell"] objectAtIndex:3]]];
        
        lblTemp2.text = [NSString stringWithFormat:@"closed on %@", closeDate];
        lblTemp3.text = [NSString stringWithFormat:@"total commitment $%@", [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:1]]];
        lblTemp4.text = [NSString stringWithFormat:@"unfunded amount $%@", [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:2]]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect the row and do nothing
    /*
    if (indexPath.section == ([self.sections count] - 1)) {
        // Find out what was selected
        NSString *text = [self textForIndexPath:indexPath];
        
        int row = indexPath.row;
        if([text isEqualToString:@"Capital Calls"]){
            capitalCallViewController *ccController = [self.storyboard instantiateViewControllerWithIdentifier:@"CapitalCallViewController"];
            ccController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:ccController animated:YES];
        } else if([text isEqualToString:@"Capital Distributions"]){
            //capitalDistributionViewController *ccController = [[capitalDistributionViewController alloc] initWithNibName:@"CapitalDistributionViewController" bundle:nil];
            //INFO: the above line with initWithNibName was loading the view, but the outlets (IBOUTBELT table) were not wired up when the view loaded. Had to use the following code
            capitalDistributionViewController *ccController = [self.storyboard instantiateViewControllerWithIdentifier:@"CapitalDistributionViewController"];
            ccController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:ccController animated:YES];
        }
        else if([text isEqualToString:@"Investors"]){
            //Initialize the detail view controller and display it.
            investorDetailsViewController *invController = [[investorDetailsViewController alloc] init];
            invController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:invController animated:YES];
        }
        else if([text isEqualToString:@"Deals"]){
            //Initialize the detail view controller and display it.
            dealsViewController *dealsController = [[dealsViewController alloc] init];
            dealsController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:dealsController animated:YES];
        }
    }
    */
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ([self.sections count] - 1)) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    return UITableViewCellAccessoryNone;
}

- (void)drawGraph
{
    // Update the user interface for the detail item.
    
    // Show the graph here
    //VerticalBarChart * plotItem = [[VerticalBarChart alloc] init];
    //CandlestickPlot * plotItem = [[CandlestickPlot alloc] init];
    //[plotItem renderInView:hostingView withTheme:[self currentTheme]];
    //[plotItem renderInView:hostingView withTheme:nil];
    
    //iOSPlot
    [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    //[self.titleLabel setText:@"Pie Chart"];
    
    
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    //PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height/2,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [self.view addSubview:pieChart];
    //[pieChart release];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_piechart_data.plist"];
    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSMutableArray *components = [NSMutableArray array];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[myData count]; i++){
        

        NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:i];
        float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:1] floatValue];
        NSNumber *num = [NSNumber numberWithFloat:totalCommitment];
        [array addObject:num];
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray* sortedFloats = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    int counter = 0;
    NSMutableArray* copyDict = (NSMutableArray*)[myData mutableCopy];
    NSMutableArray* sortedInvestorNames = [[NSMutableArray alloc] init];
    float rest = 0;
    for (NSNumber* num in sortedFloats) {
        NSLog(@"%f", [num floatValue]);
        if(counter < 5){
            for (int i=0; i<[copyDict count]; i++){
                NSDictionary* dict = (NSDictionary*)[copyDict objectAtIndex:i];
                float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:1] floatValue];
                if(totalCommitment == [num floatValue]){
                     NSString* invName = [[dict objectForKey:@"cell"] objectAtIndex:0];
                    [sortedInvestorNames addObject:invName];
                    [copyDict removeObject:dict];
                    break;
                }
            }
        } else {
            rest+= [num floatValue];
        }
        counter++;
    }
    
    
    for (int i=0; i<[sortedInvestorNames count]; i++){
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[sortedInvestorNames objectAtIndex:i] value:[[sortedFloats objectAtIndex:i]floatValue]];
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
    }
    if(counter > 5){
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"Others" value:rest];
        [components addObject:component];
        [component setColour:PCColorDefault];
    }
    
    /*
    for (int i=0; i<[myData count]; i++){
        NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:i];
        
        NSString* lbl = [[dict objectForKey:@"cell"] objectAtIndex:0];
        //NSString* closeDate = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)[[dict objectForKey:@"cell"] objectAtIndex:3]]];
        //lblTemp2.text = [NSString stringWithFormat:@"closed on %@", closeDate];
        float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:1] floatValue];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:lbl value:totalCommitment];
        [components addObject:component];
        //lblTemp3.text = [NSString stringWithFormat:@"total commitment $%@", [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:1]]];
        //lblTemp4.text = [NSString stringWithFormat:@"unfunded amount $%@", [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:2]]];
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
    }
     */
    /*
    for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
    {
        NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
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
    }
    */
    [pieChart setComponents:components];
    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end