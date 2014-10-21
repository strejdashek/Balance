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
#import "Person.h"

@interface NewEntryViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIButton *assetBtn;
@property (weak, nonatomic) IBOutlet UIButton *liabilityBtn;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTF;
@property (weak, nonatomic) IBOutlet UISwitch *amountSwitch;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UITextView *notesTF;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

//private properties
@property (assign, nonatomic) ItemsType selectedType;

//action methods
- (IBAction)doneBtnTap:(id)sender;
- (IBAction)cancelBtnTap:(id)sender;
- (IBAction)liabilityBtnTap:(id)sender;
- (IBAction)assetBtnTap:(id)sender;
- (IBAction)amountSwitchTap:(id)sender;
- (IBAction)dateBtnTap:(id)sender;
- (IBAction)personBtnTap:(id)sender;

@end

@implementation NewEntryViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self switchToItemType:[self.datasourceNewEntryVC itemType:self]];
    
    if ([self.datasourceNewEntryVC newEntryMode:self] == NewEntryEditMode)
    {
        [self.liabilityBtn setUserInteractionEnabled:NO];
        [self.assetBtn setUserInteractionEnabled:NO];
    }
    
    if ([self.datasourceNewEntryVC newEntryMode:self] == NewEntryEditMode)
    {
        Item *object = (Item *)[self.datasourceNewEntryVC itemSelected:self];
        [self setupEditedItem:object];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - DatePickerVC Delegate

- (void)datePickerViewController:(DatePickerViewController *)datePickerVC didChangeDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    [self.dateBtn setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

#pragma mark - Action Methods

- (IBAction)doneBtnTap:(id)sender
{
    if ([self.datasourceNewEntryVC newEntryMode:self] == NewEntryNewMode)
    {
        Item *newItem = [[CoreDataManager sharedManager] createEntityForName:@"Item"];
        NSInteger amount = [self.amountSwitch isOn] ? [self.amountTF.text integerValue] : 0;
        [newItem setType:[NSNumber numberWithInteger:self.selectedType]];
        [newItem setAmount:[NSNumber numberWithInteger:amount]];
        [newItem setName:self.eventNameTF.text];
        [newItem setDeadline:[NSDate date]];
        [newItem setNotes:self.notesTF.text];
        
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
        Item *editedItem = (Item *)[self.datasourceNewEntryVC itemSelected:self];
        NSInteger amount = [self.amountSwitch isOn] ? [self.amountTF.text integerValue] : 0;
        
        [editedItem setType:[NSNumber numberWithInteger:self.selectedType]];
        [editedItem setAmount:[NSNumber numberWithInteger:amount]];
        [editedItem setName:self.eventNameTF.text];
        [editedItem setDeadline:[NSDate date]];
        [editedItem setNotes:self.notesTF.text];
        
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

- (IBAction)dateBtnTap:(id)sender
{
    DatePickerViewController *datePickerVC = [[UIStoryboard storyboardWithName:@"DatePicker" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePickerVC"];
    [datePickerVC setModalPresentationStyle:UIModalPresentationPopover];
    [datePickerVC setDelegateDatePickerVC:self];
    
    UIPopoverPresentationController *popoverPresentationController = datePickerVC.popoverPresentationController;
    popoverPresentationController.sourceRect = ((UIButton *)sender).bounds;
    popoverPresentationController.sourceView = sender;
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popoverPresentationController.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:datePickerVC animated:YES completion:nil];
}

- (IBAction)personBtnTap:(id)sender {
}

#pragma mark - Private Methods

- (void)switchToItemType:(ItemsType)itemType
{
    self.selectedType = itemType;
    
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

- (void)setupEditedItem:(Item *)item
{    
    [self.eventNameTF setText:[item name]];
    if ([[item amount] integerValue] == 0)
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
        [self.amountTF setText:[[item amount] stringValue]];
    }
    [self.personBtn setTitle:[[item person] name] forState:UIControlStateNormal];
    [self.personBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.notesTF setText:[item notes]];
}

@end
