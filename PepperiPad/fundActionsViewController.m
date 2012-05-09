//
//  fundActionsViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fundActionsViewController.h"
#import "fundDetailsViewController.h"
#import "fundInvestorsViewController.h"
#import "capitalDistributionViewController.h"
#import "capitalCallViewController.h"
#import "dealsViewController.h"
#import "pepperAppDelegate.h"
#import "pepperDetailViewController.h"
#import "pepperMasterViewController.h"

@implementation fundActionsViewController

@synthesize selectedFundID = _selectedFundID;

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
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString* ident = @"n/a";
    if(indexPath.row == 0){
        ident = @"Fund Info";
    } else if(indexPath.row == 1){
        ident = @"Investors";
    } else if(indexPath.row == 2){
        ident = @"Capital Calls";
    } else if(indexPath.row == 3){
        ident = @"Capital Distributions";
    } else {
        ident = @"Deals";
    }
    cell.textLabel.text = ident;
    
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
    
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // To make this work, we had to have a navigationController tied to whatever view, and instantiation the Navigation Controller.
    // In this case, we have a fundDetailsViewController, and there is a Navigation controller with identifier findDetailsViewRoot that
    // sits in from of it. Then we instantiate the NavigationRootController and assign it as the second entry in viewControllers array.
    // I think we have to attach the NavigationController to the ViewController becuase when we create a Model-View Based application, the Detail view has a NavigationController attached to it, and also we have the following code in 
    // pepperMasterViewController->viewDidLoad 
    // self.detailViewController = (pepperDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    // So when we assign the detail view as the second object in the viewControllers array, we need it to be the same format as it was to begin with, and the when the MasterViewController refreshes, it will blow up on the above code if there is no navigationController, as there would be no topViewController. 
    // The reason that we need the NavigationController in the first place is becuase of the button on the top which we need in the landscape mode
    //UIViewController* fundDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"fundDetailsViewRoot"]; 
    
    
    
    // Find out what was selected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    
    
    
    UINavigationController* detailsController = nil;
    UIViewController* topController = nil;
    if([text isEqualToString:@"Capital Calls"]){
        detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"capitalCallsViewRoot"]; 
        capitalCallViewController* capCallController = (capitalCallViewController*)detailsController.topViewController;
        capCallController.selectedFundID = self.selectedFundID;
        topController = capCallController;
    } else if([text isEqualToString:@"Capital Distributions"]){
        //capitalDistributionViewController *ccController = [[capitalDistributionViewController alloc] initWithNibName:@"CapitalDistributionViewController" bundle:nil];
        //INFO: the above line with initWithNibName was loading the view, but the outlets (IBOUTBELT table) were not wired up when the view loaded. Had to use the following code
        
        detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"capitalDistributionsViewRoot"]; 
        capitalDistributionViewController* capDistController = (capitalDistributionViewController*)detailsController.topViewController;
        capDistController.selectedFundID = self.selectedFundID;
        topController = capDistController;
    }
    else if([text isEqualToString:@"Investors"]){
        //Initialize the investors view controller and display it.
        detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"fundInvestorsViewRoot"]; 
        // We need to set the selectedFundID
        fundInvestorsViewController* fundInvestorsController = (fundInvestorsViewController*)detailsController.topViewController;
        fundInvestorsController.selectedFundID = self.selectedFundID;
        topController = fundInvestorsController;
    }
    else if([text isEqualToString:@"Deals"]){
        //Initialize the detail view controller and display it.
        /*
        dealsViewController *dealsController = [[dealsViewController alloc] init];
        dealsController.selectedFundID = self.selectedFundID;
        [self.navigationController pushViewController:dealsController animated:YES];
         */
        detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"dealsViewRoot"]; 
        dealsViewController* dealsController = (dealsViewController*)detailsController.topViewController;
        dealsController.selectedFundID = self.selectedFundID;
        topController = dealsController;
    } else {    
    //UINavigationController* fundDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"pepperDetailView"]; 
    
    detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"fundDetailsViewRoot"]; 
    // We need to set the selectedFundID
    fundDetailsViewController* fundController = (fundDetailsViewController*)detailsController.topViewController;
    fundController.selectedFundID = self.selectedFundID;
    topController = fundController;
    }
    if(detailsController != nil){
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:appDelegate.splitViewController.viewControllers];
    
        /*
        //[detailsController.navigationItem setLeftBarButtonItem:appDelegate.masterBarButtonItem animated:NO];
        detailsController.navigationItem.leftBarButtonItem = appDelegate.masterBarButtonItem;
        // replace the passthrough views with current detail navigationbar
        if([appDelegate.masterPopoverController isPopoverVisible]){
            appDelegate.masterPopoverController.passthroughViews = [NSArray arrayWithObject:detailsController.navigationBar];
        }
        */
        
        // This is needed, otherwise the Button at the top will vanish(portrait mode)
        [topController.navigationItem setLeftBarButtonItem:appDelegate.masterBarButtonItem animated:NO];
        
        /*
        // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
        if (appDelegate.masterBarButtonItem != nil) {
            [detailViewController showRootPopoverButtonItem:appDelegate.masterBarButtonItem];
        }*/
        [arr replaceObjectAtIndex:1 withObject:detailsController]; //index 1 corresponds to the detail VC
        appDelegate.splitViewController.viewControllers = arr;
    }
    
    
    //fundDetailsViewController *fundDetailsView = [[fundDetailsViewController alloc] initWithNibName:@"fundDetailsViewRoot" bundle:nil];
    // Update the split view controller's view controllers array.
    /*
    //NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, fundDetailsView, nil];
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:appDelegate.splitViewController.delegate, fundDetailsView, nil];
    appDelegate.splitViewController.viewControllers = viewControllers;
    */    
    /*
    UINavigationController *navigationController = [appDelegate.splitViewController.viewControllers lastObject];
    //navigationController.topViewController = fundDetailsView;
    [navigationController pushViewController:fundDetailsView animated:YES];
    appDelegate.splitViewController.delegate = (id)navigationController.topViewController; 
     [arr replaceObjectAtIndex:1 withObject:navigationController]; //index 1 corresponds to the detail VC
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
