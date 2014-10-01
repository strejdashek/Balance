//
//  RootViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceViewController.h"
#import "ItemsViewController.h"
#import "NewEntryViewController.h"
#import "BalanceViewController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,NewEntryVCDataSource,BalanceVCDelegate>

@end

