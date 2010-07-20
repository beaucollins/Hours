//
//  Schedule.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrayerTime.h"

@interface Schedule : NSObject {
	NSString *name;
	NSString *identifier;
	NSArray *prayerTimes;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray *prayerTimes;

+ (Schedule *)scheduleWithDefaults:(NSDictionary *)defaults andUserSchedule:(NSArray *)userSchedule;

- (void)enumeratePrayerTimesUsingBlock:(void (^)(PrayerTime *prayerTime, NSUInteger idx, BOOL *stop))block;

- (id)initWithDefaults:(NSDictionary *)defaults;
- (void) deserializePrayerTimes:(NSArray *)prayerTimeData;
- (NSArray *) serializePrayerTimes;
@end
