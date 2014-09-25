//
//  ItemsViewController.h
//  Balance
//
//  Created by Viktor Kucera on 9/24/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UIViewController

typedef enum ItemsType : NSInteger ItemsType;
enum ItemsType : NSInteger
{
    AssetType,
    LiabilityType
};

//public property
@property (assign, nonatomic) ItemsType itemsType;

@end
