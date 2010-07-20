//
//  PrayerViewController.h
//  Hours
//
//  Created by Beau Collins on 7/13/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectWindow.h"
#import "PrayerTime.h"

@protocol PrayerViewControllerDelegate;


@interface PrayerViewController : UIViewController <TapDetectWindowDelegate> {
	UIWebView *prayerView;
	PrayerTime *prayerTime;
}

@property (nonatomic, retain) PrayerTime *prayerTime;

@end
