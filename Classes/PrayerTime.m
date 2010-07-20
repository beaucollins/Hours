//
//  PrayerTime.m
//  Hours
//
//  Created by Beau Collins on 7/15/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "PrayerTime.h"


@implementation PrayerTime

@synthesize hour, minute, name, page;

- (id) initWithDefaults:(NSDictionary *)defaults {
	if (self = [super init]) {
		self.name = (NSString *)[defaults objectForKey:@"Name"];
		self.hour = (NSNumber *)[defaults objectForKey:@"Hour"];
		self.minute = (NSNumber *)[defaults objectForKey:@"Minute"];
		self.page = (NSString *)[defaults objectForKey:@"page"];
	}
	
	return self;
}

- (NSDate *)date {
	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	comps.hour = [self.hour intValue];
	comps.minute = [self.minute intValue];
	return [currentCalendar dateFromComponents:comps];
	
}

- (NSURL *)prayerURL {
	
	NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	return [baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Prayers/%@", self.page]];
	
}

- (void)dealloc {
	[hour release];
	[minute release];
	[name release];
	[super dealloc];
}

@end
