//
//  CoreDataManager.h
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;

- (id)createEntityForName:(NSString *)className;
- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;
- (void)deleteEntity:(NSManagedObject *)entity;
+ (void)seed;
- (void)testFetch;

- (NSExpressionDescription *)expressionDescriptionForKeyPath:(NSString *)keyPath;
- (NSNumber *)executeFetchRequest:(NSString *)entity withPredicate:(NSPredicate *)predicate withKeyPath:(NSString *)keyPath;
- (NSArray *)executeFetchRequestSimple:(NSString *)entity withPredicate:(NSPredicate *)predicate;



//- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
//                                           sortDescriptors:(NSArray *)sortDescriptors
//                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
//                                                 predicate:(NSPredicate *)predicate;

//- (BOOL)uniqueAttributeForClassName:(NSString *)className
//                      attributeName:(NSString *)attributeName
//                     attributeValue:(id)attributeValue;

@end
