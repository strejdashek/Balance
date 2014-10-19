//
//  Item.h
//  Balance
//
//  Created by Viktor Kucera on 10/19/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnumTypes.h"

@class Person;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Person *person;

@end
