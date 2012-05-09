//
//  directsViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "directsViewController.h"
#import "directDetailsViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"

@implementation directsViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the list of the Funds from the api
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetDirects];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions 
                          error:&error];
    // The response from the server would be like this:
    // {"page":1,"total":364,"rows":[{"cell":[35,"2Wire, Inc."]},{"cell":[36,"3PAR Inc."]},{"cell":[37,"3Pardata, Inc."]},{"cell":[38,"A.J. Land Co."]},{"cell":[39,"A123 Systems, Inc."]},{"cell":[40,"Accrue Software"]},{"cell":[41,"ACME Paging"]},{"cell":[42,"ACT Teleconferencing Services, Inc."]},{"cell":[43,"Adexa, Inc."]},{"cell":[44,"Adolor Corp."]},{"cell":[45,"Advanced Digital Information Corp"]},{"cell":[46,"Advanced Equities NetXen Investments II, LLC"]},{"cell":[47,"Advanced Fiber Communications"]},{"cell":[48,"Aegis Analytical Corporation"]},{"cell":[49,"Agile Software"]},{"cell":[50,"Agility"]},{"cell":[29,"AIR PRODUCTS"]},{"cell":[51,"Airspan Networks, Inc."]},{"cell":[52,"Aksys"]},{"cell":[53,"Alcatel"]},{"cell":[54,"Alidian"]},{"cell":[55,"Alkermes"]},{"cell":[56,"Allegis"]},{"cell":[57,"Allied Healthcare International"]},{"cell":[58,"Alsius Corporation"]},{"cell":[59,"Alta Analog"]},{"cell":[60,"Amazon"]},{"cell":[17,"AmberBrook Company"]},{"cell":[61,"AmerisourceBergen Corp."]},{"cell":[62,"AMG Advanced Metallurgical Group, NV"]},{"cell":[63,"Ancestry.com, Inc."]},{"cell":[64,"Angiosonics, Inc."]},{"cell":[65,"Anthra Pharmaceuticals, Inc."]},{"cell":[66,"Appian"]},{"cell":[67,"Aradigm Corp"]},{"cell":[68,"Arbinet"]},{"cell":[69,"Arcadian Management Services, Inc."]},{"cell":[70,"Arch Communications"]},{"cell":[71,"Arris Pharmaceutical"]},{"cell":[72,"ART Advanced Recognition Technologies"]},{"cell":[73,"Aruba"]},{"cell":[74,"Asera Inc."]},{"cell":[75,"Aspect Medical Systems"]},{"cell":[76,"Aspreva Pharmaceuticals, Inc."]},{"cell":[77,"Atheros Communications, Inc."]},{"cell":[78,"Audible, Inc"]},{"cell":[79,"Auxilium Pharmaceuticals, Inc."]},{"cell":[80,"Bank of Bermuda"]},{"cell":[81,"Benchmark Electronics"]},{"cell":[82,"Benchmarq"]}]}
    
    // The above response is an array of dictionaries
    NSLog(@"JSon recieved: %@", json);
    
    myData = [json objectForKey:@"rows"];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    static NSString *CellIdentifier = @"directFundNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Get the cell label using it's tag and set it
    NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:indexPath.row];
    NSLog(@"Dict %@", dict);
    // The returned dictionary will be of the format
    /*
     {"cell":[35,"2Wire, Inc."]}
     */
    // The value in the dictionary for the key "cell" is an array. we want the second item in the array as the investor name
    cell.textLabel.text = [[dict objectForKey:@"cell"] objectAtIndex:1];
        return cell;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 120;
    return 60;
}*/


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
    //Presents a modal screen, we have to wire up to go back. For now, giving up on the seque implementation
    //[self performSegueWithIdentifier:@"fundActivityToDetail" sender:self];
    
    directDetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"directDetailsViewController"];
    
    NSDictionary* dict = (NSDictionary*)[myData objectAtIndex:indexPath.row];
    detail.selectedDirectID = [[dict objectForKey:@"cell"] objectAtIndex:0];
    [self.navigationController pushViewController:detail animated:YES];
    
    // INFO: Do this no matter what. When you come back to this view controller again, the row you selected should be de-selected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
