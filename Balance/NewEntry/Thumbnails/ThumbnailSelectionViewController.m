//
//  ThumbnailSelectionViewController.m
//  Balance
//
//  Created by Viktor Kucera on 2/7/15.
//  Copyright (c) 2015 Viktor Kucera. All rights reserved.
//

#import "ThumbnailSelectionViewController.h"
#import "UIImage+Size.h"
#import "Common.h"
#import "Constants.h"

@interface ThumbnailSelectionViewController ()

//private properties
@property (weak, nonatomic) NSString *customThumbnailName;

//outlets
@property (weak, nonatomic) IBOutlet UIImageView *defaultMoneyIV;
@property (weak, nonatomic) IBOutlet UIImageView *defaultThingIV;
@property (weak, nonatomic) IBOutlet UIImageView *customThumbnailIV;

//action methods
- (IBAction)cancelBtnTap:(id)sender;
- (IBAction)takePhotoBtnTap:(id)sender;

@end

@implementation ThumbnailSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(image)
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
        {
            NSString *filePathRetina = [[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailTemp];
            [UIImagePNGRepresentation([image thumbnail:CGSizeMake(130,130)]) writeToFile:filePathRetina atomically:YES];
        }
        else
        {
            NSString *filePath = [[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailTemp];
            [UIImagePNGRepresentation([image thumbnail:CGSizeMake(65,65)]) writeToFile:filePath atomically:YES];
        }
        
        NSData *customData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailTemp]];
        [self.customThumbnailIV setImage:[UIImage imageWithData:customData]];
        self.customThumbnailName = kThumbnailTemp;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action Methods

- (IBAction)cancelBtnTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takePhotoBtnTap:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        //Alert no camera avail
    }
}

#pragma mark - Private Methods

- (void)customThumbnailIVTap
{
    if ([self.customThumbnailName length] > 0)
    {
        [self.delegateThumbnailSelectionVC thumbnailSelectionViewController:self didSelectThumbnail:self.customThumbnailName];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self takePhotoBtnTap:self.customThumbnailIV];
    }
}

- (void)defaultMoneyIVTap
{
    [self.delegateThumbnailSelectionVC thumbnailSelectionViewController:self didSelectThumbnail:kThumbnailForMoney];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultThingIVTap
{
    [self.delegateThumbnailSelectionVC thumbnailSelectionViewController:self didSelectThumbnail:kThumbnailForThing];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupImages
{
    NSData *moneyData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForMoney]];
    [self.defaultMoneyIV setImage:[UIImage imageWithData:moneyData]];
    NSData *thingData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:kThumbnailForThing]];
    [self.defaultThingIV setImage:[UIImage imageWithData:thingData]];
    
    //load custom one
    if ([[self.dataSourceThumbnailSelectionVC thumbnailNameSelected:self] length] > 0 &&
        ![[self.dataSourceThumbnailSelectionVC thumbnailNameSelected:self] isEqualToString:kThumbnailForMoney] &&
        ![[self.dataSourceThumbnailSelectionVC thumbnailNameSelected:self] isEqualToString:kThumbnailForThing])
    {
        self.customThumbnailName = [self.dataSourceThumbnailSelectionVC thumbnailNameSelected:self];
        NSData *customData = [NSData dataWithContentsOfFile:[[Common thumbnailsDirPath] stringByAppendingPathComponent:self.customThumbnailName]];
        [self.customThumbnailIV setImage:[UIImage imageWithData:customData]];
    }
    else
    {
        //special image "no custom image taken"
    }
    
    //seup tap gestures
    UITapGestureRecognizer *customTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customThumbnailIVTap)];
    [self.customThumbnailIV setUserInteractionEnabled:YES];
    [self.customThumbnailIV addGestureRecognizer:customTap];
    UITapGestureRecognizer *moneyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(defaultMoneyIVTap)];
    [self.defaultMoneyIV setUserInteractionEnabled:YES];
    [self.defaultMoneyIV addGestureRecognizer:moneyTap];
    UITapGestureRecognizer *thingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(defaultThingIVTap)];
    [self.defaultThingIV setUserInteractionEnabled:YES];
    [self.defaultThingIV addGestureRecognizer:thingTap];
}



@end
