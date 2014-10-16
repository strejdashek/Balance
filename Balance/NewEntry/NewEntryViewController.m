//
//  NewEntryViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "NewEntryViewController.h"
#import "CoreDataManager.h"
#import "Item.h"
#import "UIColor+CustomColors.h"

@interface NewEntryViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIButton *assetBtn;
@property (weak, nonatomic) IBOutlet UIButton *liabilityBtn;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTF;
@property (weak, nonatomic) IBOutlet UISwitch *amountSwitch;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UITextField *personTF;
@property (weak, nonatomic) IBOutlet UITextField *deadlineTF;
@property (weak, nonatomic) IBOutlet UITextView *notesTF;

//action methods
- (IBAction)doneBtnTap:(id)sender;
- (IBAction)cancelBtnTap:(id)sender;
- (IBAction)liabilityBtnTap:(id)sender;
- (IBAction)assetBtnTap:(id)sender;
- (IBAction)amountSwitchTap:(id)sender;

@end

@implementation NewEntryViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.datasourceNewEntryVC newEntryMode:self] == NewEntryEditMode)
    {
        [self switchToItemType:[self.datasourceNewEntryVC itemType:self]];
        
        NSManagedObject *object = [self.datasourceNewEntryVC itemSelected:self];
        [self setupEditedItem:object];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

- (IBAction)doneBtnTap:(id)sender
{
    if ([self.datasourceNewEntryVC newEntryMode:self] == NewEntryNewMode)
    {
        Item *newItem = [[CoreDataManager sharedManager] createEntityWithClassName:@"Item"];
        NSInteger amount = [self.amountSwitch isOn] ? [self.amountTF.text integerValue] : 0;
        [newItem setAmount:amount deadline:[NSDate date] name:self.eventNameTF.text notes:self.notesTF.text person:self.personTF.text type:[self.datasourceNewEntryVC itemType:self]];
        
        [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
            if (error)
                NSLog(@"Save new entity error: %@", [error localizedDescription]);
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreatedNewItem" object:self];
            }
        }];
        
        
    }
    else
    {
        NSManagedObject *object = [self.datasourceNewEntryVC itemSelected:self];
        Item *testItem = (Item *)object;
        NSInteger amount = [self.amountSwitch isOn] ? [self.amountTF.text integerValue] : 0;
        [testItem setAmount:amount deadline:[NSDate date] name:self.eventNameTF.text notes:self.notesTF.text person:self.personTF.text type:[self.datasourceNewEntryVC itemType:self]];
        
        [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
            if (error)
                NSLog(@"Save edited entity error: %@", [error localizedDescription]);
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdatedItem" object:self];
            }
        }];
    }
    
    
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

- (IBAction)amountSwitchTap:(id)sender
{
    if ([(UISwitch *)sender isOn])
    {
        [self.amountLbl setHidden:NO];
        [self.amountTF setHidden:NO];
    }
    else
    {
        [self.amountLbl setHidden:YES];
        [self.amountTF setHidden:YES];
    }
}

#pragma mark - Private Methods

- (void)switchToItemType:(ItemsType)itemType
{
    if (itemType == AssetType)
    {
        [self.liabilityBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        [self.assetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.amountSwitch setOnTintColor:[UIColor customGreen]];
        [self.amountTF setTextColor:[UIColor customGreen]];
        
        [self.liabilityBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.assetBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    }
    else
    {
        [self.assetBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        [self.liabilityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.amountSwitch setOnTintColor:[UIColor customRed]];
        [self.amountTF setTextColor:[UIColor customRed]];
        
        [self.assetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.liabilityBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    }
}

- (void)setupEditedItem:(NSManagedObject *)item
{    
    [self.eventNameTF setText:(NSString *)[item valueForKey:@"name"]];
    if ([(NSNumber *)[item valueForKey:@"amount"] integerValue] == 0)
    {
        [self.amountSwitch setOn:NO];
        [self.amountLbl setHidden:YES];
        [self.amountTF setHidden:YES];
    }
    else
    {
        [self.amountSwitch setOn:YES];
        [self.amountLbl setHidden:NO];
        [self.amountTF setHidden:NO];
        [self.amountTF setText:[(NSNumber *)[item valueForKey:@"amount"] stringValue]];
    }
    [self.personTF setText:(NSString *)[item valueForKey:@"person"]];
    //[self.deadlineTF setText:[editedItem deadline] ];
    [self.notesTF setText:(NSString *)[item valueForKey:@"notes"]];
}

@end
