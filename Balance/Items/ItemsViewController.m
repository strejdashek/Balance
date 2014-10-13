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
    
    NSPredicate *predicate;
    if (self.itemsType == AssetType)
        predicate = [NSPredicate predicateWithFormat:@"type == %d",AssetType];
    else
        predicate = [NSPredicate predicateWithFormat:@"type == %d",LiabilityType];
    
    self.items = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicate]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    NSManagedObject *object = [self.items objectAtIndex:indexPath.row];
    [cell.nameLbl setText:[object valueForKey:@"name"]];
    [cell.amountLbl setText:[(NSNumber *)[object valueForKey:@"amount"] stringValue]];
    [cell.personLbl setText:[object valueForKey:@"person"]];
    
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

@end
