//
//  CoreDataManager.h
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
#import "Constants.h"
#import "Common.h"

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;

- (id)createEntityWithClassName:(NSString *)className;
- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;
- (void)deleteEntity:(NSManagedObject *)entity;
- (void)seed;
- (void)testFetch;

- (NSExpressionDescription *)expressionDescription:(NSString *)name
                                        forKeyPath:(NSString *)keyPath
                                       forFunction:(NSString *)function;
- (NSArray *)executeFetchWithClassName:(NSString *)className
                             predicate:(NSPredicate *)predicate
                       sortDescriptors:(NSArray *)sortDescriptors
                     propertiesToFetch:(NSArray *)properties;


//- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
//                                           sortDescriptors:(NSArray *)sortDescriptors
//                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
//                                                 predicate:(NSPredicate *)predicate;

//- (BOOL)uniqueAttributeForClassName:(NSString *)className
//                      attributeName:(NSString *)attributeName
//                     attributeValue:(id)attributeValue;

@end
