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
/**
 *  选择是显示图片
 */
@property(nonatomic,copy)NSString *selectedImg;
/**
 *  选中时字体颜色
 */
@property(nonatomic,strong)UIColor *selectedColor;
@property(nonatomic,assign)BOOL isSelected;
/**
 *  图片下方文字
 *
 *  @param frame      frame
 *  @param title      标题
 *  @param image      图片
 *  @param titlecolor 标题字体颜色
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSString *)image titleColor:(UIColor*)titlecolor;
@end
