    //
//  PrayerViewController.m
//  Hours
//
//  Created by Beau Collins on 7/13/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "PrayerViewController.h"

@implementation PrayerViewController

@synthesize prayerTime;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = @"Prayer";
    }
    return self;
}

- (void)userDidTapWebView:(id)tapPoint {
	if (self.navigationController.navigationBarHidden) {
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	}else {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	}

}

- (void)viewWillAppear:(BOOL)animated {
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	[prayerView loadRequest:[NSURLRequest requestWithURL:[self.prayerTime prayerURL]]];

	TapDetectWindow *window = (TapDetectWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	window.delegate  = self;
	window.viewToObserve = prayerView;
	
	[super viewWillAppear:animated];
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	TapDetectWindow *window = (TapDetectWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	window.delegate  = nil;
	window.viewToObserve = nil;
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	prayerView = [[UIWebView alloc] init];
	prayerView.scalesPageToFit = NO;
	self.view = prayerView;

}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
}
*/

/*
- (void)viewDidUnload {
	
	
    [super viewDidLoad];
	
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[prayerView release];
    [super dealloc];
}


@end
