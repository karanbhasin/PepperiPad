//
//  directDetailsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "directDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "capitalCallViewController.h"
#import "capitalDistributionViewController.h"
#import "Util.h"

@interface directDetailsViewController () 
@property (nonatomic, retain) NSMutableArray *directs;
@end

@implementation directDetailsViewController

@synthesize selectedDirectID = _selectedDirectID;
@synthesize sections = _sections;
@synthesize dictionary = _dictionary;
@synthesize directs = _directs;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetDirectDetails:self.selectedDirectID];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"page":1,"total":1,"rows":[{"ID":24,"SecurityType":"Equity","Symbol":"2Wire","Industry":null,"Security":"Common"}]}
    // The above response is dictionary
    NSLog(@"JSon recieved: %@", json);
    self.directs = [json objectForKey:@"rows"];
    // This is necessary, otherwise none of the delegate methods for the table view( like numberOfSectionsInTableView)  will get
    // triggered. This is only necessary if you have not chosen to create the TableViewController, in which case the IB does it for you. Even if you have created a UIView, and dropped a Table view on it, and have used an IBOutlet to connect the variable in the controller to the view in the nib(or story board), you still have to do this.
    table.delegate = self;
    table.dataSource = self;
    //table.frame = CGRectMake(0, 0, 320, 480);
}


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


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        if([self.directs count] > 0){
            return [self.directs count];
        } else {
            return 1;
        }
    } else {
        return 3; 
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return @"Details";
    } else {
        return @"More actions...";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0){
        return 90;
    }
    return 30;
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
    /*
    lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
    lblTemp.tag = 4;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    lblTemp.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lblTemp];*/
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if(indexPath.section == 0){
        cell = [self getCellContentView:CellIdentifier];
        
        
        // Configure the cell...
        
        // Get the cell label using it's tag and set it
        NSDictionary* dict = (NSDictionary*)[self.directs objectAtIndex:indexPath.row];
        NSLog(@"Dict %@", dict);
        // The returned dictionary will be of the format
        /*
         {"ID":24,"SecurityType":"Equity","Symbol":"2Wire","Industry":null,"Security":"Common"}
         */
        // The value in the dictionary for the key "cell" is an array. we want the first item in the array as the investor name
        //cell.textLabel.text = [[dict objectForKey:@"cell"] objectAtIndex:0];
        
        /////
        
        UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
        UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
        UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];
        
        lblTemp1.text = [dict objectForKey:@"Symbol"];
        lblTemp2.text = [NSString stringWithFormat:@"%@, %@", [dict objectForKey:@"Security"] , [dict objectForKey:@"SecurityType"]];
        if([Util isValidValue:[dict objectForKey:@"Industry"] ]){
                lblTemp3.text =  [Util formattedString:[dict objectForKey:@"Industry"]];
            }
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSString* moreAction = @"";
            if(indexPath.row == 0){
                moreAction = @"Valuations";
           } else if(indexPath.row == 1){
            moreAction = @"Dividends";
            } else {
                moreAction =  @"Conversion & Splits";
            }
            cell.textLabel.text = moreAction;
        }
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    // deselect the row and do nothing
    if (indexPath.section == ([self.sections count] - 1)) {
        // Find out what was selected
        int row = indexPath.row;
        if(row == 0){
            capitalCallViewController *ccController = [self.storyboard instantiateViewControllerWithIdentifier:@"CapitalCallViewController"];
            ccController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:ccController animated:YES];
        } else if(row == 1){
            //capitalDistributionViewController *ccController = [[capitalDistributionViewController alloc] initWithNibName:@"CapitalDistributionViewController" bundle:nil];
            //INFO: the above line with initWithNibName was loading the view, but the outlets (IBOUTBELT table) were not wired up when the view loaded. Had to use the following code
            capitalDistributionViewController *ccController = [self.storyboard instantiateViewControllerWithIdentifier:@"CapitalDistributionViewController"];
            ccController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:ccController animated:YES];
        }
        else if(row == 2){
            //Initialize the detail view controller and display it.
            investorDetailsViewController *invController = [[investorDetailsViewController alloc] init];
            invController.selectedFundID = self.selectedFundID;
            [self.navigationController pushViewController:invController animated:YES];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    */
    /*
     if (indexPath.section == 0 || indexPath.section == 1) {
     
     // Get the object that is being touched
     id obj = [self getObjectForIndexPath:indexPath];
     
     // De select the button after selecting it
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     // Determine what type of table cell the user is touching
     if ([obj isKindOfClass:[FOAddress class]]) {
     
     // Open the address view
     AddressViewController *addressViewController = [[AddressViewController alloc] initWithAddress:(FOAddress*)obj];
     
     [self presentModalViewController:addressViewController animated:YES];
     
     [addressViewController release];
     
     }
     else if ([obj isKindOfClass:[FOCommunication class]]) {
     
     MFMailComposeViewController *mfMailController = [[MFMailComposeViewController alloc] init];
     mfMailController.mailComposeDelegate = self;
     
     // Determine what type of communication it is
     switch ([(FOCommunication *)obj typeId]) {
     case 4:
     case 12:
     case 127:
     case 128:
     // For email, open an email Modal window
     [mfMailController setToRecipients:[NSArray arrayWithObject:[(FOCommunication *)obj value]]];
     [self presentModalViewController:mfMailController animated:YES];
     break;
     default:
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(FOCommunication *)obj urlScheme]]];
     break;
     }
     
     [mfMailController release];
     }	
     }
     else {
     // deselect the row and do nothing
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     }
     */
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
    return UITableViewCellAccessoryNone;
}

@end
