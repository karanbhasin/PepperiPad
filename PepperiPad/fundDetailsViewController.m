//
//  fundDetailsViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fundDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"
#import "PCPieChart.h"

@interface fundDetailsViewController()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation fundDetailsViewController

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

- (NSString *)labelForIndexPath:(NSIndexPath *)indexPath {
    //return @"label";
    NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
    // Get the index into the dictionary
    // Since we cant get an object by index, we get the key by index, and then get the value from the dictionary
    NSDictionary* sectionRows = [self.dictionary objectForKey:sectionKey];
    NSArray *keys = [sectionRows allKeys];
    int row = indexPath.row;
    //NSLog(@"Row: %@", row);
    id aKey = [keys objectAtIndex:row];
    NSLog(@"label is %@", aKey);
    return aKey;
    /*
     NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
     NSArray *dataArray = [self.dictionary objectForKey:sectionKey];
     NSDictionary *data = [dataArray objectAtIndex:indexPath.row];
     if (data && [data count]) {
     return [[data allKeys] objectAtIndex:0];
     }
     return nil;
     */
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
    //NSLog(@"Row: %@", row);
    id aKey = [keys objectAtIndex:row];
    //NSLog(@"Key: %@", aKey);
    //id objectToReturn = [sectionRows objectForKey:sectionKey];
    id objectToReturn = [sectionRows objectForKey:aKey];
    //NSLog(@"value: %@", objectToReturn);
    return objectToReturn;
    
    /*
     NSDictionary *dict = [self.dictionary objectForKey:sectionKey];
     if (dict && [dict count]) {
     NSString *key = [[dict allKeys] objectAtIndex:indexPath.row];
     return [dict objectForKey:key];        
     }
     
     return nil;
     */
}

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath {
	NSString *text;
	
	id obj = [self getObjectForIndexPath:indexPath];
    if(obj){
        // I was getting the following exception when the app ran ( on displaying details)
        // [NSCFNumber isEqualToString:]: unrecognized selector sent to instance
        // The following code was being used
        // text = (NSString *)obj;
        // I used formattedString and it worked fine
        text = [Util formattedString:obj];
        //text = (NSString *)obj;
    }
    /*
     if ([obj isKindOfClass:[FOAddress class]]) {
     text = [(FOAddress *)obj formattedAddress];
     }
     else if ([obj isKindOfClass:[FOCommunication class]]) {
     text = [(FOCommunication *)obj value];
     }
     else {
     text = (NSString *)obj;
     }
     */
	return text;
}

- (CGFloat)getHeightForText:(NSString *)text {
    
	CGSize aSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:UILineBreakModeWordWrap];
	
	return aSize.height;
    
    // return 24;
}

-(NSDictionary*) getFund: (NSDictionary*) json{
    //NSArray *fundProperties = [NSArray arrayWithObjects:@"FundId",@"FundName",@"TaxId",@"NumofAutoExtensions",@"RecycleProvision",@"Carry",@"InceptionDate",@"ScheduleTerminationDate",@"FinalTerminationDate",@"DateClawbackTriggered",@"MgmtFeesCatchUpDate", nil];
    NSArray *fundProperties = [NSArray arrayWithObjects:@"TaxId",@"NumofAutoExtensions",@"RecycleProvision",@"Carry",@"InceptionDate",@"ScheduleTerminationDate",@"FinalTerminationDate",@"DateClawbackTriggered",@"MgmtFeesCatchUpDate", nil];
    
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Tax ID",@"TaxId",
                             @"Auto Ext", @"NumofAutoExtensions",
                             @"Recycle Provision", @"RecycleProvision", 
                             @"Inception Date", @"InceptionDate",
                             @"Schedule Termination Date", @"ScheduleTerminationDate",
                             @"Final Termination Date", @"FinalTerminationDate",
                             @"Clawback Date", @"DateClawbackTriggered",
                             @"Mgmt Fees CatchUp", @"MgmtFeesCatchUpDate", nil];
    NSArray* dateProperties = [NSArray arrayWithObjects: 
                               @"InceptionDate",
                               @"ScheduleTerminationDate",
                               @"FinalTerminationDate",
                               @"DateClawbackTriggered",
                               @"MgmtFeesCatchUpDate", nil];
    
    NSMutableDictionary* fundDict = 
    [Util getFilteredDictionary:json withPropertyNames:fundProperties withOverrideKeys:mapping withDateKeys:dateProperties];
    NSLog(@"Filtered fund dictionary %@", fundDict);
    return fundDict;
}

