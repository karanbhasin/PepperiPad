//
//  pepperDetailViewController.h
//  PepperiPad
//
//  Created by Singh, Jaskaran on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "TUTSimpleScatterPlot.h"

@interface pepperDetailViewController : UIViewController <UISplitViewControllerDelegate>{
    //UIView *hostingView;
    IBOutlet CPTGraphHostingView *_graphHostingView;
    TUTSimpleScatterPlot *_scatterPlot;
}

@property (nonatomic, retain) TUTSimpleScatterPlot *scatterPlot;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIView *hostingView;

@end
