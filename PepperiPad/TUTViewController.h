//
//  TUTViewController.h
//  PepperiPad
//
//  Created by Singh, Jaskaran on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"
#import "TUTSimpleScatterPlot.h"

@interface TUTViewController : UIViewController {
    IBOutlet CPTGraphHostingView *_graphHostingView;
    TUTSimpleScatterPlot *_scatterPlot;
}

@property (nonatomic, retain) TUTSimpleScatterPlot *scatterPlot;

@end
