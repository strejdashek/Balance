//
//  ItemsViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/24/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "ItemsViewController.h"
#import "CoreDataManager.h"
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import "Person.h"

@interface ItemsViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItems;

//private properties
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;

//action methods
- (IBAction)deleteBtnTap:(id)sender;

@end

@implementation ItemsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadItemsAlongWithCollectionView:NO];
    
    [self setupNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications Handling

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"DidCreatedNewItem"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"DidUpdatedItem"
                                               object:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"DidCreatedNewItem"])
    {
        [self reloadItemsAlongWithCollectionView:YES];
    }
    else if ([[notification name] isEqualToString:@"DidUpdatedItem"])
    {
        [self reloadItemsAlongWithCollectionView:YES];
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell *cell;
    
    if (self.itemsType == AssetType)
        cell = (ItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    else
        cell = (ItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LiabilityCell" forIndexPath:indexPath];
    
    Item *item = (Item *)[self.items objectAtIndex:indexPath.row];
    [cell.nameLbl setText:[item name]];
    [cell.amountLbl setText:[[item amount] stringValue]];
    [cell.personLbl setText:[[item person] name]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewEntryViewController *newEntryVC = [[UIStoryboard storyboardWithName:@"NewEntry" bundle:nil] instantiateViewControllerWithIdentifier:@"NewEntryViewController"];
    [newEntryVC setDatasourceNewEntryVC:self];
    self.selectedItemIndexPath = indexPath;
    [self presentViewController:newEntryVC animated:YES completion:nil];
}

#pragma mark - NewEntryVC DataSource

- (ItemsType)itemType:(NewEntryViewController *)newEntryVC
{
    return self.itemsType;
}

- (NewEntryMode)newEntryMode:(NewEntryViewController *)newEntryVC
{
    return NewEntryEditMode;
}

- (NSManagedObject *)itemSelected:(NewEntryViewController *)newEntryVC
{
    NSManagedObject *selectedItem = [self.items objectAtIndex:self.selectedItemIndexPath.row];
    return selectedItem;
}

#pragma mark - NewEntryVC Delegate

- (void)newEntryVC:(NewEntryViewController *)newEntryVC didUpdatedItem:(Item *)updatedItem
{
    //reload this vc + balance vc
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 1)
        {
            NSManagedObject *selectedItem = [self.items objectAtIndex:self.selectedItemIndexPath.row];
            NSNumber *selectedAmount = (NSNumber *)[selectedItem valueForKey:@"amount"];
            
            [[CoreDataManager sharedManager] deleteEntity:selectedItem];
            [self.items removeObjectAtIndex:self.selectedItemIndexPath.row];
            [self.collectionViewItems deleteItemsAtIndexPaths:@[self.selectedItemIndexPath]];
            
            [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
                if (error)
                    NSLog(@"Delete error: %@", [error localizedDescription]);
            }];
            
            [self.delegateItemsVC itemsViewController:self didRemoveItemWithAmount:selectedAmount];
        }
    }
}

#pragma mark - Action Methods

- (IBAction)deleteBtnTap:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collectionViewItems];
    self.selectedItemIndexPath = [self.collectionViewItems indexPathForItemAtPoint:buttonPosition];
    
    NSManagedObject *selectedItem = [self.items objectAtIndex:self.selectedItemIndexPath.row];
    NSString *msg = [NSString stringWithFormat:@"Do you really want to remove %@ item?",[selectedItem valueForKey:@"name"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok",nil];
    [alert setTag:1];
    [alert show];
}

#pragma mark - Private Methods

- (void)reloadItemsAlongWithCollectionView:(BOOL)includeCollectionView
{
    NSPredicate *predicate;
    if (self.itemsType == AssetType)
        predicate = [NSPredicate predicateWithFormat:@"type == %d",AssetType];
    else
        predicate = [NSPredicate predicateWithFormat:@"type == %d",LiabilityType];
    
    self.items = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicate]];
    
    if (includeCollectionView)
        [self.collectionViewItems reloadData];
}

@end