-(NSDictionary*) getBank: (NSDictionary*) json{
    //NSArray* bankProperties = [NSArray arrayWithObjects:@"AccountId",@"BankName",@"Account",@"AccountNumber",@"AccountPhone",@"ABANumber",@"AccountFax",@"Reference",@"Swift",@"FFC",@"FFCNumber",@"IBAN",@"ByOrderOf", nil];
    NSArray* bankProperties = [NSArray arrayWithObjects:@"BankName",@"Account",@"AccountNumber",@"AccountPhone",@"ABANumber",@"AccountFax",@"Reference",@"Swift",@"FFC",@"FFCNumber",@"IBAN",@"ByOrderOf", nil];
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Bank",@"BankName",
                             @"Account#",@"AccountNumber",
                             @"Phone",@"AccountPhone",
                             @"Routing",@"ABANumber",
                             @"Fax",@"AccountFax",
                             @"FFC#",@"FFCNumber",
                             @"Order of",@"ByOrderOf",
                             nil];
    
    NSArray* bankArray = [json objectForKey:@"BankDetail"];
    // Currently there is only 1 bank allowed per fund from the UI. However, the DB design allows for multiple banks
    if([bankArray count] > 0){
        NSDictionary *bank = (NSDictionary*)[bankArray objectAtIndex:0];
        // clean up the unwanted elements
        NSMutableDictionary* bankDict = [Util getFilteredDictionary:bank withPropertyNames:bankProperties withOverrideKeys:mapping withDateKeys:nil];
        NSLog(@"Filtered fund dictionary %@", bankDict);
        return bankDict;
    }
    return nil;
}

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
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetFundDetail:self.selectedFundID];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"FundId":2,"FundName":"AMBERBROOK II LLC","TaxId":"4c342a02af4e4a0e9be1ad6bf","InceptionDate":"\/Date(874882800000)\/","ScheduleTerminationDate":"\/Date(1093993200000)\/","FinalTerminationDate":null,"NumofAutoExtensions":null,"DateClawbackTriggered":null,"RecycleProvision":null,"MgmtFeesCatchUpDate":null,"Carry":null,"BankDetail":[{"AccountId":2,"BankName":null,"Account":null,"AccountNumber":null,"AccountOf":null,"Reference":null,"Attention":null,"Swift":null,"FFC":null,"FFCNumber":null,"IBAN":null,"AccountPhone":null,"ABANumber":null,"AccountFax":null,"ByOrderOf":null}],"CustomField":{"Key":0,"Fields":[],"Values":[],"InitializeDatePicker":true,"IsDisplayTwoColumn":true,"IsDisplayMode":false},"FundRateSchedules":[{"FundRateScheduleId":0,"FundId":2,"InvestorTypeId":1,"RateScheduleId":0,"RateScheduleTypeId":0,"FundRateScheduleTiers":[{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0},{"Notes":null,"ManagementFeeRateScheduleId":0,"ManagementFeeRateScheduleTierId":0,"StartDate":null,"EndDate":null,"Rate":null,"FlatFee":null,"MultiplierTypeId":0}]}],"MultiplierTypes":null,"InvestorTypes"
    // The above response is dictionary
    NSLog(@"JSon recieved: %@", json);
    NSString* fundName = [json objectForKey:@"FundName"];
    
    /*
     // Create a Table View programatically
     UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
     style:UITableViewStylePlain];
     tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
     // The current object makes itself the data source and delegate by adopting the UITableViewDataSource and UITableViewDelegate protocols specified in the header file
     tableView.delegate = self;
     tableView.dataSource = self;
     // It also sends a reloadData message to the table view, causing the table view to initiate the procedure for populating its sections and rows with data.
     [tableView reloadData];
     // the class creating the table view is a subclass of UIViewController, it assigns the created table view to its view property
     
     self.view = tableView;
     */
    
    // Set the title of the view to the fund name
    [self setTitle:fundName];
    
    // Prepare data for the table view
    // Aggregate the datasets to bind to the table view. 
    // Sections will contain the name of different sections, like fund info, bank info etc
	self.sections = [[NSMutableArray alloc] init];
    // dictionary will contain the values that make up a section. the key for the dictionary will be the section name
	self.dictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary* fundDict = [self getFund:json];
    NSDictionary* bankDict = [self getBank:json];
    
    if([[fundDict allKeys] count] > 0){
        NSString* sectionName =  @"Fund Details";
        [self.sections addObject:sectionName];
        [self.dictionary setObject:fundDict forKey:sectionName];
    }
    
    if([[bankDict allKeys] count] > 0){
        NSString* sectionName =  @"Bank Details";
        [self.sections addObject:sectionName];
        [self.dictionary setObject:bankDict forKey:sectionName];
    }
    
    /*
     Fund* fund = [Fund populateFromDictionary:json]; 
     NSLog(@"Fund: %@", fund);
     if(fund.scheduleTerminationDate || fund.dateClawbackTriggered || fund.inceptionDate || fund.mgmtFeesCatchUpDate || fund.finalTerminationDate){
     NSString* sectionName = @"Fund Details";
     [self.sections addObject:sectionName];
     NSMutableDictionary* fundDetailsDict = [[NSMutableDictionary alloc] init];
     if(fund.scheduleTerminationDate){
     [fundDetailsDict setValue:[Util toString:fund.scheduleTerminationDate] forKey:@"Scheduled Termination Date"];
     }
     if(fund.dateClawbackTriggered){
     [fundDetailsDict setValue:[Util toString:fund.dateClawbackTriggered] forKey:@"Clawback Date" ];
     }
     if(fund.inceptionDate){
     [fundDetailsDict setValue:[Util toString:fund.inceptionDate] forKey:@"Inception Date"];
     }
     if(fund.mgmtFeesCatchUpDate){
     [fundDetailsDict setValue:[Util toString:fund.mgmtFeesCatchUpDate] forKey:@"Management Fee Catchup Date"];
     }
     if(fund.finalTerminationDate){
     [fundDetailsDict setValue:[Util toString:fund.finalTerminationDate] forKey:@"Final Termination Date"];
     }
     [self.dictionary setObject:fundDetailsDict forKey:sectionName];
     NSLog(@"Section: %@, Dictionary %@", sectionName, fundDetailsDict);
     }
     
     
     NSArray* bankArray = [json objectForKey:@"BankDetail"];
     for (NSDictionary *bankDict in bankArray) {    
     //NSLog(@"Array count %@", [bankArray count]);
     
     Bank* bank = [Bank populateFromDictionary:bankDict];
     if(bank.account){
     NSString* sectionName = @"Bank Details";
     [self.sections addObject:sectionName];
     NSMutableDictionary* bankDetailsDict = [[NSMutableDictionary alloc] init];
     // I was getting the following exception when the app ran ( on displaying bank details)
     // [NSCFNumber isEqualToString:]: unrecognized selector sent to instance
     // I used formattedString and it worked fine
     if(bank.account){
     [bankDetailsDict setValue:[Util formattedString:bank.account] forKey:@"Account"];
     }
     if(bank.abaNumber){
     [bankDetailsDict setValue:[Util formattedString:bank.abaNumber] forKey:@"Routing"];
     }
     if(bank.accountNumber){
     [bankDetailsDict setValue:[Util formattedString:bank.accountNumber] forKey:@"Account Number"];
     }
     if(bank.accountOf){
     [bankDetailsDict setValue:[Util formattedString:bank.accountOf] forKey:@"Account Of"];
     }
     if(bank.reference){
     [bankDetailsDict setValue:[Util formattedString:bank.reference] forKey:@"Reference"];
     }
     
     if(bank.attention){
     [bankDetailsDict setValue:[Util formattedString:bank.attention] forKey:@"Attention"];
     }
     if(bank.swift){
     [bankDetailsDict setValue:[Util formattedString:bank.swift] forKey:@"Swift"];
     }
     if(bank.ffc){
     [bankDetailsDict setValue:[Util formattedString:bank.ffc] forKey:@"FFC"];
     }
     if(bank.ffcNumber){
     [bankDetailsDict setValue:[Util formattedString:bank.ffcNumber] forKey:@"FFC Number"];
     }
     if(bank.iban){
     [bankDetailsDict setValue:[Util formattedString:bank.iban] forKey:@"IBAN"];
     }
     
     if(bank.accountPhone){
     [bankDetailsDict setValue:[Util formattedString:bank.accountPhone] forKey:@"Phone"];
     }
     if(bank.accountFax){
     [bankDetailsDict setValue:[Util formattedString:bank.accountFax] forKey:@"Fax"];
     }
     if(bank.byOrderOf){
     [bankDetailsDict setValue:[Util formattedString:bank.byOrderOf] forKey:@"By Order Of"];
     }
     NSLog(@"Bank detail dictionary: %@", bankDetailsDict);
     [self.dictionary setObject:bankDetailsDict forKey:sectionName];
     }
     }
     */
    
    // Set a section for the links 
    /*
    NSString* actionString = @"More actions...";
    [self.sections addObject:actionString];
    
    NSMutableDictionary* actions = [[NSMutableDictionary alloc] initWithCapacity:3];
    [actions setValue:@"Investors" forKey:@"Investors"];
    [actions setValue:@"Capital Calls" forKey:@"Capital Calls"];
    [actions setValue:@"Capital Distributions" forKey:@"Capital Distributions"];
    [actions setValue:@"Deals" forKey:@"Deals"];
    [self.dictionary setObject:actions forKey:actionString];
    */
    
    NSLog(@"All Sections %@", self.sections);
    NSLog(@"Dictionary: %@", self.dictionary);
    
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    table.delegate = self;
    table.dataSource = self;
    //table.frame = CGRectMake(0, 0, 320, 480);
    // Show the graph here
    //VerticalBarChart * plotItem = [[VerticalBarChart alloc] init];
    //[plotItem renderInView:hostingView withTheme:nil];
}

