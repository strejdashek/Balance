//
//  UIImage+Size.m
//  Balance
//
//  Created by Viktor Kucera on 2/6/15.
//  Copyright (c) 2015 Viktor Kucera. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

- (UIImage *)thumbnail:(CGSize)size
{
    UIImage *thumbnail;
    
    //crop the biggest cube we can
    CGFloat heightOriginal = self.size.height;
    CGFloat widthOriginal = self.size.width;
    if (heightOriginal > widthOriginal)
    {
        CGFloat cropY = (heightOriginal - widthOriginal) / 2;
        CGRect requestedCrop = CGRectMake(0, cropY, widthOriginal, widthOriginal);
        thumbnail = [self crop:requestedCrop];
    }
    else
    {
        CGFloat cropX = (widthOriginal - heightOriginal) / 2;
        CGRect requestedCrop = CGRectMake(cropX, 0, heightOriginal, heightOriginal);
        thumbnail = [self crop:requestedCrop];
    }
    
    //scale it to have it 65x65
    thumbnail = [UIImage imageWithImage:thumbnail scaledToSize:size];
    
    //make it circle
    thumbnail = [UIImage circleImageWithImage:thumbnail];
    
    return thumbnail;
}

#pragma mark - Private Methods

- (UIImage *)crop:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)circleImageWithImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:(imageView.frame.size.width / 2)] addClip];
    [image drawInRect:imageView.bounds];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageView.image;
}

@end
