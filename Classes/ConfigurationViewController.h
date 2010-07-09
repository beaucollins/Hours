//
//  ConfigurationViewController.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerSheet.h"

@interface ConfigurationViewController : UITableViewController {
	NSArray *offices;
	NSDictionary *selectedOffice;
	TimePickerSheet *timePicker;
	UISwitch *notificationSwitch;
}

@property (nonatomic, retain) NSDictionary *selectedOffice;
@property (nonatomic, retain) IBOutlet TimePickerSheet *timePicker;

- (NSArray *)scheduleForSelectedOffice;
- (void)showTimePickerAnimated:(BOOL)animated;
- (void)hideTimePickerAnimated:(BOOL)animated;
- (IBAction) dismissTimePicker:(id)sender;
- (void) toggleNotifications:(id)sender forEvent:(UIEvent *)event;
@end
