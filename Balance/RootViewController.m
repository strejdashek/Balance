//
//  RootViewController.m
//  Balance
//
//  Created by Viktor Kucera on 9/20/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+ImageEffects.h"

@interface RootViewController ()

//outlets
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIV;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIButton *createEventBtn;

//private properties
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *viewControllers;

//action methods
- (IBAction)createEventBtnTap:(id)sender;

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
    [balanceVC setDelegateBalanceVC:self];
    ItemsViewController *assetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemsViewController"];
    [assetVC setItemsType:AssetType];
    [assetVC setDelegateItemsVC:balanceVC];
    ItemsViewController *liabilityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemsViewController"];
    [liabilityVC setItemsType:LiabilityType];
    [liabilityVC setDelegateItemsVC:balanceVC];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:assetVC,balanceVC,liabilityVC,nil];
    [self.pageViewController setViewControllers:@[balanceVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.backgroundIV.image = [self blurWithImageEffects:self.backgroundIV.image];
    
    //add pageviewcontroller
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //move some elements to front
    [self.view bringSubviewToFront:self.bottomBarView];
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.createEventBtn];
}

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:40 tintColor:[UIColor colorWithWhite:0.2 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BalanceVC Delegate

- (void)balanceViewController:(BalanceViewController *)balanceVC didSelectTotalItemType:(ItemsType)itemType;
{
    NSLog(@"Manual swipe not implemented since its choppy, I will fix later");
    
//    ItemsViewController *switchToVC;
//    UIPageViewControllerNavigationDirection direction;
//    
//    if (itemType == AssetType)
//    {
//        switchToVC = [self.viewControllers objectAtIndex:([self.pageControl currentPage] - 1)];
//        direction = UIPageViewControllerNavigationDirectionReverse;
//    }
//    else if (itemType == LiabilityType)
//    {
//        switchToVC = [self.viewControllers objectAtIndex:([self.pageControl currentPage] + 1)];
//        direction = UIPageViewControllerNavigationDirectionForward;
//    }
//    
//    [self.pageViewController setViewControllers:@[switchToVC] direction:direction animated:YES completion:nil];
//    
//    self.pageControl.currentPage = [self.viewControllers indexOfObject:self.pageViewController.viewControllers[0]];
}

#pragma mark - NewEntryVC DataSource

- (ItemsType)itemType:(NewEntryViewController *)newEntryVC
{
    id currentVC = [self.viewControllers objectAtIndex:self.pageControl.currentPage];
    if ([currentVC isKindOfClass:[BalanceViewController class]])
        return AssetType;
    else
        return [(ItemsViewController *)[self.viewControllers objectAtIndex:self.pageControl.currentPage] itemsType];
}

- (NewEntryMode)newEntryMode:(NewEntryViewController *)newEntryVC
{
    return NewEntryNewMode;
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
        if ([pageViewController.viewControllers[0] isKindOfClass:[ItemsViewController class]])
        {
            if ([(ItemsViewController *)pageViewController.viewControllers[0] itemsType] == AssetType)
                self.navigationItem.title = @"Assets";
            else
                self.navigationItem.title = @"Liabilities";
        }
        else
            self.navigationItem.title = @"Balance";
        
        self.pageControl.currentPage = [self.viewControllers indexOfObject:pageViewController.viewControllers[0]];
    }
}

#pragma mark - Action Methods

- (IBAction)createEventBtnTap:(id)sender
{
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"NewEntry" bundle:nil] instantiateViewControllerWithIdentifier:@"NewEntryNavigationController"];
    NewEntryViewController *newEntryVC  = navigationController.viewControllers[0];
    [newEntryVC setDatasourceNewEntryVC:self];
    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
