//
//  ThumbnailSelectionViewController.h
//  Balance
//
//  Created by Viktor Kucera on 2/7/15.
//  Copyright (c) 2015 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThumbnailSelectionViewController;

@protocol ThumbnailSelectionVCDelegate<NSObject>
@required
- (void)thumbnailSelectionViewController:(ThumbnailSelectionViewController *)thumbnailSelectionVC didSelectThumbnail:(NSString *)thumbnailName;
@end

@protocol ThumbnailSelectionVCDataSource<NSObject>
@required
- (NSString *)thumbnailNameSelected:(ThumbnailSelectionViewController *)thumbnailSelectionVC;
@end

@interface ThumbnailSelectionViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id<ThumbnailSelectionVCDelegate> delegateThumbnailSelectionVC;
@property (nonatomic, weak) id<ThumbnailSelectionVCDataSource> dataSourceThumbnailSelectionVC;

@end
