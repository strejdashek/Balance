//
//  BalanceViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "ItemsViewController.h"

//protocols
@class BalanceViewController;
@protocol BalanceVCDelegate<NSObject>
@required
- (void)balanceViewController:(BalanceViewController *)balanceVC didSelectTotalItemType:(ItemsType)itemType;
@end

@interface BalanceViewController : UIViewController <ItemsVCDelegate>

//delegates
@property (assign, nonatomic) id<BalanceVCDelegate> delegateBalanceVC;

@end
