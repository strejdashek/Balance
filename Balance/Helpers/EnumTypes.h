//
//  EnumTypes.h
//  Balance
//
//  Created by Viktor Kucera on 10/12/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#ifndef Balance_EnumTypes_h
#define Balance_EnumTypes_h

typedef enum ItemsType : NSInteger ItemsType;
enum ItemsType : NSInteger
{
    AssetType,
    LiabilityType
};

typedef enum NewEntryMode : NSInteger NewEntryMode;
enum NewEntryMode : NSInteger
{
    NewEntryNewMode,
    NewEntryEditMode
};

#endif
