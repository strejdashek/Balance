//
//  ThumbnailSelectionViewController.m
//  Balance
//
//  Created by Viktor Kucera on 2/7/15.
//  Copyright (c) 2015 Viktor Kucera. All rights reserved.
//

#import "ThumbnailSelectionViewController.h"
#import "UIImage+Size.h"

@interface ThumbnailSelectionViewController ()

//action methods
- (IBAction)cancelBtnTap:(id)sender;



@end

@implementation ThumbnailSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



    //TAKE PICTURE
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }
//    else
//        NSLog(@"photo not avail");
    
    //SAVE TAKEN PICTURE AS THUMBNAIL
//    UIImage *image = [UIImage imageNamed:@"dollar.jpg"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"thumbnail.png"]; //Add the file name
//    [UIImagePNGRepresentation([image thumbnail]) writeToFile:filePath atomically:YES]; //Write the file

    //DELEGATE
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    if(image)
//    {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
//        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]; //Write the file
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}

#pragma mark - Action Methods

- (IBAction)cancelBtnTap:(id)sender
{
//    UIImage *image = [UIImage imageNamed:@"Blur-Background.jpg"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"defaultThing.png"]; //Add the file name
//    [UIImagePNGRepresentation([image thumbnail:CGSizeMake(65,65)]) writeToFile:filePath atomically:YES]; //Write the file
//    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
