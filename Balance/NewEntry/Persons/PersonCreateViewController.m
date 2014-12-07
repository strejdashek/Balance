//
//  PersonCreateViewController.m
//  Balance
//
//  Created by Viktor Kucera on 12/4/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "PersonCreateViewController.h"
#import "Person.h"
#import "CoreDataManager.h"

@interface PersonCreateViewController ()

//private properties
@property (weak, nonatomic) IBOutlet UITextField *personNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *personFaceImg;

//action methods
- (IBAction)backBtnTap:(id)sender;
- (IBAction)saveBtnTap:(id)sender;

@end

@implementation PersonCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Methods

- (IBAction)backBtnTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnTap:(id)sender
{
    if ([self.personNameTF.text length] > 0)
    {
        Person *person = [[CoreDataManager sharedManager] createEntityForName:@"Person"];
        [person setName:self.personNameTF.text];
        
        [[CoreDataManager sharedManager] saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error){
            if (error)
            {
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error when trying to save new person." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                [errorAlert addAction:okAction];
                [self presentViewController:errorAlert animated:YES completion:nil];
                
                NSLog(@"Save new entity error: %@", [error localizedDescription]);
            }
            else
            {
                [self.delegatePersonCreateVC personCreateViewController:self didCreatePerson:person];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter person's name." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [errorAlert addAction:okAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}

@end
