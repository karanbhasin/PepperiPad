1. Copy the CorePlotHeaders to your Xcode project

2. Copy libCorePlotCocoaTouch.a to your Xcode project

3. Add to Other Linker Flags in your target build settings:

-ObjC -all_load

4. Add the QuartzCore framework to the project.
In the project navigator, select your project
Select your target
Select the 'Build Phases' tab
Open 'Link Binaries With Libraries' expander
Click the '+' button
Select your framework

-- When building, you may get errors in CorePlot regarding autorelease and release
The Coreplot takes into consideration dereferencing the pointers. If you have set the Automatic Reference Counting (ARC) set to true, you may get errors like these

CPTXYAxis *y2 = [[[CPTXYAxis alloc] init] autorelease];
autorelease is unavailable. not available in automatic reference counting mode
ARC forbids explicit message send of 'release'

[scatterPlotView release];
elease is unavailable. not available in automatic reference counting mode
ARC forbids explicit message send of 'release'

Build Settings->Apple LLVM Compiler 3.0->Objective-C Automatic Reference Counting
Set this to false to get over the compiler errors. 

CAUTION: If you set ARC to false, then you have to make sure that your code other than CodePlot is releasing the memory. So you have 2 options
1) Set ARC to false so CodePlot is happy, and make sure the rest of you code takes care of releasing the memory
2) Set ARC to true, and change CodePlot and take out the autorelease and release code
	