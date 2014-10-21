//
//  DatePickerViewController.h
//  Balance
//
//  Created by Viktor Kucera on 10/19/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;
@protocol DatePickerVCDelegate<NSObject>
@required
- (void)datePickerViewController:(DatePickerViewController *)datePickerVC didChangeDate:(NSDate *)date;
@end

@interface DatePickerViewController : UIViewController

//delegates
@property (assign, nonatomic) id<DatePickerVCDelegate> delegateDatePickerVC;

@end
