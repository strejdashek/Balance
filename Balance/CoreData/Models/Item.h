//
//  Item.h
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnumTypes.h"

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSDate *deadline;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *person;
@property (nonatomic, retain) NSNumber *type;

- (Item *)setAmount:(NSInteger)amount deadline:(NSDate *)date name:(NSString *)name notes:(NSString *)notes person:(NSString *)person type:(ItemsType)type;

- (Item *)mapToItem:(NSManagedObject *)managedObject;

@end
