//
//  dealDetailsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dealDetailsViewController.h"
#import "Util.h"


@implementation dealDetailsViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(NSDictionary*) getDeal: (NSDictionary*) json{
    NSArray *dealProperties = [NSArray arrayWithObjects:@"ContactName",@"SellerType",@"IsPartnered",@"PartnerName",@"IsDealClose", nil];
    
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Contact Name",@"ContactName",
                             @"Seller Type", @"SellerType",
                             @"Partnered", @"IsPartnered", 
                             @"Closed", @"IsDealClose", nil];
    
    NSMutableDictionary* dealDict = 
    [Util getFilteredDictionary:json withPropertyNames:dealProperties withOverrideKeys:mapping withDateKeys:nil];
    NSLog(@"Filtered fund dictionary %@", dealDict);
    return dealDict;
}

-(NSDictionary*) getSellerInfo: (NSDictionary*) json{
    // SellerInfo":{"DealId":577,"SellerContactId":643,"ContactName":null,"Phone":"","Fax":"","SellerName":"Test Seller","SellerType":null,"SellerTypeId":null,"CompanyName":"","Email":""}
    
    NSArray *sellerProperties = [NSArray arrayWithObjects:@"ContactName",@"Phone",@"Fax",@"SellerName",@"SellerType", @"CompanyName", @"Email", nil];
    
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Contact Name",@"ContactName",
                             @"Seller Name", @"SellerName",
                             @"Seller Type", @"SellerType", 
                             @"Company Name", @"Company Name", nil];
    
    NSMutableDictionary* sellerDict = 
    [Util getFilteredDictionary:json withPropertyNames:sellerProperties withOverrideKeys:mapping withDateKeys:nil];
    NSLog(@"Filtered fund dictionary %@", sellerDict);
    return sellerDict;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData* responseData = [self.appDelegate.api GetFundDetail:self.selectedID];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"DealId":577,"DealName":"Miami Corp.","DealNumber":3,"ContactId":615,"ContactName":"Jerry","PurchaseTypeId":1,"SellerContactId":643,"SellerTypeId":2,"SellerType":"Bank","IsPartnered":false,"PartnerName":null,"IsDealClose":false,"DocumentFileExtensions":null,"SellerInfo":{"DealId":577,"SellerContactId":643,"ContactName":null,"Phone":"","Fax":"","SellerName":"Test Seller","SellerType":null,"SellerTypeId":null,"CompanyName":"","Email":""},"DealExpenses":[{"DealClosingCostId":667,"Description":"Administration Fees","DealClosingCostTypeId":2,"DealId":577,"Amount":50.0000,"Date":"\/Date(1331510400000)\/"}],"DealUnderlyingFunds":[{"DealUnderlyingFundId":1281,"FundName":"Sevin Rosen Fund II LP","DealId":577,"FundId":31,"UnderlyingFundId":1425,"RecordDate":"\/Date(812498400000)\/","FundNAV":106099.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":102059.2546,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":102059.2546,"ReassignedGPP":null,"AdjustedCost":0.0000},{"DealUnderlyingFundId":1282,"FundName":"Sevin Rosen Fund III LP","DealId":577,"FundId":31,"UnderlyingFundId":1426,"RecordDate":"\/Date(812498400000)\/","FundNAV":70630.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":67940.7454,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":67940.7454,"ReassignedGPP":null,"AdjustedCost":0.0000}],"DealUnderlyingDirects":[],"FundId":31,"FundName":"AMBERBROOK LLC"}
    // The above response is dictionary
    NSLog(@"JSon recieved: %@", json);
    NSString* dealName = [json objectForKey:@"DealName"];
    
    // Set the title of the view to the fund name
    [self setTitle:dealName];
    
    // Prepare data for the table view
    // Aggregate the datasets to bind to the table view. 
    // Sections will contain the name of different sections, like fund info, bank info etc
	self.sections = [[NSMutableArray alloc] init];
    // dictionary will contain the values that make up a section. the key for the dictionary will be the section name
	self.dictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary* dealInfo = [self getDeal:json];
    NSString* sectionName = @"Deal Info";
    if([dealInfo count] > 0){
        [self.sections addObject:sectionName];
        [self.dictionary setObject:dealInfo forKey:sectionName];
    }
    
    // Seller Info
    // SellerInfo":{"DealId":577,"SellerContactId":643,"ContactName":null,"Phone":"","Fax":"","SellerName":"Test Seller","SellerType":null,"SellerTypeId":null,"CompanyName":"","Email":""}
    
    NSDictionary* sellerInfo = [self getSellerInfo:[json objectForKey:@"SellerInfo"]];
    sectionName = @"Seller Info";
    if([sellerInfo count] > 0){
        [self.sections addObject:sectionName];
        [self.dictionary setObject:sellerInfo forKey:sectionName];
    }
    
    // Deal expenses
    // "DealExpenses":[{"DealClosingCostId":667,"Description":"Administration Fees","DealClosingCostTypeId":2,"DealId":577,"Amount":50.0000,"Date":"\/Date(1331510400000)\/"}]
    NSMutableArray* dealExpenses = [json objectForKey:@"DealExpenses"];
    sectionName = @"Expenses";
    if([dealExpenses count] > 0){
        [self.sections addObject:sectionName];
        [self.dictionary setObject:dealExpenses forKey:sectionName];
    }
    
    // Deal underlying funds
    // "DealUnderlyingFunds":[{"DealUnderlyingFundId":1281,"FundName":"Sevin Rosen Fund II LP","DealId":577,"FundId":31,"UnderlyingFundId":1425,"RecordDate":"\/Date(812498400000)\/","FundNAV":106099.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":102059.2546,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":102059.2546,"ReassignedGPP":null,"AdjustedCost":0.0000},{"DealUnderlyingFundId":1282,"FundName":"Sevin Rosen Fund III LP","DealId":577,"FundId":31,"UnderlyingFundId":1426,"RecordDate":"\/Date(812498400000)\/","FundNAV":70630.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":67940.7454,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":67940.7454,"ReassignedGPP":null,"AdjustedCost":0.0000}]
    NSMutableArray* dealUnderlyingFunds = [json objectForKey:@"DealUnderlyingFunds"];
    sectionName = @"Underlying Funds";
    if([dealUnderlyingFunds count] > 0){
        [self.sections addObject:sectionName];
        [self.dictionary setObject:dealUnderlyingFunds forKey:sectionName];
    }

    // Deal underlying directs
    // "DealUnderlyingDirects":[]
    NSMutableArray* dealUnderlyingDirects = [json objectForKey:@"DealUnderlyingDirects"];
    sectionName = @"Underlying Directs";
    if([dealUnderlyingDirects count] > 0){
        [self.sections addObject:sectionName];
        [self.dictionary setObject:dealUnderlyingDirects forKey:sectionName];
    }
    
    NSLog(@"All Sections %@", self.sections);
    NSLog(@"Dictionary: %@", self.dictionary);
    
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    /*
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, 320, 480);
    */
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

