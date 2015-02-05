//
//  BalanceViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "BalanceViewController.h"
#import "UIColor+CustomColors.h"

@interface BalanceViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLiabilitiesLbl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAssetThingsLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLiabilityThingsLbl;
@property (weak, nonatomic) IBOutlet UILabel *numOfAssetsLbl;
@property (weak, nonatomic) IBOutlet UILabel *numOfLiabilitiesLbl;


//action methods

@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadTotals];
    
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
        [self reloadTotals];
    }
    else if ([[notification name] isEqualToString:@"DidUpdatedItem"])
    {
        [self reloadTotals];
    }
}

#pragma mark - ItemsVC Delegate

- (void)itemsViewController:(ItemsViewController *)itemsVC didRemoveItemWithAmount:(NSNumber *)amount
{
    if (itemsVC.itemsType == AssetType)
    {
        NSInteger newAmount = [self.totalAssetsLbl.text integerValue] - [amount integerValue];
        self.totalAssetsLbl.text = [NSString stringWithFormat:@"%zd",newAmount];
    }
    else
    {
        NSInteger newAmount = [self.totalLiabilitiesLbl.text integerValue] - [amount integerValue];
        self.totalLiabilitiesLbl.text = [NSString stringWithFormat:@"%zd",newAmount];
    }
    
    [self reloadBalance];
}

#pragma mark - Private Methods

- (void)reloadTotals
{
    NSPredicate *predicateAssets = [NSPredicate predicateWithFormat:@"type == %d",AssetType];
    NSArray *assets = [[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicateAssets];
    NSNumber *totalAsset = [assets valueForKeyPath:@"@sum.amount"];
    
    NSPredicate *predicateLiabilities = [NSPredicate predicateWithFormat:@"type == %d",LiabilityType];
    NSArray *liabilities = [[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicateLiabilities];
    NSNumber *totalLiability = [liabilities valueForKeyPath:@"@sum.amount"];
    
    NSPredicate *predicateAssetThings = [NSPredicate predicateWithFormat:@"amount == 0 AND type == %d",AssetType];
    NSArray *assetThings = [[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicateAssetThings];
    NSPredicate *predicateLiabilityThings = [NSPredicate predicateWithFormat:@"amount == 0 AND type == %d",LiabilityType];
    NSArray *liabilityThings = [[CoreDataManager sharedManager] executeFetchRequestSimple:@"Item" withPredicate:predicateLiabilityThings];
    
    [self.totalAssetsLbl setText:[totalAsset stringValue]];
    [self.totalLiabilitiesLbl setText:[totalLiability stringValue]];
    [self.totalAssetThingsLbl setText:[NSString stringWithFormat:@"%ld things",(long)[assetThings count]]];
    [self.totalLiabilityThingsLbl setText:[NSString stringWithFormat:@"%ld things",(long)[liabilityThings count]]];
    [self.numOfAssetsLbl setText:[NSString stringWithFormat:@"%ld",(long)[assets count]]];
    [self.numOfLiabilitiesLbl setText:[NSString stringWithFormat:@"%ld",(long)[liabilities count]]];
    
    [self reloadBalance];
}

- (void)reloadBalance
{
    NSInteger totalAsset = [self.totalAssetsLbl.text integerValue];
    NSInteger totalLiability = [self.totalLiabilitiesLbl.text integerValue];
    
    if (totalAsset > totalLiability)
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%zd",totalAsset - totalLiability]];
        [self.balanceLbl setTextColor:[UIColor customGreen]];
    }
    else if (totalAsset < totalLiability)
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%zd",totalLiability - totalAsset]];
        [self.balanceLbl setTextColor:[UIColor customRed]];
    }
    else
    {
        [self.balanceLbl setText:@"0"];
    }
}

@end
