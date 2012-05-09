//
//  MyGraphViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyGraphViewController.h"
#import "PCPieChart.h"
#import "PCLineChartView.h"
@interface MyGraphViewController()
- (id)pieGraph;
@end
@implementation MyGraphViewController

@synthesize titleLabel;

- (id)init
{
	self = [super init];
	if (self)
	{
		
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		[self.titleLabel setTextColor:[UIColor whiteColor]];
		[self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
		[self.navigationItem setTitleView:self.titleLabel];
		[self.titleLabel release];
		[self.titleLabel setTextAlignment:UITextAlignmentCenter];
		
		UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,60,40)];
		[backButton setBackgroundImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[[backButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
		[backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
		UIBarButtonItem *backButtonitem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		[backButton release];
		[self.navigationItem setLeftBarButtonItem:backButtonitem];
		[backButtonitem release];
		[backButton addTarget:self action:@selector(onBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[backButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self pieGraph];
	}
	return self;
}

- (id)pieGraph
{
	
		[self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
		[self.titleLabel setText:@"Pie Chart"];
		
		
		int height = [self.view bounds].size.width/3*2.; // 220;
		int width = [self.view bounds].size.width; //320;
		PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
		[pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
		[pieChart setDiameter:width/2];
		[pieChart setSameColorLabel:YES];
		
		[self.view addSubview:pieChart];
		[pieChart release];
		
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

- (id)initLineGraph
{
	self = [super init];
	if (self)
	{
		[self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
		[self.titleLabel setText:@"Line Chart"];
		
		PCLineChartView * lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,10,[self.view bounds].size.width-20,[self.view bounds].size.height-20)];
		[lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		lineChartView.minValue = -40;
		lineChartView.maxValue = 100;
		[self.view addSubview:lineChartView];
		[lineChartView release];
		
		NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_linechart_data.json"];
		NSString *jsonString = [NSString stringWithContentsOfFile:sampleFile encoding:NSUTF8StringEncoding error:nil];
		
        NSDictionary *sampleInfo = [jsonString objectFromJSONString];
        
        NSMutableArray *components = [NSMutableArray array];
		for (int i=0; i<[[sampleInfo objectForKey:@"data"] count]; i++)
		{
			NSDictionary *point = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
			PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
			[component setTitle:[point objectForKey:@"title"]];
			[component setPoints:[point objectForKey:@"data"]];
			[component setShouldLabelValues:NO];
			
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
			
			[components addObject:component];
            [component release];
		}
		[lineChartView setComponents:components];
		[lineChartView setXLabels:[sampleInfo objectForKey:@"x_labels"]];
	}
	return self;
}


- (void)onBackButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.titleLabel release];
    [super dealloc];
}


@end