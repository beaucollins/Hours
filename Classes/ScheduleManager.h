//
//  ScheduleManager.h
//  Hours
//
//  Created by Beau Collins on 7/15/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "PrayerTime.h"

extern NSString *const HoursSelectedSchedulePreference;
extern NSString *const HoursSchedulePreference;
extern NSString *const HoursNotificationPreference;

@interface ScheduleManager : NSObject {
	NSArray *schedules;
	NSUserDefaults *userDefaults;
}

@property (nonatomic, readonly) NSArray *schedules;
@property (nonatomic, retain) Schedule *selectedSchedule;

+ (NSURL *)scheduleURL;

- (void)save;
- (void)scheduleNotifications;

- (NSInteger)selectedScheduleIndex;

- (BOOL)usesNotifications;
- (void)setUsesNotifications:(BOOL)use_notifications;

@end
