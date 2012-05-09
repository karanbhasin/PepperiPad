//
//  fundsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fundsViewController.h"
#import "pepperAppDelegate.h"
#import "fundActionsViewController.h"


@implementation fundsViewController

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
    NSData* responseData = [appDelegate.api GetFunds:nil];
    
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // [{"id":2,"label":"AMBERBROOK II LLC","value":"AMBERBROOK II LLC"},{"id":3,"label":"AMBERBROOK III LLC","value":"AMBERBROOK III LLC"},{"id":4,"label":"AMBERBROOK IV LLC","value":"AMBERBROOK IV LLC"},{"id":1,"label":"AMBERBROOK LLC","value":"AMBERBROOK LLC"},{"id":5,"label":"AMBERBROOK V LLC","value":"AMBERBROOK V LLC"}]
    // The above response is an array of dictionaries
    NSLog(@"JSon recieved: %@", json);
    // Create an array to hold all the funds
    //NSMutableArray* funds = [NSMutableArray arrayWithCapacity:[json count]];
    myData = [NSMutableArray arrayWithCapacity:[json count]];
    for (int i = 0; i < [json count]; i++)
    {
        // Each entry in the array is a dictionary
        NSDictionary *dict = [json objectAtIndex:i];
        //for(NSString *key in dict) {
            //[funds addObject:[dict objectForKey:@"value"]];
            [myData addObject:dict];        //}
    }
    NSLog(@"date for funds: %@", myData);
    //NSLog(@"Funds: %@", funds);
    
    // Define our test data
    /*
    myData = [NSMutableArray arrayWithObjects:
              @"Chasing Amy", 
              @"Mallrats", 
              @"Dogma", 
              @"Clerks", 
              @"Jay & Silent Bob Strike Back",
              @"Red State",
              @"Cop Out",
              @"Jersey Girl",
              nil];
    myData = funds;
     */
    


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
    cell.textLabel.text = [dict objectForKey:@"value"];
    
    
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

// Do some customisation of our new view when a table item has been selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"fundsToActions"]) {
        
        // Get reference to the destination view controller
        fundActionsViewController *actions = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        // Pass the name and index of our film
        actions.selectedFundID = [[myData objectAtIndex:selectedIndex] objectForKey:@"id"];
    }
}
@end
