//
//  RootViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *leftGreenView;
@property (weak, nonatomic) IBOutlet UIView *rightRedView;


//private properties
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *viewControllers;

//action methods
- (IBAction)newEventBtnTap:(id)sender;

@end

@implementation RootViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //setup everything needed
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    BalanceViewController *balanceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BalanceViewController"];
    AssetViewController *assetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetViewController"];
    LiabilityViewController *liabilityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LiabilityViewController"];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:assetVC,balanceVC,liabilityVC,nil];
    [self.pageViewController setViewControllers:@[balanceVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:1.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.leftGreenView.frame = CGRectMake(76, 349, 200, 132);
                         self.rightRedView.frame = CGRectMake(492, 349, 200, 132);
                     }
                     completion:^(BOOL finished){
                         
                         //add pageviewcontroller
                         [self addChildViewController:self.pageViewController];
                         [self.view addSubview:self.pageViewController.view];
                         [self.pageViewController didMoveToParentViewController:self];
                         
                         [self.view bringSubviewToFront:self.pageControl];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.viewControllers indexOfObject:viewController];
    
    if (currentIndex == 0)
    {
        return nil;
    }
    else
    {
        return [self.viewControllers objectAtIndex:currentIndex - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.viewControllers indexOfObject:viewController];
    
    if (currentIndex == ([self.viewControllers count] - 1))
    {
        return nil;
    }
    else
    {
        return [self.viewControllers objectAtIndex:currentIndex + 1];
    }
}

#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        self.pageControl.currentPage = [self.viewControllers indexOfObject:pageViewController.viewControllers[0]];
    }
}

#pragma mark - Action Methods

- (IBAction)newEventBtnTap:(id)sender
{
    NewEntryViewController *newEntryVC = [[UIStoryboard storyboardWithName:@"NewEntry" bundle:nil] instantiateViewControllerWithIdentifier:@"NewEntryViewController"];
    [self presentViewController:newEntryVC animated:YES completion:nil];
}
@end
