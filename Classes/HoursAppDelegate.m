//
//  HoursAppDelegate.m
//  Hours
//
//  Created by Beau Collins on 7/9/10.
//  Copyright K2 Sports 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HoursAppDelegate.h"

@implementation HoursAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Local Notification in Foreground
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	NSLog(@"Application States: %@", [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:UIApplicationStateActive], @"UIApplicationStateActive"
									  , [NSNumber numberWithInt:UIApplicationStateInactive], @"UIApplicationStateInactive"
									  , [NSNumber numberWithInt:UIApplicationStateBackground], @"UIApplicationStateBackground"
									  , nil]);
	NSLog(@"Foreground received LocalNotification %d %@", application.applicationState, notification);
	UIApplicationStateActive;
	if ( application.applicationState == UIApplicationStateActive ) {
		//some sort of animation or alert or something?
	} else {
		window.rootViewController = prayerNavController;
		[prayerListController showPrayerFromNotification:notification];
		
	}

}

- (IBAction)showSettingsController:(id)sender {
	//transition to the configuration view for now
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ( [defaults integerForKey:@"first_run_flag"] == 1 ) {
		
		[defaults setInteger:0 forKey:@"first_run_flag"];
		
		[defaults synchronize];
		[self showSettingsController:nil];
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
	window.rootViewController = configNavController;
	[UIView commitAnimations];
	 

}

#pragma mark -
#pragma mark ConfigurationViewControllerDelegate methods

- (void)configurationViewControllerDidFinish:(ConfigurationViewController *)configurationController {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	prayerListController.schedule = [scheduleManager selectedSchedule];
	window.rootViewController = prayerNavController;
	[UIView commitAnimations];
	
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
	[defaults registerDefaults: [NSDictionary
								 dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES], HoursNotificationPreference
							  , [NSNumber numberWithInt:0], HoursSelectedSchedulePreference
							  , [NSDictionary dictionary], HoursSchedulePreference
							  , [NSNumber numberWithInt:1], @"first_run_flag"
							  , nil]];

	scheduleManager = [[ScheduleManager alloc] init];
	
	
	configController = [[ConfigurationViewController alloc] initWithNibName:@"ConfigurationViewController" bundle:nil];
	configController.scheduleManager = scheduleManager;
	configController.delegate = self;
	configNavController = [[UINavigationController alloc] initWithRootViewController:configController];
	
	prayerController = [[PrayerViewController alloc] initWithNibName:nil bundle:nil];

	prayerListController = [[PrayerListViewController alloc] initWithNibName:nil bundle:nil];
	prayerListController.schedule = [scheduleManager selectedSchedule];
	
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsController:)];
	
	prayerListController.navigationItem.leftBarButtonItem = settingsButton;
	[settingsButton release];
	prayerNavController = [[UINavigationController alloc] initWithRootViewController:prayerListController];
	
	window.rootViewController = prayerNavController;
	
	
	if ( notification ) {
		[prayerListController showPrayerFromNotification:notification];
	}
	
	window.backgroundColor = [UIColor blackColor];
	[prayerListController showMostRecentPrayerAnimated:NO];
	
    [window makeKeyAndVisible];
	
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"Did enter Background");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"Will Enter Foreground");
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"Application did become active");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[configController release];
	[configNavController release];
	[prayerController release];
	[prayerNavController release];
	[prayerListController release];
    [window release];
	[scheduleManager release];
    [super dealloc];
}


@end
