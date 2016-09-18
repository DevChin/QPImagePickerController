//
//  QPPreViewCell.h
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPAlbum.h"

@class QPPreViewCell;

@protocol QPPreViewCellDelegate <NSObject>
@optional
- (void)clickImageWithCell:(QPPreViewCell*)cell;
@end

@interface QPPreViewCell : UICollectionViewCell <QPPreViewCellDelegate>
@property (nonatomic,assign)id<QPPreViewCellDelegate> delegate;
@property (nonatomic,retain)QPPhoto* photoModel;
@end
