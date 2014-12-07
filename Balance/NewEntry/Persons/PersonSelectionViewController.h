//
//  PersonSelectionViewController.h
//  Balance
//
//  Created by Viktor Kucera on 12/2/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCreateViewController.h"

@class PersonSelectionViewController;
@class Person;
@protocol PersonSelectionVCDelegate<NSObject>
@required
- (void)personSelectionViewController:(PersonSelectionViewController *)personSelectionVC didSelectPerson:(Person *)person;
@end

@interface PersonSelectionViewController : UIViewController <PersonCreateVCDelegate>

@property (nonatomic, weak) id<PersonSelectionVCDelegate> delegatePersonSelectionVC;

@end
