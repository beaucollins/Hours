//
//  PrayerListViewController.h
//  Hours
//
//  Created by Beau Collins on 7/19/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "PrayerViewController.h"


@interface PrayerListViewController : UITableViewController {
	Schedule *schedule;
	PrayerViewController *prayerViewController;
}

@property (nonatomic, retain) Schedule *schedule;

- (void)showPrayerFromNotification:(UILocalNotification *)notification;
- (void)showMostRecentPrayerAnimated:(BOOL)animated;
- (void)showPrayer:(PrayerTime *)prayer animated:(BOOL)animated;
@end