- (UITableViewCell *) getUnderlyingFundCell:(NSString *)cellIdentifier { 
    // {"DealUnderlyingFundId":1281,"FundName":"Sevin Rosen Fund II LP","DealId":577,"FundId":31,"UnderlyingFundId":1425,"RecordDate":"\/Date(812498400000)\/","FundNAV":106099.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":102059.2546,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":102059.2546,"ReassignedGPP":null,"AdjustedCost":0.0000}
    // FundName
    // Recorded on date
    // FundNav (x$ committed)
    // GPP / NPP
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString* sectionName = [self.sections objectAtIndex:indexPath.section];
    NSArray* sections = [[NSArray alloc] initWithObjects:@"Deal Info",@"Seller Info", @"Expenses", nil];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if([sections containsObject:sectionName]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        } else {
            if ([sectionName isEqualToString:@"Underlying Funds"]){
                cell = [self getUnderlyingFundCell:CellIdentifier];
            } else if ([sectionName isEqualToString:@"Underlying Directs"]){
            }
        }
    }
    
    // Configure the cell...
    if([sections containsObject:sectionName]){
        NSString *label = [self labelForIndexPath:indexPath];
        NSString *text = [self textForIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", label, text];
    } else {
        // Underlying funds
        if ([sectionName isEqualToString:@"Underlying Funds"]){
            UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
            UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
            UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
            UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];
            
            /*
            NSString *sectionKey = [self.sections objectAtIndex:[indexPath section]];
            NSMutableArray* sectionRows = [self.dictionary objectForKey:sectionKey];
            NSDictionary* sdict = [sectionRows objectAtIndex:indexPath.row];
            */
            
            NSDictionary* sdict = [self dictionaryForIndexPath:indexPath];
            
            // {"DealUnderlyingFundId":1281,"FundName":"Sevin Rosen Fund II LP","DealId":577,"FundId":31,"UnderlyingFundId":1425,"RecordDate":"\/Date(812498400000)\/","FundNAV":106099.0000,"CommittedAmount":200000.0000,"Percent":null,"UnfundedAmount":0.0000,"GrossPurchasePrice":102059.2546,"PostRecordDateCapitalCall":null,"PostRecordDateDistribution":null,"DealClosingId":546,"IsClose":true,"NetPurchasePrice":102059.2546,"ReassignedGPP":null,"AdjustedCost":0.0000}
            // FundName
            // Recorded on date
            // FundNav (x$ committed)
            // GPP / NPP
            
            NSString* ufName = [Util formattedString:[sdict objectForKey:@"FundName"]];
            NSString* recordDate = [Util toFormattedDateString:[Util mfDateFromDotNetJSONString:(NSString*)[sdict objectForKey:@"RecordDate"]]];
            NSString* fundNav = [Util formattedString:[sdict objectForKey:@"FundNAV"]];
            NSString* committedAmount = [Util formattedString:[sdict objectForKey:@"CommittedAmount"]];
            NSString* gPP = [Util formattedString:[sdict objectForKey:@"GrossPurchasePrice"]];
            NSString* nPP = [Util formattedString:[sdict objectForKey:@"NetPurchasePrice"]];
            //NSString* profit = [Util formattedString:[sdict objectForKey:@"Profit"]];
            //NSString* profitReturn = [Util formattedString:[sdict objectForKey:@"ProfitReturn"]];
            
            lblTemp1.text = ufName;
            lblTemp2.text = [NSString stringWithFormat:@"Recorded on %@", recordDate];
            lblTemp3.text = [NSString stringWithFormat:@"FundNav:%@ (%@ committed)", fundNav, committedAmount];
            lblTemp4.text = [NSString stringWithFormat:@"%@ / %@", gPP, nPP];
        }
        // Underlying Directs
        else if ([sectionName isEqualToString:@"Underlying Directs"]){
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