- (void)drawGraph
{
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
    
    
    // Get the data for all the funds
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetFundDetail:self.selectedFundID];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // the data will be of the following format
    //{"page":1,"total":6,"rows":[{"cell":[42,"AMBERBROOK II LLC","82677f098e5e47ebb3c2526ff","\/Date(874882800000)\/","\/Date(1093993200000)\/",19000000.0000,16663986.3074]},{"cell":[43,"AMBERBROOK III LLC","4d17e7eef6794885aed6f3cb1","\/Date(962319600000)\/","\/Date(1183158000000)\/",75000000.0000,119014.7249]},{"cell":[44,"AMBERBROOK IV LLC","48e0f36fd3dc4d8bb0c0e4077","\/Date(1097708400000)\/","\/Date(1425168000000)\/",134062269.6600,-2844649.6808]},{"cell":[41,"AMBERBROOK LLC","2424a2ace6484276888ffb865","\/Date(804553200000)\/",null,5000000.0000,4979490.6098]},{"cell":[45,"AMBERBROOK V LLC","14f820143e3e46acb09cdd556","\/Date(1204070400000)\/","\/Date(1520899200000)\/",301650000.0000,46750285.9667]},{"cell":[46,"TEST AMBERBROOK FUND","12345","\/Date(1335394800000)\/","\/Date(1335394800000)\/",null,null]}]}
    
    NSMutableArray *myData = [json objectForKey:@"rows"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[myData count]; i++){        NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:i];
        float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:1] floatValue];
        NSNumber *num = [NSNumber numberWithFloat:totalCommitment];
        [array addObject:num];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray* sortedFloats = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    int counter = 0;
    NSMutableArray* copyDict = (NSMutableArray*)[myData mutableCopy];
    NSMutableArray* sortedFundNames = [[NSMutableArray alloc] init];
    float rest = 0;
    for (NSNumber* num in sortedFloats) {
        NSLog(@"%f", [num floatValue]);
        if(counter < 5){
            for (int i=0; i<[copyDict count]; i++){
                NSDictionary* dict = (NSDictionary*)[copyDict objectAtIndex:i];
                float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:4] floatValue];
                if(totalCommitment == [num floatValue]){
                    NSString* fundName = [[dict objectForKey:@"cell"] objectAtIndex:1];
                    [sortedFundNames addObject:fundName];
                    [copyDict removeObject:dict];
                    break;
                }
            }
        } else {
            rest+= [num floatValue];
        }
        counter++;
    }
    
    
    for (int i=0; i<[sortedFundNames count]; i++){
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[sortedFundNames objectAtIndex:i] value:[[sortedFloats objectAtIndex:i]floatValue]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = [self.sections count];
    //NSLog(@"Number of sections = %@", sectionCount);
	return  sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [[self.dictionary objectForKey:[self.sections objectAtIndex:section]] count];
    //NSLog(@"# of Row = %@ in section %@", numberOfRows, section);
	return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionHeader = [self.sections objectAtIndex:section];
    //NSLog(@"Section header: %@", sectionHeader);
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Need to get the text that will be displayed in order to calculate the height
	NSString *text = [self textForIndexPath:indexPath];
	// add 24 for padding
	CGFloat returnHeight = [self getHeightForText:text] + 24;
	return returnHeight;
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
    
    UITableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"TableIdentifier"];
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
    
    
	//if (currentCell == nil) {
    NSLog(@"Current cell is nil");
    currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableIdentifier"];
    NSString *label = [self labelForIndexPath:indexPath];
    NSString *text = [self textForIndexPath:indexPath];
    NSLog(@"Label: %@, Text: %@", label, text);
    NSLog(@"Section:%@",[NSString stringWithFormat:@"%d", indexPath.section]);
    /*
    if(indexPath.section == [self.sections count]-1){   
        currentCell.textLabel.text = text;
    } else {*/
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
        //}
        
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
    //}
    //}
    
	
	return currentCell;
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