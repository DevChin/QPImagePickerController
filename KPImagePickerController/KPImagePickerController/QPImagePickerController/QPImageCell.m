//
//  QPImageCell.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPImageCell.h"
#import "QPImagePickerDataSourceManager.h"

@implementation QPImageCell

- (id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self addSubview:[self imageView]];
        [self addSubview:[self statusButton]];
    }
    return self;
}

#pragma mark - addSubViews

#pragma mark - lazy load

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView=[[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor=[UIColor whiteColor];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton*)statusButton{
    if (!_statusButton) {
        _statusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.frame=CGRectMake(self.contentView.bounds.size.width-40,0,40,40);
        [_statusButton setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        [_statusButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_statusButton];
    }
    return _statusButton;
}

#pragma mark setters

- (void)setImage:(UIImage *)image
{
    _image=image;
    _imageView.image=image;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected=isSelected;
    _statusButton.selected=_isSelected;
    if (_statusButton.selected) {
        [UIView animateWithDuration:0.15 delay:0.0f options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [_statusButton.layer setValue:@(1.15) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_statusButton.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                    if (finished) {
                        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [_statusButton.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                        } completion:nil];
                    }
                }];
            }
        }];
    }
}


- (void)setModel:(QPPhoto *)model
{
    _model=model;
    [[QPImagePickerDataSourceManager sharedInstance] requestThumbnailImageWithAsset:_model.imageAsset andThumbnailSize:self.contentView.bounds.size andCompletionHandle:^(UIImage *result, NSDictionary *info) {
        if (result)
            _imageView.image=result;
    }];
    _isSelected=model.selected;
    _statusButton.selected=_isSelected;
}

- (void)selectImage{
    if (_delegate && [_delegate respondsToSelector:@selector(selectImageWithCell:)])
        [_delegate selectImageWithCell:self];
}

@end

