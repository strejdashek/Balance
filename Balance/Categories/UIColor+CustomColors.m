//
//  UIColor+CustomColors.m
//  Balance
//
//  Created by Viktor Kucera on 10/13/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customRed
{
    return [UIColor colorWithRed:255/255.0f green:69/255.0f blue:63/255.0f alpha:1.0f];
}

+ (UIColor *)customGreen
{
    return [UIColor colorWithRed:64/255.0f green:200/255.0f blue:72/255.0f alpha:1.0f];
}

+ (UIColor *)modalGray
{
    return [UIColor colorWithRed:64/221.0f green:200/221.0f blue:72/221.0f alpha:1.0f];
}

@end
