//
//  pepperDetailViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pepperDetailViewController.h"
#import "PCPieChart.h"
#import "MyGraphViewController.h"
#import "pepperAppDelegate.h"
#import "Util.h"
//#import "PlotItem.h"
//#import "VerticalBarChart.h"
//#import "CandlestickPlot.h"

@interface pepperDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)drawGraph;
@end

@implementation pepperDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize hostingView;
@synthesize scatterPlot = _scatterPlot;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    /*
    MyGraphViewController* graphController = [[self.storyboard instantiateViewControllerWithIdentifier:@"myGraph"] init]; 
    [self addChildViewController:graphController];
     */
    
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
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
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
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
    [pieChart setComponents:components];
    
}

- (void)drawGraph
{
    [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    //[self.titleLabel setText:@"Pie Chart"];
    
    
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
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
    
    NSMutableArray *components = [NSMutableArray array];
    
    
    // Get the data for all the funds
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSData* responseData = [appDelegate.api GetFundsWithDetails:0];
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
        if([[dict objectForKey:@"cell"] objectAtIndex:5] != (id)[NSNull null]){
            float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:5] floatValue];
            NSNumber *num = [NSNumber numberWithFloat:totalCommitment];
            [array addObject:num];
        }
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
                if([[dict objectForKey:@"cell"] objectAtIndex:5] != (id)[NSNull null]){
                float totalCommitment = [[[dict objectForKey:@"cell"] objectAtIndex:5] floatValue];
                if(totalCommitment == [num floatValue]){
                    NSString* fundName = [[dict objectForKey:@"cell"] objectAtIndex:1];
                    [sortedFundNames addObject:fundName];
                    [copyDict removeObject:dict];
                    break;
                }
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

    [pieChart setComponents:components];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
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
    /*
    NSMutableArray *data = [NSMutableArray array];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-10, 100)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-8, 50)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-6, 20)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-4, 10)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(-2, 5)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(2, 4)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(4, 16)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(6, 36)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(8, 64)]];
    [data addObject:[NSValue valueWithCGPoint:CGPointMake(10, 100)]];
    
    self.scatterPlot = [[TUTSimpleScatterPlot alloc] initWithHostingView:_graphHostingView andData:data];
    [self.scatterPlot initialisePlot];
     */
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

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    pepperAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.masterBarButtonItem = barButtonItem;
    appDelegate.masterPopoverController = popoverController; 
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
