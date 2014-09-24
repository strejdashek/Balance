//
//  NewEntryViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "NewEntryViewController.h"

@interface NewEntryViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIButton *assetBtn;
@property (weak, nonatomic) IBOutlet UIButton *liabilityBtn;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

//action methods
- (IBAction)doneBtnTap:(id)sender;
- (IBAction)cancelBtnTap:(id)sender;
- (IBAction)liabilityBtnTap:(id)sender;
- (IBAction)assetBtnTap:(id)sender;

@end

@implementation NewEntryViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self switchToItemType:[self.datasourceNewEntryVC itemType:self]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods
- (IBAction)doneBtnTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)liabilityBtnTap:(id)sender
{
    [self switchToItemType:LiabilityType];
}
- (IBAction)assetBtnTap:(id)sender
{
    [self switchToItemType:AssetType];
}

#pragma mark - Private Methods

- (void)switchToItemType:(ItemsType)itemType
{
    if (itemType == AssetType)
    {
        [self.liabilityBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        [self.assetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.liabilityBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.assetBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        
        [self.screenTitle setText:@"Asset"];
    }
    else
    {
        [self.assetBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        [self.liabilityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.assetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.liabilityBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        
        [self.screenTitle setText:@"Liability"];
    }
}

@end
