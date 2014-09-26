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
    self.totalBalanceView.layer.borderWidth = 1.0f;
    
//    NSExpressionDescription *amountSum = [[CoreDataManager sharedManager] expressionDescription:@"sum" forKeyPath:@"amount" forFunction:@"sum:"];
//    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",1];
//    
//    NSArray *result = [[CoreDataManager sharedManager] executeFetchWithClassName:@"Item"
//                                                                       predicate:nil
//                                                                 sortDescriptors:nil
//                                                               propertiesToFetch:@[amountSum]];
//    
//    id amount = [[result firstObject] valueForKey:@"sum"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
