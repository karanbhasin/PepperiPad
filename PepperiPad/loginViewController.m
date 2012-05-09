//
//  loginViewController.m
//  tabBarTableView
//
//  Created by Singh, Jaskaran on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"
#import "pepperAppDelegate.h"
#import "API.h"
#import "UserDefaults.h"
#import "pepperMasterViewController.h"
#import "pepperDetailViewController.h"

@interface loginViewController()
- (BOOL) credsAreValid;
- (void) authenticateUser;
@end

@implementation loginViewController
@synthesize textLabels = _textLabels;
@synthesize  username = _username;
@synthesize  password = _password;
@synthesize  entityCode = _entityCode;
@synthesize  myView = _myView;

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
    // Update the view with current data before it is displayed
    [super viewWillAppear:animated];
    
    // Scroll the table view to the top before it appears
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
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

- (void) loadView {
    // 768 * 1024 size dimentions iPad
    //320 * 480 iPhone, 640 * 960 Retina
	
	// Create a temp view that will fill the screen, we will use this view to add the subviews like the logo and table
	self.myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)]; //initilize the view   
	[self.myView setBackgroundColor:[UIColor clearColor]];
	
	//set view property of controller to the newly created view
	self.view = self.myView;                            
	
	
	// Create the FT Logo and add it to the view
	UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 500, 300)];
	myImageView.image = [UIImage imageNamed:@"pepper.png"];
	[self.view addSubview:myImageView];
	
	// Create the table that will supply the credentials for the user
	UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, 768, 600) style:UITableViewStyleGrouped];
	tableView.editing = NO;  //This allows user of program to add or remove elements from list
	tableView.dataSource = self;
	tableView.delegate = self; //make the current object the event handler for view
	tableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tableView];    
    
	// Assign the label fields when the view loads
    NSArray *localTextLabels = [[NSArray alloc] initWithObjects:@"Username", @"Password", @"Entity code", nil];
	self.textLabels = localTextLabels;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // for username, password and entity code
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoginCellIdentifier = @"LoginCellIdentifier";
	int textFieldHeight = 200;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginCellIdentifier];
	
	if (cell == nil) {
        CGRect CellFrame = CGRectMake(0, 0, 768, 300);
		//cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoginCellIdentifier];
		cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:LoginCellIdentifier];
		// Create the text box for the cell
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 768, 200)];
		textField.clearsOnBeginEditing = NO;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.font = [UIFont systemFontOfSize:16];
		textField.textColor = [UIColor colorWithRed:.20 green:.31 blue:.52 alpha:1];
		[textField setClearButtonMode:UITextFieldViewModeWhileEditing];
		
		// Set the delegate for the text field
		[textField setDelegate:self];
		
		textField.returnKeyType = UIReturnKeyGo;
		
		[cell.contentView addSubview:textField];
		
		// If the index path is 0, set the textfield to be the first responder
		if ([indexPath row] == 0) {
			[textField becomeFirstResponder];
		}
	}
	
    // set the faded text in the text fields so the user knows what to type in. this eleminates
    // the need to have a label, next to the text box
	NSUInteger row = [indexPath row];
	UITextField *textField = nil;
	for (UIView *oneView in cell.contentView.subviews) {
		if ([oneView isMemberOfClass:[UITextField class]]) {
			textField = (UITextField *)oneView;
		}
	}
	textField.placeholder = [self.textLabels objectAtIndex:row];
	
	// If the row is at index path of 1, we need to make it a password type textfield
	if (row == 1) {
		textField.secureTextEntry = YES;
	}
    
	textField.tag = row;
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

#pragma mark -
#pragma mark Text Field Methods
- (void) saveTextFieldValue: (UITextField *)textField {
	
	// find out which variable to save value to
	switch (textField.tag) {
		case 0: // The username
			self.username = textField.text;
			break;
		case 1: // The password
			self.password = textField.text;
			break;
		case 2:
			self.entityCode = textField.text;
			break;
			
	}
}

// Fires off when the user hits the "return" button on the keyboard which is mapped to the word "Go" right now
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	// Save the value first
	[self saveTextFieldValue:theTextField];
	
	// Find out if all text fields are filled out
	if (![self credsAreValid]) {
		
		// The request was not successful, alert the user
		NSString *msg = [NSString stringWithFormat:@"Information is missing."];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Fail" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	else {
		// Add the loading view to signafy that something is happening
        pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate showActivityViewer:@"Loading..."];
		[theTextField resignFirstResponder];
		
		// Call the authenticate user method
		[self authenticateUser];
	}
	return YES;
}

-(void)textFieldDidEndEditing: (UITextField *)textField {
	
	[self saveTextFieldValue:textField];
	
}


- (BOOL) credsAreValid {
    
	if (![self username] || [self username].length <= 0) {
		return NO;
	}
	
	if (![self password] || [self password].length <= 0) {
		return NO;
	}
	
	if (![self entityCode] || [self entityCode].length <= 0) {
		return NO;
	}
	
	return YES;
}

- (void) authenticateUser { 
    
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[UserDefaults sharedInstance] setEntityCode:self.entityCode];
	[[UserDefaults sharedInstance] setPassword:self.password];
	[[UserDefaults sharedInstance] setUserName:self.username];
	
    API* api = [[API alloc] init];     
    BOOL loginSuccess = [api logInUser:self.username withPassword:self.password forEntity:self.entityCode];
    NSString* lastRedirect = api.LastRedirectLocation;
    loginSuccess = api.IsAuthenticated;
    if(loginSuccess){
        appDelegate.api = api;
        UISplitViewController *splitViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"splitViewController"];
        // NOTE: Very Important: We have to add the following code, otherwise the master view ( and the button on top) will never show
        // This code was in didFinishLaunchingWithOptions, but was taken out to facilitate the use of login screen. Use this code to set the 
        // proper delegate
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;  
                 
        /*
        pepperMasterViewController *root = [[pepperMasterViewController alloc] init];
        pepperDetailViewController *detail = [[pepperDetailViewController alloc] init]; 
        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:root];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detail];
        splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav, detailNav, nil];
        splitViewController.delegate = detail;        
        */
        
        appDelegate.splitViewController = splitViewController;
        
        // Show the tab controller
        [appDelegate openSplitViewController];
        // hide the login controller 
        [self.view removeFromSuperview];
        [appDelegate hideActivityViewer];
    } else {
        [appDelegate hideActivityViewer];
        // The request was not successful, alert the user
        NSString *msg = [NSString stringWithString:@"Authentication Failed"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to authenticate user." message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


@end
