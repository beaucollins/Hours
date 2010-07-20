//
//  Schedule.m
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "Schedule.h"


@implementation Schedule

@synthesize name, identifier, prayerTimes;

+ (Schedule *)scheduleWithDefaults:(NSDictionary *)defaults andUserSchedule:(NSArray *)userSchedule {
	Schedule *schedule = [[Schedule alloc] initWithDefaults:defaults];
	
	[userSchedule enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		PrayerTime *prayerTime = (PrayerTime *) [schedule.prayerTimes objectAtIndex:idx];
		prayerTime.hour = [obj objectForKey:@"hour"];
		prayerTime.minute = [obj objectForKey:@"minute"];
	}];
	
	return [schedule autorelease];
}

- (id)initWithDefaults:(NSDictionary *)defaults {
	if ( self = [super init] ) {
		
		self.name = (NSString *)[defaults objectForKey:@"Label"];
		self.identifier = (NSString *)[defaults objectForKey:@"identifier"];
		
		[self deserializePrayerTimes:(NSArray *)[defaults objectForKey:@"Schedule"]];
		
	}
	
	return self;
}

- (void) deserializePrayerTimes:(NSArray *)prayerTimeData {
	
	NSMutableArray *times = [NSMutableArray arrayWithCapacity:[prayerTimeData count]];
	[prayerTimeData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		PrayerTime *prayerTime = [[PrayerTime alloc] initWithDefaults:(NSDictionary *)obj];
		[times addObject:prayerTime];
		[prayerTime release];
	}];
	
	[prayerTimes = [NSArray arrayWithArray:times] retain];
	
}

- (void)enumeratePrayerTimesUsingBlock:(void (^)(PrayerTime *prayerTime, NSUInteger idx, BOOL *stop))block {
	
	[self.prayerTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		PrayerTime *prayerTime = (PrayerTime *)obj;
		block(prayerTime, idx, stop);
		
	}];
	
}

- (NSArray *)serializePrayerTimes {
	
	NSMutableArray *serializedTimes = [NSMutableArray arrayWithCapacity:[self.prayerTimes count]];
	[self enumeratePrayerTimesUsingBlock:^(PrayerTime *prayerTime, NSUInteger idx, BOOL *stop) {
		[serializedTimes addObject:[NSDictionary dictionaryWithObjectsAndKeys: prayerTime.hour, @"hour", prayerTime.minute, @"minute", nil ]];
	}];
		
	return [NSArray arrayWithArray:serializedTimes];
	
}

- (void)dealloc {
	[name release];
	[identifier release];
	[prayerTimes release];
	[super dealloc];
}

@end
