//
//  ConfigureTimeCell.m
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "ConfigureTimeCell.h"


@implementation ConfigureTimeCell
@synthesize hour;
@synthesize minute;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTimeWithHour:(NSNumber *)newHour andMinute:(NSNumber *)newMinute {
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]];
	
	comps.hour = [newHour intValue];
	comps.minute = [newMinute intValue];
	
	NSDate *date = [currentCalendar dateFromComponents:comps];
	
	self.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
	
}

- (void)dealloc {
	[hour release];
	[minute release];
    [super dealloc];
}


@end
