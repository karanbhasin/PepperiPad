//
//  underlyingFundsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


///Deal/FindGPs // Get all Issuers
///Deal/UnderlyingFundList?isGP=true&gpId=0&underlyingFundID=0&companyId=0
// select all the UF that belong to a GP
///Deal/UnderlyingFundList?isGP=true&gpId=18&underlyingFundID=0&companyId=18

#import "underlyingFundsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"

@implementation underlyingFundsViewController

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
    NSData* responseData = [appDelegate.api GetUnderlyingFunds];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     options:kNilOptions 
                     error:&error];
    // The response from the server would be like this:
    // {"page":1,"total":443,"rows":[{"cell":[24,"Abbingdon Venture Partners LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[25,"Acacia Venture Partners II, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[26,"Acacia Venture Partners, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[27,"Acadia Partners LP","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[28,"Accel Internet Fund IV L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[29,"Adams Capital Management, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[30,"Adams Street V","Buyout-Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[31,"Advanced Equities Investments XXXII, LLC","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[32,"Advent Israel, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[33,"Advent V LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[34,"Advisors Series Venture and Technology, LLC","Fund of Funds","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[35,"AEI 2006 Venture Investments II, LLC","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[36,"Alta Communications VI, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[37,"Alta III LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[38,"Alta IV LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[39,"Alta V Limited Partnership","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[40,"Altos Ventures II LP","Venture","Diversified",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[9,"Amberbrook UF","Fund of Fund","",16,"GP"]},{"cell":[41,"American Industrial Partners Capital Fund LP","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[42,"Ampersand 1995 Limited Partnership","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[43,"Anthem Capital II, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[44,"AOS Partners, LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[45,"APA Excelsior III LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[46,"APA Excelsior IV LP","Venture","Diversified",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[47,"APA Excelsior IV Offshore, LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[48,"APA Excelsior V, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[49,"Apax Germany II, LP","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[50,"Apax Israel II, LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[51,"Apax Ventures III International Partners","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[52,"Apollo Investment Fund III, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[53,"Apollo Investment Fund IV, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[54,"Applied Genomic Technology Capital Fund, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[55,"Arctic Asia Opportunities Fund, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[56,"Argo Global Capital II Partners L.P.","Venture","Communication Equipment",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[57,"Ascend Technology Ventures, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[58,"AsiaStar IT Fund, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[59,"ASP Bedrock Associates II LLC","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[60,"ASP Bedrock Associates III LLC","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[61,"Asset Management 1984 LP","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[62,"Asset Management Associates 1989, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[63,"Atlas Venture Fund III, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[64,"Auda Capital Emerging Markets LP","Fund of Funds","Diversified",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[65,"August Capital III, L.P.","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[66,"Austin Ventures III, LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[67,"Austin Ventures VII","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[68,"Austin Ventures VIII","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[69,"B III Capital Partners, L.P.","Buyout","Diversified",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[70,"Bain Capital Fund VI Coinvestment, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[71,"Bain Capital Fund VI LP","Buyout","Diversified",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]},{"cell":[72,"Bain Capital Fund VII, L.P.","Buyout","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"]}]}
    // The above response is an array of dictionaries
    NSLog(@"JSon recieved: %@", json);
    
    myData = [json objectForKey:@"rows"];
    
    
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

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, 300, 60);
    CGRect Label1Frame = CGRectMake(10, 10, 290, 25);
    CGRect Label2Frame = CGRectMake(10, 33, 290, 25);
    //CGRect Label3Frame = CGRectMake(10, 56, 290, 25);
    //CGRect Label4Frame = CGRectMake(10, 79, 290, 25);
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
    
    /*
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
    */
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"underlyingFundNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [self getCellContentView:CellIdentifier];
    }
        
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
         
         [24,"Abbingdon Venture Partners LP","Venture","Wireless Applications",33,"Data Conversion from Blue 10/16/2011 3:17:46 PM"
         */
        // The value in the dictionary for the key "cell" is an array. we want the first item in the array as the investor name
        //cell.textLabel.text = [[dict objectForKey:@"cell"] objectAtIndex:0];
        
        /////
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
        
        lblTemp1.text = [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:1]];
        lblTemp2.text = [NSString stringWithFormat:@"%@ (%@)", [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:3]], [Util formattedString:[[dict objectForKey:@"cell"] objectAtIndex:2]]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 120;
    return 60;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    //searching = YES;
    //letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)];
}
*/
/*
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar’s cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [tableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]searchText==nil){
        [self.tableView reloadData];
        return;
    }
    NSInteger counter = 0;
    for(NSString *name in dataSource)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        NSRange r = [name rangeOfString:searchText];
        if(r.location != NSNotFound)
        {
            if(r.location== 0)//that is we are checking only the start of the names.
            {
                [tableData addObject:name];
            }
        }
        counter++;
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:dataSource];
    @try{
        [myTableView reloadData];
    }
    @catch(NSException *e){
    }
    [sBar resignFirstResponder];
    sBar.text = @”";
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
*/
@end
