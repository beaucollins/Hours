//
//  ScheduleManager.m
//  Hours
//
//  Created by Beau Collins on 7/15/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "ScheduleManager.h"

NSString *const HoursSelectedSchedulePreference = @"selected_schedule_preference";
NSString *const HoursSchedulePreference = @"schedule_preference";
NSString *const HoursNotificationPreference = @"notification_preference";

@interface ScheduleManager()

- (void)deserializeSchedules;

@end


@implementation ScheduleManager

@synthesize schedules;

- (id)init {
	
	if (self = [super init]) {
		
		userDefaults = [[NSUserDefaults standardUserDefaults] retain];
		
		[self deserializeSchedules];
		
	}
	
	return self;
	
}

+ (NSURL *)scheduleURL {
	return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Offices" ofType:@"plist"]];
}

- (void)save {
	//store everything in the proper place for the user settings
	NSMutableDictionary *userSchedules = [NSMutableDictionary dictionaryWithCapacity:[schedules count]];
	
	[schedules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Schedule *schedule = (Schedule *)obj;
		
		[userSchedules setObject:[schedule serializePrayerTimes] forKey:schedule.identifier];
		
	}];
	
	
	[userDefaults setObject:userSchedules forKey:HoursSchedulePreference];
	[userDefaults synchronize];
	
	[self scheduleNotifications];
}

- (void)scheduleNotifications {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	if([self usesNotifications]){
		
		
		
		[self.selectedSchedule enumeratePrayerTimesUsingBlock:^(PrayerTime *prayerTime, NSUInteger idx, BOOL *stop) {
			
			UILocalNotification *notification = [[UILocalNotification alloc] init];
			notification.fireDate = prayerTime.date;
			notification.repeatInterval = NSDayCalendarUnit;
			notification.alertBody = prayerTime.name;
			notification.alertAction = @"Pray";
			notification.timeZone = [NSTimeZone localTimeZone];
			notification.soundName = UILocalNotificationDefaultSoundName;
			notification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[prayerTime.prayerURL absoluteString], @"prayerURL", [NSNumber numberWithInt:idx], @"prayerIndex", nil];
						
			[[UIApplication sharedApplication] scheduleLocalNotification:notification];
			
		}];
	}
	
}

- (void) deserializeSchedules {
	NSArray *schedulesArray = [NSArray arrayWithContentsOfURL:[ScheduleManager scheduleURL]];
	NSDictionary *userSchedules = [userDefaults dictionaryForKey:HoursSchedulePreference];
		
	NSMutableArray *defaultSchedules = [[NSMutableArray alloc] initWithCapacity:[schedulesArray count]];
	[schedulesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *defaultSchedule = (NSDictionary *)obj;
		NSArray *userSchedule = (NSArray *)[userSchedules objectForKey:[defaultSchedule objectForKey:@"identifier"]];
		Schedule *schedule = [Schedule scheduleWithDefaults:defaultSchedule andUserSchedule:userSchedule];
		
		[defaultSchedules addObject:schedule];
		
	}];
	
	schedules = [[NSArray arrayWithArray:defaultSchedules] retain];
	[defaultSchedules release];
}

- (NSInteger)selectedScheduleIndex {
	return [userDefaults integerForKey:HoursSelectedSchedulePreference];
}

- (Schedule *)selectedSchedule {
	
	return (Schedule *)[self.schedules objectAtIndex:[self selectedScheduleIndex]];
	
}

- (void) setSelectedSchedule:(Schedule *)schedule {
	
	[userDefaults setInteger:[self.schedules indexOfObject:schedule] forKey:HoursSelectedSchedulePreference];
	
}

- (BOOL)usesNotifications {
	
	return [userDefaults boolForKey:HoursNotificationPreference];
}

- (void)setUsesNotifications:(BOOL)use_notifications {
	[userDefaults setBool:use_notifications forKey:HoursNotificationPreference];
}


- (void)scheduleNotfications {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	if (![self usesNotifications]) {
		return;
	}
	
	NSArray *schedule = [[self selectedSchedule] prayerTimes];
	[schedule enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PrayerTime *prayerTime = (PrayerTime *)obj;
		
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.soundName = UILocalNotificationDefaultSoundName;
		notification.timeZone = [NSTimeZone localTimeZone];
		notification.fireDate = prayerTime.date;
		notification.repeatInterval = NSDayCalendarUnit;
		notification.alertAction = @"Pray";
		notification.alertBody = prayerTime.name;
		[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	}];
}


- (void)dealloc {
	[schedules release];
	[userDefaults release];
	[super dealloc];
}


@end
