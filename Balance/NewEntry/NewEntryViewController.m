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
#import "Common.h"
#import "Constants.h"

@interface NewEntryViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIButton *assetBtn;
@property (weak, nonatomic) IBOutlet UIButton *liabilityBtn;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTF;
@property (weak, nonatomic) IBOutlet UISwitch *amountSwitch;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearDateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIV;

//private properties
@property (assign, nonatomic) ItemsType selectedType;
@property (strong, nonatomic) Person *changedPerson;
@property (strong, nonatomic) NSString *selectedThumbnail;

//action methods
- (IBAction)doneBtnTap:(id)sender;
- (IBAction)cancelBtnTap:(id)sender;
- (IBAction)liabilityBtnTap:(id)sender;
- (IBAction)assetBtnTap:(id)sender;
- (IBAction)amountSwitchTap:(id)sender;
- (IBAction)dateBtnTap:(id)sender;
- (IBAction)personBtnTap:(id)sender;
- (IBAction)clearDateBtnTap:(id)sender;

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
        Item *object = [self.datasourceNewEntryVC itemSelected:self];
        [self setupEditedItem:object];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailIVTap)];
    [self.thumbnailIV setUserInteractionEnabled:YES];
    [self.thumbnailIV addGestureRecognizer:singleTap];
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
    [self.dateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.clearDateBtn setHidden:NO];
}

#pragma mark - PersonSelectionVC Delegate

- (void)personSelectionViewController:(PersonSelectionViewController *)personSelectionVC didSelectPerson:(Person *)person
{
    [self.personBtn setTitle:[person name] forState:UIControlStateNormal];
    self.changedPerson = person;
}

#pragma mark - PersonSelectionVC Delegate

- (void)thumbnailSelectionViewController:(ThumbnailSelectionViewController *)thumbnailSelectionVC didSelectThumbnail:(NSString *)thumbnailName
{
    NSData *pngData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:thumbnailName]];
    self.thumbnailIV.image = [UIImage imageWithData:pngData];
    self.selectedThumbnail = thumbnailName;
}

#pragma mark - PersonSelectionVC DataSource

- (NSString *)thumbnailNameSelected:(ThumbnailSelectionViewController *)thumbnailSelectionVC
{
    return self.selectedThumbnail;
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
        [newItem setPerson:self.changedPerson];
        if ([self.selectedThumbnail length] > 0)
            [newItem setThumbnailName:self.selectedThumbnail];
        else
            [newItem setThumbnailName:([self.amountSwitch isOn]) ? kThumbnailForMoney : kThumbnailForThing];
        
        if ([self validItem:newItem])
        {
            [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
                if (error)
                    NSLog(@"Save new entity error: %@", [error localizedDescription]);
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreatedNewItem" object:self];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }
    else
    {
        Item *editedItem = [self.datasourceNewEntryVC itemSelected:self];
        NSInteger amount = [self.amountSwitch isOn] ? [self.amountTF.text integerValue] : 0;
        
        [editedItem setType:[NSNumber numberWithInteger:self.selectedType]];
        [editedItem setAmount:[NSNumber numberWithInteger:amount]];
        [editedItem setName:self.eventNameTF.text];
        [editedItem setDeadline:[NSDate date]];
        if (self.changedPerson)
            [editedItem setPerson:self.changedPerson];
        [editedItem setThumbnailName:self.selectedThumbnail];
        
        if ([self validItem:editedItem])
        {
            [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
                if (error)
                    NSLog(@"Save edited entity error: %@", [error localizedDescription]);
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdatedItem" object:self];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }
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
        [self.amountTF setText:@""];
    }
    
    NSLog(@"%hhd",[self.amountLbl isHidden]);
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

- (IBAction)personBtnTap:(id)sender
{
    PersonSelectionViewController *personSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonSelectionViewController"];
    personSelectionVC.delegatePersonSelectionVC = self;
    
    [self.navigationController pushViewController:personSelectionVC animated:YES];
}

- (IBAction)clearDateBtnTap:(id)sender
{
    [self.dateBtn setTitle:@"Select" forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.clearDateBtn setHidden:YES];
}

#pragma mark - Private Methods

- (void)thumbnailIVTap
{
    ThumbnailSelectionViewController *thumbnailSelectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ThumbnailSelectionViewController"];
    thumbnailSelectionVC.delegateThumbnailSelectionVC = self;
    thumbnailSelectionVC.dataSourceThumbnailSelectionVC = self;
    
    [self.navigationController pushViewController:thumbnailSelectionVC animated:YES];
}

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
    [self.personBtn setTitle:[[item person] name] forState:UIControlStateNormal];
    [self.personBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    NSData *pngData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:[item thumbnailName]]];
    self.thumbnailIV.image = [UIImage imageWithData:pngData];
    
    if ([[item amount] integerValue] != 0)
    {
        [self.amountSwitch setOn:YES];
        [self.amountLbl setHidden:NO];
        [self.amountTF setHidden:NO];
        [self.amountTF setText:[[item amount] stringValue]];
    }
    else
    {
        [self.amountSwitch setOn:NO];
        [self.amountLbl setHidden:YES];
        [self.amountTF setHidden:YES];
    }
}

- (BOOL)validItem:(Item *)item
{
    BOOL isItemValid = YES;
    NSString *msg;
    
    //there has to be an event name
    if ([self.eventNameTF.text length] == 0)
    {
        msg = @"Enter valid event name";
        isItemValid = NO;
    }
    
    //item has to belong to some person
    if ([self.personBtn.titleLabel.text isEqualToString:@"Select"])
    {
        msg = @"Enter valid person name";
        isItemValid = NO;
    }
    
    //if it's not a solid item there has to be an amount
    if ([self.amountSwitch isOn] && [self.amountTF.text length] == 0)
    {
        msg = @"Enter some amount.";
        isItemValid = NO;
    }
    
    if (!isItemValid)
    {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [errorAlert addAction:okAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
    
    return isItemValid;
}

@end
