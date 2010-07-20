//
//  PrayerTime.h
//  Hours
//
//  Created by Beau Collins on 7/15/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrayerTime : NSObject {
	NSNumber *hour;
	NSNumber *minute;
	NSString *page;
	NSString *identfier;
}

@property (nonatomic, retain) NSNumber *hour;
@property (nonatomic, retain) NSNumber *minute;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *page;
@property (nonatomic, readonly) NSDate *date;

- (id)initWithDefaults:(NSDictionary *)defaults;
- (NSURL *)prayerURL;

@end
