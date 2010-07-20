//
//  ConfigurationViewController.m
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "ConfigureTimeCell.h"

#define SECTIONS					3
#define NOTIFICATION_SECTION		1
#define SELECT_SCHEDULE_SECTION		0
#define TIME_SECTION				2

@implementation ConfigurationViewController

@synthesize scheduleManager, timePicker, delegate;

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


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	self.title = @"Schedule";
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneScheduling:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	notificationSwitch.on = [scheduleManager usesNotifications];
	
	[notificationSwitch addTarget:self action:@selector(toggleNotifications:forEvent:) forControlEvents:UIControlEventValueChanged];

    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
											  

/*
 - (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}
 */


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


- (void)viewWillDisappear:(BOOL)animated {
	[self hideTimePickerAnimated:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}

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


- (IBAction) doneScheduling:(id)sender {
	// send this to a delegate
	[self.delegate configurationViewControllerDidFinish:self];
	[scheduleManager save];
}


- (void) toggleNotifications:(id)sender forEvent:(UIEvent *)event {
	[scheduleManager setUsesNotifications:notificationSwitch.on];
}

- (IBAction) updateSelectedTime:(id)sender {
	Schedule *schedule = [scheduleManager selectedSchedule];
	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [currentCalendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.timePicker.datePicker.date];
	
	PrayerTime *prayerTime = [schedule.prayerTimes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
	prayerTime.hour = [NSNumber numberWithInt:comps.hour];
	prayerTime.minute = [NSNumber numberWithInt:comps.minute];
		
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TIME_SECTION] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark TimePickerSheet display

- (void)showTimePickerAnimated:(BOOL)animated {
	if ([self.timePicker superview] == nil) {
		[self.view.superview addSubview: self.timePicker];

		CGRect containingFrame = self.view.superview.frame;
		CGRect endFrame = CGRectMake(0, containingFrame.size.height - self.timePicker.frame.size.height, containingFrame.size.width, self.timePicker.frame.size.height);
		CGRect contentFrame = self.tableView.frame;
		contentFrame.size.height -= endFrame.size.height;
		if ( animated ) {
			CGRect startFrame = CGRectMake(0, containingFrame.size.height, containingFrame.size.width, self.timePicker.frame.size.height);
			self.timePicker.frame = startFrame;
			[UIView beginAnimations:nil context:NULL];
			self.tableView.frame = contentFrame;
			self.timePicker.frame = endFrame;
			[self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionNone animated:animated];
			[UIView commitAnimations];
		
		} else {
			self.tableView.frame = contentFrame;
			[self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionNone animated:animated];
			self.timePicker.frame = endFrame;
		}
		
	}
}

- (void)hideTimePickerAnimated:(BOOL)animated {
	if ( self.timePicker.superview != nil) {
		
		CGRect contentFrame = self.tableView.frame;
		contentFrame.size.height += self.timePicker.frame.size.height;
		CGRect endFrame = self.timePicker.frame;
		endFrame.origin.y = self.view.superview.frame.size.height;
		if ( animated ) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
			[UIView setAnimationDelegate:self.timePicker];
			self.tableView.frame = contentFrame;
			self.timePicker.frame = endFrame;
			[self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionNone animated:animated];
			[UIView commitAnimations];
		} else {
			self.tableView.frame = contentFrame;
			[self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionNone animated:animated];
			[self.timePicker removeFromSuperview];
		}
		

	}
}

- (IBAction) dismissTimePicker:(id)sender {

	[self hideTimePickerAnimated:YES];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == SELECT_SCHEDULE_SECTION) {
		return [scheduleManager.schedules count];
	}else if (section == TIME_SECTION) {
		return [scheduleManager.selectedSchedule.prayerTimes count];
	}else {
		return 1;
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ScheduleCellIdentifier = @"Cell";
	static NSString *TimeCellIdentifier = @"Time";
    static NSString *NotificationCellIdentifier = @"Notification";
	
    // Configure the cell...
	if ( indexPath.section == SELECT_SCHEDULE_SECTION ) {
		// checkbox
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ScheduleCellIdentifier] autorelease];
		}
		Schedule *schedule = (Schedule *)[scheduleManager.schedules objectAtIndex:indexPath.row];
		
		cell.textLabel.text = schedule.name;
		if ( schedule == scheduleManager.selectedSchedule ) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;

		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;

		}

		return cell;
	} else if ( indexPath.section == TIME_SECTION ) {
		// Time picker
		ConfigureTimeCell *cell = (ConfigureTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
		if (cell == nil) {
			cell = [[[ConfigureTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TimeCellIdentifier] autorelease];
		}
		
		
		PrayerTime *prayerTime = (PrayerTime *)[scheduleManager.selectedSchedule.prayerTimes objectAtIndex:indexPath.row];

		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = prayerTime.name;
		[cell setTimeWithHour:prayerTime.hour andMinute:prayerTime.minute];
		return cell;
		
	} else {
		// notification section
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NotificationCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NotificationCellIdentifier] autorelease];
		}
		cell.textLabel.text = @"Notifications";
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryView = notificationSwitch;
		return cell;
	}


    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ( section ==  SELECT_SCHEDULE_SECTION ) {
		return @"Schedule";
	}else if ( section == TIME_SECTION ) {
		return nil;
	}
	return nil;
}
*/


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if ( section == TIME_SECTION ) {
		NSTimeZone *tz = [NSTimeZone localTimeZone];
		return [NSString stringWithFormat:@"All times displayed in %@", [tz localizedName:NSTimeZoneNameStyleDaylightSaving locale:[NSLocale currentLocale]]];
	}else {
		return nil;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ( indexPath.section == SELECT_SCHEDULE_SECTION ) {
		
		[self hideTimePickerAnimated:YES];
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		Schedule *schedule = (Schedule *)[scheduleManager.schedules objectAtIndex:indexPath.row];
		if ( schedule == [scheduleManager selectedSchedule]) {
			return;
		}
		
		UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:
									[NSIndexPath indexPathForRow:[scheduleManager selectedScheduleIndex] inSection:indexPath.section]];

		[scheduleManager setSelectedSchedule:schedule];
		
		UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TIME_SECTION] withRowAnimation:UITableViewRowAnimationFade];
		
	} else if ( indexPath.section == TIME_SECTION ) {
		// display the time picker?
		PrayerTime *prayerTime = [scheduleManager.selectedSchedule.prayerTimes objectAtIndex:indexPath.row];
		[self showTimePickerAnimated:YES];
		[self.timePicker.datePicker setDate:prayerTime.date animated:YES];
		
	}

	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[notificationSwitch removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
	notificationSwitch = nil;
}


- (void)dealloc {
	[scheduleManager release];
	[notificationSwitch release];
	[timePicker release];
    [super dealloc];
}


@end

