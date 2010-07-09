//
//  ConfigureTimeCell.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfigureTimeCell : UITableViewCell {
	NSNumber *hours;
	NSNumber *minute;
}

@property (nonatomic, retain) NSNumber *hour;
@property (nonatomic, retain) NSNumber *minute;

- (void)setTimeWithHour:(NSNumber *)newHour andMinute:(NSNumber *)newMinute;

@end
