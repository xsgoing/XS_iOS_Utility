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

- (instancetype)initWithFrame:(CGRect)frame
                         Mode:(UIDatePickerMode)mode
                  CurrentDate:(NSDate *)current
                      MaxDate:(NSDate *)max
                     OKAction:(Block)block;
@property (nonatomic,copy)Block block;
@end
