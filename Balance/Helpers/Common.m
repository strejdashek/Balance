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
//    [[CoreDataManager sharedManager] createEntityWithClassName:@"Item" attributesDictionary:nil];
//    [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:nil];
//    
//    NSManagedObject *person = [NSEntityDescription
//                               insertNewObjectForEntityForName:@"Question"
//                               inManagedObjectContext:self.context];
//    [person setValue:img forKey:@"img"];
//    [person setValue:text forKey:@"text"];
//    [person setValue:[NSNumber numberWithBool:male] forKey:@"male"];
//    
//    NSError *error;
//    if (![self.context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
}

@end
