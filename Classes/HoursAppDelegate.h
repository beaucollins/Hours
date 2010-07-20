//
//  HoursAppDelegate.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright K2 Sports 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurationViewController.h"
#import "PrayerViewController.h"
#import "PrayerListViewController.h"
#import "ScheduleManager.h"

@interface HoursAppDelegate : NSObject <UIApplicationDelegate, ConfigurationViewControllerDelegate> {
    UIWindow *window;
	ConfigurationViewController *configController;
	PrayerViewController *prayerController;
	ScheduleManager *scheduleManager;
	PrayerListViewController *prayerListController;
	UINavigationController *configNavController;
	UINavigationController *prayerNavController;
}

- (IBAction)showSettingsController:(id)sender;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

