//
//  Item.m
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic amount;
@dynamic deadline;
@dynamic name;
@dynamic notes;
@dynamic person;
@dynamic type;

- (Item *)setAmount:(NSInteger)amount deadline:(NSDate *)date name:(NSString *)name notes:(NSString *)notes person:(NSString *)person type:(ItemsType)type
{
    [self setAmount:[NSNumber numberWithInteger:amount]];
    [self setType:[NSNumber numberWithInt:type]];
    [self setDeadline:date];
    [self setName:name];
    [self setNotes:notes];
    [self setPerson:person];
    
    return self;
}

@end
