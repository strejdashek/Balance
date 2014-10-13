//
//  ItemsViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/24/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEntryViewController.h"
#import "EnumTypes.h"

@class ItemsViewController;
@protocol ItemsVCDelegate<NSObject>
@required
- (void)itemsViewController:(ItemsViewController *)itemsVC didRemoveItemWithAmount:(NSNumber *)amount;
@end

@interface ItemsViewController : UIViewController <NewEntryVCDataSource>

//public properties
@property (assign, nonatomic) ItemsType itemsType;

//delegates
@property (assign, nonatomic) id<ItemsVCDelegate> delegateItemsVC;

@end
