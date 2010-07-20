//
//  TapDelegateWindow.h
//  Hours
//
//  Created by Beau Collins on 7/13/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectWindowDelegate
- (void)userDidTapWebView:(id)tapPoint;
@end

@interface TapDetectWindow : UIWindow {
    UIView *viewToObserve;
    id <TapDetectWindowDelegate> delegate;
}
@property (nonatomic, retain) UIView *viewToObserve;
@property (nonatomic, assign) id <TapDetectWindowDelegate> delegate;
@end