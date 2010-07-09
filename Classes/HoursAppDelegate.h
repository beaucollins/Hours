//
//  HoursAppDelegate.h
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright K2 Sports 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurationViewController.h"

@interface HoursAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ConfigurationViewController *configController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

