//
//  ItemsViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/24/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "ItemsViewController.h"
#import "CoreDataManager.h"

@interface ItemsViewController ()

@property (strong, nonatomic) NSArray *items;

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
    
    self.items = [[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicate];    
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

#pragma mark - Action Methods

@end
