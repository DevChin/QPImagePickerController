//
//  QPToolBar.m
//  KPImagePickerController
//
//  Created by mentongCS on 16/9/16.
//  Copyright © 2016年 MengTong. All rights reserved.
//

#import "QPToolBar.h"

@interface QPToolBar ()
{
    UIButton* _previewButton;  // look
    UIButton* _countButton; //the count button to display count
    UIButton* _doneButton;  //done button
    
    UIView* _maskView; // show when the selectCount is zero
}
@end

@implementation QPToolBar

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor redColor];
        [self addSubViews];
    
    }
    return self;
}

#pragma mark setUpContentViews

- (void)addSubViews
{
    
    _previewButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.frame=CGRectMake(0,0,50,self.frame.size.height);
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton addTarget:self action:@selector(look) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previewButton];
    
    _countButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _countButton.frame=CGRectMake(self.frame.size.width-64,10,24,24);
    _countButton.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [_countButton setBackgroundImage:[UIImage imageNamed:@"photo_number_icon"] forState:UIControlStateNormal];
    _countButton.hidden=YES;
    [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_countButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_countButton];
    
    _doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame=CGRectMake(self.frame.size.width-50,0,50,44);
    _doneButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_doneButton];
    
    CALayer* line = [[CALayer alloc] init];
    line.frame=CGRectMake(0,0,self.frame.size.width,0.5);
    line.backgroundColor=[UIColor colorWithRed:239/255.0 green:240/255.0 blue:241/255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:line];
}

#pragma mark setters

- (void)setSelectedCount:(NSInteger)selectedCount
{
    _selectedCount=selectedCount;
    
    if (_selectedCount == 0)
    {
        _countButton.hidden=YES;
        _previewButton.enabled=NO;
        _doneButton.enabled=NO;
        return;
    }
    _previewButton.enabled=YES;
    _doneButton.enabled=YES;
    _countButton.hidden=NO;
    [_countButton setTitle:[NSString stringWithFormat:@"%ld",(long)_selectedCount] forState:UIControlStateNormal];
    [_countButton.imageView.layer setValue:@(0.1) forKeyPath:@"transform.scale"];
    [UIView animateWithDuration:0.15 delay:0.0f options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [_countButton.layer setValue:@(1.15) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState |UIViewAnimationOptionCurveEaseInOut animations:^{
                [_countButton.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [_countButton.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                    } completion:nil];
                }
            }];
        }
    }];
}

- (void)look {
    if (_delegate && [_delegate respondsToSelector:@selector(lookAtPhotos)])
        [_delegate lookAtPhotos];
}

- (void)done {
    if (_delegate && [_delegate respondsToSelector:@selector(selectDone)])
        [_delegate selectDone];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
