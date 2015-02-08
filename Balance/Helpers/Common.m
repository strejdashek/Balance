//
//  Common.m
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Constants.h"
#import "CoreDataManager.h"

@implementation Common

+ (NSString *)documentsDirPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documentPaths objectAtIndex:0];
}

+ (NSURL *)documentsDirURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)dbPath
{
    return [NSString stringWithFormat:@"%@/%@",[Common documentsDirPath],[Common dbName]];
}

+ (NSString *)dbName
{
    return [NSString stringWithFormat:@"%@.sqlite",kProjectName];
}

+ (NSString *)thumbnailsDirPath
{
    return [NSString stringWithFormat:@"%@/%@",[Common documentsDirPath],kThumbnailsFolder];
}

+ (BOOL)seedDatabase
{    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[Common dbPath]])
    {
        NSLog(@"Db file exists: %@",[Common dbPath]);
        return NO;
    }
    else
    {
        [CoreDataManager seed];
        NSLog(@"Db file created: %@",[Common dbPath]);
        return YES;
    }
}

+ (void)initDocumentsSubdirsStructure
{
    BOOL isDir;
    
    //thumbnails
    if (![[NSFileManager defaultManager] fileExistsAtPath:[Common thumbnailsDirPath] isDirectory:&isDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[Common thumbnailsDirPath] withIntermediateDirectories:NO attributes:nil error:nil];
        
        UIImage *thumbnailMoney = [UIImage imageNamed:kThumbnailForMoney];
        NSData *pngData = UIImagePNGRepresentation(thumbnailMoney);
        [pngData writeToFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForMoney] atomically:YES];
        
        UIImage *thumbnailMoneyRetina = [UIImage imageNamed:kThumbnailForMoneyRetina];
        pngData = UIImagePNGRepresentation(thumbnailMoneyRetina);
        [pngData writeToFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForMoneyRetina] atomically:YES];
        
        UIImage *thumbnailThing = [UIImage imageNamed:kThumbnailForThing];
        pngData = UIImagePNGRepresentation(thumbnailThing);
        [pngData writeToFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForThing] atomically:YES];
        
        UIImage *thumbnailThingRetina = [UIImage imageNamed:kThumbnailForThingRetina];
        pngData = UIImagePNGRepresentation(thumbnailThingRetina);
        [pngData writeToFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForThingRetina] atomically:YES];
    }
}

@end
