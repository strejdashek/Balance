//
//  Common.h
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "ItemsViewController.h"
#import "Item.h"

@interface Common : NSObject

+ (NSURL *)documentsDir;

+ (void)seedTestData;

@end
