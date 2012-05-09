//
//  investorsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "investorsViewController.h"
#import "pepperAppDelegate.h"
#import "investorFundDetails.h"

// Private variables. To declare private variables, you use the interface keyword with the name of your class followed by closed braces
@interface investorsViewController()
// nonatomic means that this property is not thread safe
@property (nonatomic, retain) NSMutableDictionary* investorsToFund;
@end

@implementation investorsViewController

@synthesize investorsToFund = _investorsToFund;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the list of the Funds from the api
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetInvestors];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     options:kNilOptions 
                     error:&error];
    // The response from the server would be like this:
    // /Investor/InvestorLibraryList?pageIndex=1&pageSize=500
    /*
    {"FlexGridData":
        {"page":1,"total":11,"rows":[
            {"cell":[{"FundName":"Amberbrook","FundID":12,"TotalCommitted":5645651564654.0000}]},{"cell":[{"FundName":"Amberbrook (MK Test #2)","FundID":25,"TotalCommitted":10000000.0000}]},{"cell":[{"FundName":"Amberbrook 1","FundID":13,"TotalCommitted":342445925434.0000}]},{"cell":[{"FundName":"Amberbrook 123","FundID":24,"TotalCommitted":10000000.0000}]},{"cell":[{"FundName":"AMBERBROOK II LLC","FundID":18,"TotalCommitted":19000000.0000}]}
                                     ]},
        "Investors":
        [{"InvestorID":29,"FundID":18,"InvestorName":"Alegria LLC"},
        {"InvestorID":17,"FundID":12,"InvestorName":"American Legacy Foundation"},
        {"InvestorID":24,"FundID":12,"InvestorName":"Blair Academy"},
        {"InvestorID":23,"FundID":13,"InvestorName":"BRAC Associates LLC"},
        {"InvestorID":51,"FundID":18,"InvestorName":"Ellen M. Poss"},{"InvestorID":59,"FundID":18,"InvestorName":"Gregory E. Rea, M.D."},{"InvestorID":63,"FundID":18,"InvestorName":"Herbert W. Hirsch, SEP IRA"},{"InvestorID":125,"FundID":25,"InvestorName":"Investor 1 (MK Test #2)"},{"InvestorID":123,"FundID":24,"InvestorName":"Investor 123"},{"InvestorID":126,"FundID":25,"InvestorName":"Investor 2 (MK Test #2)"},{"InvestorID":69,"FundID":18,"InvestorName":"ISLP"},{"InvestorID":18,"FundID":12,"InvestorName":"James Tannoy"},
        {"InvestorID":72,"FundID":18,"InvestorName":"Jerrold M. Newman"},
        {"InvestorID":73,"FundID":18,"InvestorName":"Jerrold M. Newman (m)"},
        {"InvestorID":83,"FundID":18,"InvestorName":"Luisa Hunnewell"},{"InvestorID":132,"FundID":18,"InvestorName":"M. Luisa Hunnewell & Laurence M. Newman"},{"InvestorID":87,"FundID":18,"InvestorName":"Mitchell Kapor"},{"InvestorID":88,"FundID":18,"InvestorName":"Nadine F. Newman"},{"InvestorID":94,"FundID":18,"InvestorName":"QTIP Trust u/w/o Michel Fribourg"},{"InvestorID":100,"FundID":18,"InvestorName":"Sippel Farb Family Trust"},{"InvestorID":20,"FundID":13,"InvestorName":"Test Investor 123"},{"InvestorID":14,"FundID":13,"InvestorName":"Test Investor 2"},{"InvestorID":111,"FundID":18,"InvestorName":"The Trustees of Hamilton College"},{"InvestorID":19,"FundID":13,"InvestorName":"Valentine Doe"},{"InvestorID":124,"FundID":25,"InvestorName":"Willowridge (MK Test #2)"},{"InvestorID":122,"FundID":24,"InvestorName":"Willowridge 123"},{"InvestorID":119,"FundID":12,"InvestorName":"Willowridge V LLC"}],"LeftPageIndex":0,"RightPageIndex":2,
        "Library":
        [{"FundName":"Amberbrook","FundID":12,"FundInformations":
            [{"CommitmentAmount":5645645564654.0000,"UnfundedAmount":5645645564654.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1317779530657)\/","CloseDate":"\/Date(1314831600000)\/","InvestorID":119,"FundID":0,"InvestorName":"Willowridge V LLC"},
            {"CommitmentAmount":2000000.0000,"UnfundedAmount":2000000.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1315875039360)\/","CloseDate":"\/Date(1314831600000)\/","InvestorID":24,"FundID":0,"InvestorName":"Blair Academy"},
            {"CommitmentAmount":1000000.0000,"UnfundedAmount":1000000.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1315875077063)\/","CloseDate":"\/Date(1314831600000)\/","InvestorID":17,"FundID":0,"InvestorName":"American Legacy Foundation"},
             
            {"CommitmentAmount":3000000.0000,"UnfundedAmount":3000000.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1315875100140)\/","CloseDate":"\/Date(1314831600000)\/","InvestorID":18,"FundID":0,"InvestorName":"James Tannoy"}],"TotalCommitted":5645651564654.0000},{"FundName":"Amberbrook (MK Test #2)","FundID":25,"FundInformations":[{"CommitmentAmount":3000000.0000,"UnfundedAmount":2308666.6666,"FundClose":"Close 1 (MK Test #2)","CommittedDate":"\/Date(1318847120747)\/","CloseDate":"\/Date(1317423600000)\/","InvestorID":125,"FundID":0,"InvestorName":"Investor 1 (MK Test #2)"},{"CommitmentAmount":6000000.0000,"UnfundedAmount":4617333.3333,"FundClose":"Close 1 (MK Test #2)","CommittedDate":"\/Date(1318847142967)\/","CloseDate":"\/Date(1317423600000)\/","InvestorID":126,"FundID":0,"InvestorName":"Investor 2 (MK Test #2)"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":848000.0000,"FundClose":"Close 1 (MK Test #2)","CommittedDate":"\/Date(1318851766233)\/","CloseDate":"\/Date(1317423600000)\/","InvestorID":124,"FundID":0,"InvestorName":"Willowridge (MK Test #2)"}],"TotalCommitted":10000000.0000},{"FundName":"Amberbrook 1","FundID":13,
                
                "FundInformations":
                [{"CommitmentAmount":20000000.0000,"UnfundedAmount":8746454.9064,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1086130800000)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":17,"FundID":0,"InvestorName":"American Legacy Foundation"},
                {"CommitmentAmount":500000.0000,"UnfundedAmount":218661.3725,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1086130800000)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":18,"FundID":0,"InvestorName":"James Tannoy"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":534883.7209,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1086130800000)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":19,"FundID":0,"InvestorName":"Valentine Doe"},{"CommitmentAmount":1000.0000,"UnfundedAmount":1000.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1314710229627)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":14,"FundID":0,"InvestorName":"Test Investor 2"},{"CommitmentAmount":200.0000,"UnfundedAmount":200.0000,"FundClose":null,"CommittedDate":null,"CloseDate":null,"InvestorID":20,"FundID":0,"InvestorName":"Test Investor 123"},{"CommitmentAmount":342423424234.0000,"UnfundedAmount":342423424234.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1317779249687)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":119,"FundID":0,"InvestorName":"Willowridge V LLC"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":1000000.0000,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1086130800000)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":23,"FundID":0,"InvestorName":"BRAC Associates LLC"}],"TotalCommitted":342445925434.0000},{"FundName":"Amberbrook 123","FundID":24,"FundInformations":[{"CommitmentAmount":1000000.0000,"UnfundedAmount":929400.0000,"FundClose":"Amb 123 (Close 1)","CommittedDate":"\/Date(1318846148547)\/","CloseDate":"\/Date(1317423600000)\/","InvestorID":122,"FundID":0,"InvestorName":"Willowridge 123"},{"CommitmentAmount":9000000.0000,"UnfundedAmount":8364600.0000,"FundClose":"Amb 123 (Close 1)","CommittedDate":"\/Date(1318846444623)\/","CloseDate":"\/Date(1317423600000)\/","InvestorID":123,"FundID":0,"InvestorName":"Investor 123"}],"TotalCommitted":10000000.0000},{"FundName":"AMBERBROOK II LLC","FundID":18,"FundInformations":[{"CommitmentAmount":152000.0000,"UnfundedAmount":11128.0480,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096379363)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":72,"FundID":0,"InvestorName":"Jerrold M. Newman"},{"CommitmentAmount":38000.0000,"UnfundedAmount":2782.0120,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096379613)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":83,"FundID":0,"InvestorName":"Luisa Hunnewell"},{"CommitmentAmount":6000000.0000,"UnfundedAmount":2.0831,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096379850)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":29,"FundID":0,"InvestorName":"Alegria LLC"},{"CommitmentAmount":2000000.0000,"UnfundedAmount":0.6934,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096380130)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":94,"FundID":0,"InvestorName":"QTIP Trust u/w/o Michel Fribourg"},{"CommitmentAmount":5000000.0000,"UnfundedAmount":1.7357,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096380443)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":111,"FundID":0,"InvestorName":"The Trustees of Hamilton College"},{"CommitmentAmount":75000.0000,"UnfundedAmount":0.0250,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096380740)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":63,"FundID":0,"InvestorName":"Herbert W. Hirsch, SEP IRA"},{"CommitmentAmount":212000.0000,"UnfundedAmount":15520.6975,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096381287)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":132,"FundID":0,"InvestorName":"M. Luisa Hunnewell & Laurence M. Newman"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":0.3464,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096381583)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":69,"FundID":0,"InvestorName":"ISLP"},{"CommitmentAmount":750000.0000,"UnfundedAmount":0.2594,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096381863)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":87,"FundID":0,"InvestorName":"Mitchell Kapor"},{"CommitmentAmount":923000.0000,"UnfundedAmount":67573.6063,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096382100)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":73,"FundID":0,"InvestorName":"Jerrold M. Newman (m)"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":73210.8411,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096382443)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":88,"FundID":0,"InvestorName":"Nadine F. Newman"},{"CommitmentAmount":750000.0000,"UnfundedAmount":0.2594,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096382660)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":51,"FundID":0,"InvestorName":"Ellen M. Poss"},{"CommitmentAmount":1000000.0000,"UnfundedAmount":0.3464,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096382910)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":59,"FundID":0,"InvestorName":"Gregory E. Rea, M.D."},{"CommitmentAmount":100000.0000,"UnfundedAmount":0.0336,"FundClose":"FC-12/5/2011 4:42:47 PM","CommittedDate":"\/Date(1323096383257)\/","CloseDate":"\/Date(1323103367000)\/","InvestorID":100,"FundID":0,"InvestorName":"Sippel Farb Family Trust"}],"TotalCommitted":19000000.0000}]}
    */

    // The above response is an array of dictionaries
    NSLog(@"JSon recieved: %@", json);
    // Create an array to hold all the funds
    //NSMutableArray* funds = [NSMutableArray arrayWithCapacity:[json count]];
    myData = [json objectForKey:@"Investors"];
    
    NSLog(@"Investors: %@", myData);
    
    self.investorsToFund = [[NSMutableDictionary alloc] init]; 
    
    NSArray* funds = [json objectForKey:@"Library"];
    for (int i = 0; i < [funds count]; i++)
    {
        // Each entry in the array is a dictionary
        NSDictionary *dict = [funds objectAtIndex:i];
        NSArray* fundsInformations = [dict objectForKey:@"FundInformations"];
        for (int j = 0; j < [fundsInformations count]; j++)
        {
            // {"CommitmentAmount":20000000.0000,"UnfundedAmount":8746454.9064,"FundClose":"Fund Close 1","CommittedDate":"\/Date(1086130800000)\/","CloseDate":"\/Date(1086130800000)\/","InvestorID":17,"FundID":0,"InvestorName":"American Legacy Foundation"}
            NSDictionary *description = [fundsInformations objectAtIndex:j];
            NSLog(@"Description: %@", description);
            NSLog(@"InvestorName: %@", [description objectForKey:@"InvestorName"]);
            NSLog(@"InvestorID: %@", [description objectForKey:@"InvestorID"]);
            
            id investorId = [description objectForKey:@"InvestorID"];
            //int investorId = [description objectForKey:@"InvestorID"];
            NSLog(@"InvestorId: %d", investorId);
            NSMutableArray* entry = [self.investorsToFund objectForKey:investorId];
            //NSMutableArray* entry = [self.investorsToFund objectForKey:[NSNumber numberWithInt:investorId]];
            if(entry == nil){
                entry = [[NSMutableArray alloc] init]; 
                //[self.investorsToFund setObject:entry forKey:[NSNumber numberWithInt:investorId]];
                [self.investorsToFund setObject:entry forKey:investorId];
            }
            // Also add the Fund name 
            //{"FundName":"Amberbrook","FundID":12,
            NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:description];
            [newDict setObject:[dict objectForKey:@"FundName"] forKey:@"FundName"];
            [entry addObject:newDict];
        }
    }
    
    NSLog(@"InvestorsToFund: %@", self.investorsToFund);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A cell identifier which matches our identifier in IB (attributes inspector when you click on the cell)
    static NSString *CellIdentifier = @"fundNameCell";
    
    // Create or reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Get the cell label using it's tag and set it
    NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:indexPath.row];
    /*
     UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
     [cellLabel setText:[myData objectAtIndex:indexPath.row]];
     */
    cell.textLabel.text = [dict objectForKey:@"InvestorName"];
    
    
    // get the cell imageview using it's tag and set it
    //UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    //[cellImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.row]]];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    investorFundDetails *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"investorFundDetails"];
    NSDictionary *dict = [myData objectAtIndex:indexPath.row];
    id investorId = [dict objectForKey:@"InvestorID"];
    NSLog(@"InvestorID: %@", investorId);
    NSMutableArray* entry = [self.investorsToFund objectForKey:investorId];
    detail.fundsForinvestor = entry;
    NSLog(@"FundsForInvestor: %@", entry);
    [self.navigationController pushViewController:detail animated:YES];
    */
    
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UINavigationController* detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"investorFundDetailsViewRoot"]; 
        investorFundDetails* invFundsDetails = (investorFundDetails*)detailsController.topViewController;
        NSDictionary *dict = [myData objectAtIndex:indexPath.row];
        id investorId = [dict objectForKey:@"InvestorID"];
        NSLog(@"InvestorID: %@", investorId);
        NSMutableArray* entry = [self.investorsToFund objectForKey:investorId];
        invFundsDetails.fundsForinvestor = entry;
    
    if(detailsController != nil){
        [invFundsDetails.navigationItem setLeftBarButtonItem:appDelegate.masterBarButtonItem animated:NO];
        
        
        NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:appDelegate.splitViewController.viewControllers];
        [arr replaceObjectAtIndex:1 withObject:detailsController]; //index 1 corresponds to the detail VC
        appDelegate.splitViewController.viewControllers = arr;
    }

    
    // INFO: Do this no matter what. When you come back to this view controller again, the row you selected should be de-selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
}
@end
