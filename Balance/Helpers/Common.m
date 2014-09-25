//
//  Common.m
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSURL *)documentsDir
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)seedTestData
{
    Item *first = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [first setAmount:100 deadline:[NSDate date] name:@"Item Name" notes:@"Noooootes long notes" person:@"Lenka" type:LiabilityType];
    
    Item *second = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [second setAmount:5000 deadline:[NSDate date] name:@"Item Name" notes:@"Noooootes long notes" person:@"Lenka" type:LiabilityType];
    
    Item *third = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [third setAmount:20 deadline:[NSDate date] name:@"Item Name" notes:@"Noooootes long notes" person:@"Lenka" type:LiabilityType];
    
    Item *fourth = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [fourth setAmount:300 deadline:[NSDate date] name:@"Item Name" notes:@"Noooootes long notes" person:@"Lenka" type:LiabilityType];
    
    
    [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if (error)
            NSLog(@"Save error: %@", [error localizedDescription]);
    }];
}

@end
