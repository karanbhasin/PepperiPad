//
//  TUTViewController.m
//  PepperiPad
//
//  Created by Singh, Jaskaran on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TUTViewController.h"

@implementation TUTViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
