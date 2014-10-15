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

@property (weak, nonatomic) IBOutlet UIView *totalBalanceView;

//action methods
- (IBAction)totalAssetsBtnTap:(id)sender;
- (IBAction)totalLiabilitiesBtnTap:(id)sender;

@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalBalanceView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.totalBalanceView.layer.borderWidth = 1.5f;

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
        self.totalAssetsLbl.text = [NSString stringWithFormat:@"%d",newAmount];
    }
    else
    {
        NSInteger newAmount = [self.totalLiabilitiesLbl.text integerValue] - [amount integerValue];
        self.totalLiabilitiesLbl.text = [NSString stringWithFormat:@"%d",newAmount];
    }
    
    [self reloadBalance];
}

#pragma mark - Action Methods

- (IBAction)totalAssetsBtnTap:(id)sender
{
    [self.delegateBalanceVC balanceViewController:self didSelectTotalItemType:AssetType];
}

- (IBAction)totalLiabilitiesBtnTap:(id)sender
{
    [self.delegateBalanceVC balanceViewController:self didSelectTotalItemType:LiabilityType];
}

#pragma mark - Private Methods

- (void)reloadTotals
{
    NSPredicate *predicateAssets = [NSPredicate predicateWithFormat:@"type == %d",AssetType];
    NSNumber *totalAsset = [[CoreDataManager sharedManager] executeFetchRequest:@"Item" withPredicate:predicateAssets withKeyPath:@"@sum.amount"];
    NSPredicate *predicateLiabilities = [NSPredicate predicateWithFormat:@"type == %d",LiabilityType];
    NSNumber *totalLiability = [[CoreDataManager sharedManager] executeFetchRequest:@"Item" withPredicate:predicateLiabilities withKeyPath:@"@sum.amount"];
    
    [self.totalAssetsLbl setText:[totalAsset stringValue]];
    [self.totalLiabilitiesLbl setText:[totalLiability stringValue]];
    
    [self reloadBalance];
}

- (void)reloadBalance
{
    NSInteger totalAsset = [self.totalAssetsLbl.text integerValue];
    NSInteger totalLiability = [self.totalLiabilitiesLbl.text integerValue];
    
    if (totalAsset > totalLiability)
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%d",totalAsset - totalLiability]];
        [self.balanceLbl setTextColor:[UIColor customGreen]];
    }
    else if (totalAsset < totalLiability)
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%d",totalLiability - totalAsset]];
        [self.balanceLbl setTextColor:[UIColor customRed]];
    }
    else
    {
        [self.balanceLbl setText:@"0"];
    }
}

@end
