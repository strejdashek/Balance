//
//  NewEntryViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsViewController.h"

@class NewEntryViewController;

@protocol NewEntryVCDataSource<NSObject>
@required
- (ItemsType)itemType:(NewEntryViewController *)newEntryVC;
@end

@interface NewEntryViewController : UIViewController

//delegates and datasources
@property (nonatomic, weak) id<NewEntryVCDataSource> datasourceNewEntryVC;

@end
