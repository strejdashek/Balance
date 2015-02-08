//
//  Common.h
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//system paths
+ (NSString *)documentsDirPath;
+ (NSURL *)documentsDirURL;
+ (NSString *)dbPath;
+ (NSString *)dbName;
+ (NSString *)thumbnailsDirPath;

+ (void)initDocumentsSubdirsStructure;
+ (BOOL)seedDatabase;

@end
