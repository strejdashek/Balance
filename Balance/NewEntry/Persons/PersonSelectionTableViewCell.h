//
//  PersonSelectionTableViewCell.h
//  Balance
//
//  Created by Viktor Kucera on 12/2/14.
//  Copyright (c) 2014 Viktor Kucera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSelectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *personNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *personFaceIV;

@end
