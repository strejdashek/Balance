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
#import "Person.h"

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
        NSLog(@"Db file set up: %@/%@.sqlite",[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],kProjectName);
    }
    else
    {
        NSLog(@"Error: %@", error.description);
    }
}

#pragma mark - Basic Methods

- (id)createEntityForName:(NSString *)className
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

+ (void)seed
{
    //*********************************** PERSONS ***********************************
    
    Person *susan = [[CoreDataManager sharedManager] createEntityForName:@"Person"];
    [susan setName:@"Susan"];
    
    Person *richard = [[CoreDataManager sharedManager] createEntityForName:@"Person"];
    [richard setName:@"Richard"];
    
    Person *george = [[CoreDataManager sharedManager] createEntityForName:@"Person"];
    [george setName:@"George"];
    
    //*********************************** LIABILITIES ***********************************
    
    Item *firstL = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [firstL setAmount:[NSNumber numberWithInteger:56]];
    [firstL setType:[NSNumber numberWithInt:LiabilityType]];
    [firstL setDeadline:[NSDate date]];
    [firstL setName:@"Food"];
    [firstL setNotes:@"Weekly shopping."];
    [firstL setPerson:susan];
    
    Item *secondL = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [secondL setAmount:[NSNumber numberWithInteger:42]];
    [secondL setType:[NSNumber numberWithInt:LiabilityType]];
    [secondL setDeadline:[NSDate date]];
    [secondL setName:@"Headphones"];
    [secondL setPerson:richard];
    
    Item *thirdL = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [thirdL setAmount:[NSNumber numberWithInteger:100]];
    [thirdL setType:[NSNumber numberWithInt:LiabilityType]];
    [thirdL setDeadline:[NSDate date]];
    [thirdL setName:@"Tickets"];
    [thirdL setNotes:@"BPL Gunners - QPR and Bubbels - Gunners."];
    [thirdL setPerson:richard];
    
    Item *fourthL = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [fourthL setAmount:[NSNumber numberWithInteger:0]];
    [fourthL setType:[NSNumber numberWithInt:LiabilityType]];
    [fourthL setDeadline:[NSDate date]];
    [fourthL setName:@"Bike"];
    [fourthL setNotes:@"For one week trip."];
    [fourthL setPerson:george];
    
    //*********************************** ASSETS ***********************************
    
    Item *firstA = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [firstA setAmount:[NSNumber numberWithInteger:120]];
    [firstA setType:[NSNumber numberWithInt:AssetType]];
    [firstA setDeadline:[NSDate date]];
    [firstA setName:@"Car Service"];
    [firstA setNotes:@"Oil + tires."];
    [firstA setPerson:susan];
    
    Item *secondA = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
    [secondA setAmount:[NSNumber numberWithInteger:200]];
    [secondA setType:[NSNumber numberWithInt:AssetType]];
    [secondA setDeadline:[NSDate date]];
    [secondA setName:@"Bet"];
    [secondA setPerson:george];

    //*********************************** SAVE ROUTINE ***********************************
    
    [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
        if (error)
            NSLog(@"Save error: %@", [error localizedDescription]);
    }];
}

@end







