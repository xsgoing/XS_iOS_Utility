//
//  XSDatePicker.h
//  乐浪
//
//  Created by 肖胜 on 15/8/15.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^Block)(NSDate *date);

@interface XSDatePicker : UIView

/**
 *  带有确定按钮的时间选择器
 *
 *  @param frame   frame
 *  @param mode    UIDatePickerMode
 *  @param current 当前显示日期
 *  @param max     最大显示日期
 *  @param min     最小时间
 *  @param block   确定按钮回调
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                         Mode:(UIDatePickerMode)mode
                  CurrentDate:(NSDate *)current
                      MaxDate:(NSDate *)max
                      MinDate:(NSDate *)min
                     OKAction:(Block)block;
@property (nonatomic,copy)Block block;
@end