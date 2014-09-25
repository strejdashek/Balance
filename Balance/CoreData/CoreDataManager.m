//
//  CoreDataManager.m
//  Balance
//
//  Created by Viktor Kucera on 9/25/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()


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

#pragma mark - CoreData Basic Methods

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

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate

{
    NSFetchedResultsController *fetchedResultsController;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                              inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:sectionNameKeypath
                                                                              cacheName:nil];
    
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        NSLog(@"fetchManagedObjectsWithClassName error: %@", error.description);
    }
    
    return fetchedResultsController;
}

- (void)deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
                                                                            sortDescriptors:sortDescriptors
                                                                         sectionNameKeyPath:nil
                                                                                  predicate:predicate];
    return fetchedResultsController.fetchedObjects.count == 0;
}

@end







