//
//  CoreDataManager.m
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "CoreDataManager.h"
#import "Constants.h"
#import "Common.h"
#import "Item.h"

@interface CoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)setupManagedObjectContext;

@end

@implementation CoreDataManager

#pragma mark - Singleton Pattern

static CoreDataManager *coreDataManager;

+ (CoreDataManager *)sharedManager
{
    if (!coreDataManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            coreDataManager = [[CoreDataManager alloc] init];
        });
        
    }
    
    return coreDataManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupManagedObjectContext];
    }
    
    return self;
}

- (void)setupManagedObjectContext
{
    //init model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kProjectName withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //init coordinator
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *persistentURL = [[Common documentsDir] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kProjectName]];
    NSError *error = nil;
    NSPersistentStore *persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                       configuration:nil
                                                                                                 URL:persistentURL
                                                                                             options:nil
                                                                                               error:&error];
    //init context
    if (persistentStore)
    {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        NSLog(@"Db file set up: %@",[persistentURL absoluteString]);
    }
    else
    {
        NSLog(@"Error: %@", error.description);
    }
}

#pragma mark - Basic Methods

- (id)createEntityWithClassName:(NSString *)className
{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:className
                                                            inManagedObjectContext:self.managedObjectContext];
    
    return entity;
}

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock
{
    NSError *saveError = nil;
    savedBlock([self.managedObjectContext save:&saveError], saveError);
}

- (void)deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

#pragma mark - Fetching

- (NSExpressionDescription *)expressionDescriptionForKeyPath:(NSString *)keyPath
{
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    expressionDescription.name = @"expressionName";
    expressionDescription.expression = [NSExpression expressionForKeyPath:keyPath];
    expressionDescription.expressionResultType = NSDecimalAttributeType;

    return expressionDescription;
}

- (NSNumber *)executeFetchRequest:(NSString *)entity withPredicate:(NSPredicate *)predicate withKeyPath:(NSString *)keyPath
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *expression = [self expressionDescriptionForKeyPath:keyPath];
    fetchRequest.propertiesToFetch = @[expression];
    
    if (predicate)
        fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (resultArray == nil)
    {
        NSLog(@"executeFetchRequest: %@", error);
    }
    
    return [[resultArray objectAtIndex:0] objectForKey:expression.name];
}

- (NSArray *)executeFetchRequestSimple:(NSString *)entity withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    //fetchRequest.resultType = NSDictionaryResultType;
    
    if (predicate)
        fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (resultArray == nil)
    {
        NSLog(@"executeFetchRequest: %@", error);
    }
    
    return resultArray;
}

//- (NSArray *)executeFetchWithClassName:(NSString *)className
//                             predicate:(NSPredicate *)predicate
//                       sortDescriptors:(NSArray *)sortDescriptors
//                     propertiesToFetch:(NSArray *)properties
//{
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:className inManagedObjectContext:self.managedObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDescription];
//    
//    if (predicate)
//        [request setPredicate:predicate];
//    if (sortDescriptors)
//        [request setSortDescriptors:sortDescriptors];
//    if (properties)
//        [request setPropertiesToFetch:properties];
//    
//    NSError *error;
//    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
//    if (results == nil)
//    {
//        NSLog(@"Fetching %@ error: %@",className,error.description);
//    }
//    
//    return results;
//}

//- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
//                                           sortDescriptors:(NSArray *)sortDescriptors
//                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
//                                                 predicate:(NSPredicate *)predicate
//
//{
//    NSFetchedResultsController *fetchedResultsController;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:className
//                                              inManagedObjectContext:self.managedObjectContext];
//    fetchRequest.entity = entity;
//    fetchRequest.sortDescriptors = sortDescriptors;
//    fetchRequest.predicate = predicate;
//    
//    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                   managedObjectContext:self.managedObjectContext
//                                                                     sectionNameKeyPath:sectionNameKeypath
//                                                                              cacheName:nil];
//    
//    NSError *error = nil;
//    BOOL success = [fetchedResultsController performFetch:&error];
//    
//    if (!success) {
//        NSLog(@"fetchManagedObjectsWithClassName error: %@", error.description);
//    }
//    
//    return fetchedResultsController;
//}

//- (BOOL)uniqueAttributeForClassName:(NSString *)className
//                      attributeName:(NSString *)attributeName
//                     attributeValue:(id)attributeValue
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
//    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
//    
//    NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
//                                                                            sortDescriptors:sortDescriptors
//                                                                         sectionNameKeyPath:nil
//                                                                                  predicate:predicate];
//    return fetchedResultsController.fetchedObjects.count == 0;
//}

- (void)testFetch
{
    
}

+ (void)seed
{
    //liabilities
    Item *firstL = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [firstL setAmount:56 deadline:[NSDate date] name:@"Food" notes:@"Weekly shopping" person:@"Susan" type:LiabilityType];
    Item *secondL = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [secondL setAmount:42 deadline:[NSDate date] name:@"Headphones" notes:@"" person:@"David" type:LiabilityType];
    Item *thirdL = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [thirdL setAmount:112 deadline:[NSDate date] name:@"Ticket" notes:@"Football Hammers" person:@"Richard" type:LiabilityType];
    Item *fourthL = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [fourthL setAmount:10 deadline:[NSDate date] name:@"Present" notes:@"Present for a former teacher." person:@"Jane" type:LiabilityType];
    
    //assets
    Item *firstA = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [firstA setAmount:100 deadline:[NSDate date] name:@"Car Service" notes:@"Car annual service" person:@"Susan" type:AssetType];
    Item *secondA = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [secondA setAmount:1150 deadline:[NSDate date] name:@"Parfume" notes:@"Versace" person:@"Mom" type:AssetType];
    Item *thirdA = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
    [thirdA setAmount:200 deadline:[NSDate date] name:@"Bet" notes:@"" person:@"George" type:AssetType];
    
    [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if (error)
            NSLog(@"Save error: %@", [error localizedDescription]);
    }];
}

@end







