//
//  ItemCollectionViewCell.h
//  Balance
//
//  Created by Viktor Kucera on 9/28/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *personLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *personPhotoIV;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIV;

@end
