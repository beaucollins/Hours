//
//  TapDelegateWindow.m
//  Hours
//
//  Created by Beau Collins on 7/13/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import "TapDetectWindow.h"


@implementation TapDetectWindow

@synthesize viewToObserve;
@synthesize delegate;
- (id)initWithViewToObserve:(UIView *)view andDelegate:(id)viewDelegate {
    if(self == [super init]) {
        self.viewToObserve = view;
        self.delegate = viewDelegate;
    }
    return self;
}
- (void)dealloc {
    [viewToObserve release];
    [super dealloc];
}
- (void)forwardTap:(id)touch {
    [delegate userDidTapWebView:touch];
}
- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (viewToObserve == nil || delegate == nil)
        return;
    NSSet *touches = [event allTouches];
    if (touches.count != 1)
        return;
    UITouch *touch = touches.anyObject;
    if (touch.phase != UITouchPhaseEnded)
        return;
    if ([touch.view isDescendantOfView:viewToObserve] == NO)
        return;
    CGPoint tapPoint = [touch locationInView:viewToObserve];
    NSArray *pointArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", tapPoint.x],
						   [NSString stringWithFormat:@"%f", tapPoint.y], nil];
    if (touch.tapCount == 1) {
        [self performSelector:@selector(forwardTap:) withObject:pointArray afterDelay:0.5];
	} else if (touch.tapCount > 1) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forwardTap:) object:pointArray];
    }
}

@end
