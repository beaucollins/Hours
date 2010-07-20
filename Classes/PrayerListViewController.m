//
//  PrayerListViewController.m
//  Hours
//
//  Created by Beau Collins on 7/19/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "PrayerListViewController.h"

@implementation PrayerListViewController

@synthesize schedule;


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


- (void)showPrayerFromNotification:(UILocalNotification *)notification {
	//NSURL *prayerURL = [NSURL URLWithString:[notification.userInfo objectForKey:@"prayerURL"]];
	
	NSInteger idx = [[notification.userInfo objectForKey:@"prayerIndex"] intValue];
	
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	PrayerTime *prayer = (PrayerTime *)[self.schedule.prayerTimes objectAtIndex:idx];
	
	prayerViewController.prayerTime = prayer;
	self.navigationController.viewControllers = [NSArray arrayWithObjects:self, prayerViewController, nil];
	
}

- (void)showMostRecentPrayerAnimated:(BOOL)animated {
	NSDate *now = [NSDate date];
	__block PrayerTime *mostRecentPrayer;
	
	[self.schedule enumeratePrayerTimesUsingBlock:^(PrayerTime *prayerTime, NSUInteger idx, BOOL *stop) {
		if ( [now compare:prayerTime.date] == NSOrderedAscending ) {
			*stop = YES;
		}else {
			mostRecentPrayer = prayerTime;
		}
	}];
	
	if ( mostRecentPrayer == nil ) {
		mostRecentPrayer = (PrayerTime *)[self.schedule.prayerTimes objectAtIndex:0];
	}
	
	[self showPrayer:mostRecentPrayer animated:animated];
}

- (void)showPrayer:(PrayerTime *)prayer animated:(BOOL)animated {
	prayerViewController.prayerTime = prayer;
	[self.navigationController pushViewController:prayerViewController animated:animated];

}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	prayerViewController = [[PrayerViewController alloc] initWithNibName:nil bundle:nil];
	[super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if ( [[NSUserDefaults standardUserDefaults] integerForKey:@"first_run_flag"] == 1 ) {
		
		UIBarButtonItem *settingsButton = self.navigationItem.leftBarButtonItem;
		[settingsButton.target performSelector:settingsButton.action];
		
	}
	
}


/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.schedule.prayerTimes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	PrayerTime *prayerTime = (PrayerTime *)[self.schedule.prayerTimes objectAtIndex:indexPath.row];
    // Configure the cell...
	cell.textLabel.text = prayerTime.name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	PrayerTime *prayerTime = (PrayerTime *)[self.schedule.prayerTimes objectAtIndex:indexPath.row];
	[self showPrayer:prayerTime animated:YES];
	
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}
*/

- (void)setSchedule:(Schedule *)new_schedule {
	if ( schedule != new_schedule ) {
		[schedule release];
		schedule = [new_schedule retain];
	}
	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[schedule release];
	[prayerViewController release];
    [super dealloc];
}


@end

