//
//  DatePickerViewController.m
//  Balance
//
//  Created by Viktor Kucera on 10/19/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//action methods
- (IBAction)datePickerChanged:(id)sender;

@end

@implementation DatePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

- (IBAction)datePickerChanged:(id)sender
{
    [self.delegateDatePickerVC datePickerViewController:self didChangeDate:self.datePicker.date];
}

@end
