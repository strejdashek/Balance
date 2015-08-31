//
//  PersonSelectionViewController.m
//  Balance
//
//  Created by Viktor Kucera on 12/2/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "PersonSelectionViewController.h"
#import "PersonSelectionTableViewCell.h"
#import "CoreDataManager.h"
#import "Person.h"
#import "PersonCreateViewController.h"
#import "UIColor+CustomColors.h"

@interface PersonSelectionViewController ()

//private properties
@property (nonatomic, strong) NSMutableArray *persons;
@property (weak, nonatomic) IBOutlet UITableView *personsTableView;

//action methods
- (IBAction)backBtnTap:(id)sender;
- (IBAction)createBtnTap:(id)sender;

@end

@implementation PersonSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.persons = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManager] executeFetchRequestSimple:@"Person" withPredicate:nil]];
    
    self.personsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.persons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    Person *person = [self.persons objectAtIndex:indexPath.row];
    
    [cell.personNameLbl setText:[person name]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *person = [self.persons objectAtIndex:indexPath.row];
    [self.delegatePersonSelectionVC personSelectionViewController:self didSelectPerson:person];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PersonCreateVC Delegate

- (void)personCreateViewController:(PersonCreateViewController *)personCreateVC didCreatePerson:(Person *)person
{
    [self.persons addObject:person];
    [self.personsTableView reloadData];
}

#pragma mark - Action Methods

- (IBAction)backBtnTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createBtnTap:(id)sender
{
    PersonCreateViewController *personCreateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonCreateViewController"];
    personCreateVC.delegatePersonCreateVC = self;
    
    [self.navigationController pushViewController:personCreateVC animated:YES];
}
@end
