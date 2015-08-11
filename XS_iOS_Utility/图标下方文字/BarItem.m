//
//  BarItem.m
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "BarItem.h"

@implementation BarItem
{
    UIImageView *imageView;
    UILabel *titleLabel;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    
    _selectedColor = selectedColor;
}

- (void)setSelectedImg:(NSString *)selectedImg {
    
    _selectedImg = selectedImg;
}

- (void)setIsSelected:(BOOL)isSelected {
    
    if (isSelected) {
        
        titleLabel.textColor = _selectedColor;
        imageView.image = [UIImage imageNamed:_selectedImg];
        
    }
    else {
        
        titleLabel.textColor = [UIColor blackColor];
        imageView.image = [UIImage imageNamed:_image];
    }
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image titleColor:(UIColor *)titlecolor{
    self = [super initWithFrame:frame];
    if (self) {
        _titleColor = titlecolor;
        _title = title;
        _image = image;
        [self _loadSubViews];

    }
    return self;
}

- (void)_loadSubViews {
    
    // 图标
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.05, self.frame.size.width, self.frame.size.height*0.5)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:_image];
    [self addSubview:imageView];
    
    // 标题
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.4)];
    titleLabel.text = _title;
    titleLabel.textColor = _titleColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}

@end
