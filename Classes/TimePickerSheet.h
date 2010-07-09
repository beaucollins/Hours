//
//  TimePickerSheet.h
//
//  Created by Beau Collins on 7/9/10.
//  Copyright 2010 K2 Sports. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TimePickerSheet : UIView {
    UIDatePicker *datePicker;
    IBOutlet UIToolbar *toolbar;
}

@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;

@end
