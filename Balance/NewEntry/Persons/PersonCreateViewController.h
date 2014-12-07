//
//  PersonCreateViewController.h
//  Balance
//
//  Created by Viktor Kucera on 12/4/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonCreateViewController;
@class Person;
@protocol PersonCreateVCDelegate<NSObject>
@required
- (void)personCreateViewController:(PersonCreateViewController *)personCreateVC didCreatePerson:(Person *)person;
@end

@interface PersonCreateViewController : UIViewController

//delegates
@property (nonatomic, weak) id<PersonCreateVCDelegate> delegatePersonCreateVC;

@end
