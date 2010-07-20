//
//  ConfigurationViewController.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimePickerSheet.h"
#import "ScheduleManager.h"

@protocol ConfigurationViewControllerDelegate;

@interface ConfigurationViewController : UITableViewController {
	ScheduleManager *scheduleManager;
	id <ConfigurationViewControllerDelegate> delegate;
	TimePickerSheet *timePicker;
	UISwitch *notificationSwitch;
}

@property (nonatomic, retain) ScheduleManager *scheduleManager;
@property (nonatomic, retain) IBOutlet TimePickerSheet *timePicker;
@property (nonatomic, assign) id <ConfigurationViewControllerDelegate> delegate;

- (void)showTimePickerAnimated:(BOOL)animated;
- (void)hideTimePickerAnimated:(BOOL)animated;
- (IBAction) dismissTimePicker:(id)sender;
- (IBAction) updateSelectedTime:(id)sender;
- (IBAction) doneScheduling:(id)sender;
- (void) toggleNotifications:(id)sender forEvent:(UIEvent *)event;

@end

@protocol ConfigurationViewControllerDelegate

- (void)configurationViewControllerDidFinish:(ConfigurationViewController *)configurationController;

@end
