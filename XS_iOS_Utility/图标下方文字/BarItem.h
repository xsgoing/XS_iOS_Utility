//
//  BarItem.h
//  玩械宝
//
//  Created by CaiNiao on 15/6/11.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarItem : UIControl

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *selectedImg;
@property(nonatomic,strong)UIColor *selectedColor;
@property(nonatomic,assign)BOOL isSelected;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image titleColor:(UIColor*)titlecolor;
@end
