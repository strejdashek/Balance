//
//  NewEntryViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumTypes.h"
#import "DatePickerViewController.h"

@class NewEntryViewController;
@class NSManagedObject;
@class Item;

@protocol NewEntryVCDataSource<NSObject>
@required
- (ItemsType)itemType:(NewEntryViewController *)newEntryVC;
- (NewEntryMode)newEntryMode:(NewEntryViewController *)newEntryVC;
@optional
- (NSManagedObject *)itemSelected:(NewEntryViewController *)newEntryVC;
@end

@interface NewEntryViewController : UIViewController <DatePickerVCDelegate>

//delegates and datasources
@property (nonatomic, weak) id<NewEntryVCDataSource> datasourceNewEntryVC;

@end
