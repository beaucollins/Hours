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

@synthesize selectedOffice, timePicker;

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
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	//load the schedule options
	NSURL *officesURL = [[NSBundle mainBundle] URLForResource:@"Offices" withExtension:@"plist"];
	offices = [[NSArray arrayWithContentsOfURL:officesURL] retain];
	
	self.selectedOffice = (NSDictionary *)[offices objectAtIndex:0];
	notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	notificationSwitch.on = [defaults boolForKey:@"notification_preference"];
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

- (NSDate *)dateForSchedule:(NSDictionary *)schedule {
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	comps.hour = [[schedule objectForKey:@"Hour"] intValue];
	comps.minute = [[schedule objectForKey:@"Minute"] intValue];
	return [currentCalendar dateFromComponents:comps];
}


- (NSArray *)scheduleForSelectedOffice {
	return (NSArray *)[self.selectedOffice objectForKey:@"Schedule"];
}

- (void) toggleNotifications:(id)sender forEvent:(UIEvent *)event {
	NSLog(@"Toggle notifications %@", event);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:notificationSwitch.on forKey:@"notification_preference"];
	
	if ( notificationSwitch.on ) {
		//re-schedule
	}else {
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}

}

#pragma mark -
#pragma mark TimePickerSheet display

- (void)showTimePickerAnimated:(BOOL)animated {
	if ([self.timePicker superview] == nil) {
		NSLog(@"Stuff: %@", self.view.superview);
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
	NSLog(@"%@", [self.tableView indexPathForSelectedRow]);
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
		return [offices count];
	}else if (section == TIME_SECTION) {
		return [[self scheduleForSelectedOffice] count];
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
		
		cell.textLabel.text = [[offices objectAtIndex:indexPath.row] objectForKey:@"Label"];
		if ( indexPath.row == [offices indexOfObject:self.selectedOffice] ) {
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
		
		
		NSDictionary *timeDetails = [[self scheduleForSelectedOffice] objectAtIndex:indexPath.row];
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = [NSString stringWithFormat:@"Prayer %d", indexPath.row + 1];
		[cell setTimeWithHour:[timeDetails objectForKey:@"Hour"] andMinute:[timeDetails objectForKey:@"Minute"]];
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ( section ==  SELECT_SCHEDULE_SECTION ) {
		return @"Schedule";
	}else if ( section == TIME_SECTION ) {
		return nil;
	}
	return nil;
}


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
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];

		if (indexPath.row == [offices indexOfObject:self.selectedOffice]) {
			return;
		}
		
		
		NSDictionary *oldOffice = self.selectedOffice;
		self.selectedOffice = (NSDictionary *)[offices objectAtIndex:indexPath.row];
		
		UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:
									[NSIndexPath indexPathForRow:[offices indexOfObject:oldOffice] inSection:indexPath.section]];
		UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TIME_SECTION] withRowAnimation:UITableViewRowAnimationFade];
		
		
	} else if ( indexPath.section == TIME_SECTION ) {
		// display the time picker?
		NSDate *selectedDate = [self dateForSchedule:[[self scheduleForSelectedOffice] objectAtIndex:indexPath.row]];
		[self showTimePickerAnimated:YES];
		[self.timePicker.datePicker setDate:selectedDate animated:YES];
		
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[notificationSwitch removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
	notificationSwitch = nil;
}


- (void)dealloc {
	[selectedOffice release];
	[offices release];
	[notificationSwitch release];
    [super dealloc];
}


@end

