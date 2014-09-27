//
//  BalanceViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UILabel *totalAssetsLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalLiabilitiesLbl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLbl;

@property (weak, nonatomic) IBOutlet UIView *totalBalanceView;

@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalBalanceView.layer.borderColor = [UIColor blackColor].CGColor;
    self.totalBalanceView.layer.borderWidth = 1.5f;

    NSPredicate *predicateAssets = [NSPredicate predicateWithFormat:@"type == %d",AssetType];
    NSNumber *totalAsset = [[CoreDataManager sharedManager] executeFetchRequest:@"Item" withPredicate:predicateAssets withKeyPath:@"@sum.amount"];
    NSPredicate *predicateLiabilities = [NSPredicate predicateWithFormat:@"type == %d",LiabilityType];
    NSNumber *totalLiability = [[CoreDataManager sharedManager] executeFetchRequest:@"Item" withPredicate:predicateLiabilities withKeyPath:@"@sum.amount"];
    
    [self.totalAssetsLbl setText:[totalAsset stringValue]];
    [self.totalLiabilitiesLbl setText:[totalLiability stringValue]];
    
    if ([totalAsset compare:totalLiability] == NSOrderedDescending)
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%d",[totalAsset integerValue] - [totalLiability integerValue]]];
    }
    else
    {
        [self.balanceLbl setText:[NSString stringWithFormat:@"%d",[totalLiability integerValue] - [totalAsset integerValue]]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
