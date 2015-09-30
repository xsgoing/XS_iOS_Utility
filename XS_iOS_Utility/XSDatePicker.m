

//
//  XSDatePicker.m
//  乐浪
//
//  Created by 肖胜 on 15/8/15.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "XSDatePicker.h"

@implementation XSDatePicker{
    
    UIDatePicker *picker;
}

// xs自定义时间选择
- (instancetype)initWithFrame:(CGRect)frame Mode:(UIDatePickerMode)mode CurrentDate:(NSDate *)current MaxDate:(NSDate *)max MinDate:(NSDate *)min OKAction:(Block)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat height = self.frame.size.height *0.2;
        if (height>35) {
            height = 35;
        }
        confirm.frame = CGRectMake(self.frame.size.width*0.1, 5, self.frame.size.width*0.8, height);
        confirm.layer.cornerRadius = 6;
        confirm.backgroundColor = [UIColor colorWithRed:0.000f green:0.592f blue:0.984f alpha:1.00f];
        [confirm setTitle:@"确定" forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(confirmTime) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (current == nil) {
            
            current = [NSDate dateWithTimeIntervalSince1970:0];
        }
        picker.date = current;
        
        mode = UIDatePickerModeDate;
        picker.datePickerMode = mode;
        
        if (max != nil) {
            
            picker.maximumDate = max;
        }
        if (min != nil) {
            
            picker.minimumDate = min;
        }
        picker.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self insertSubview:picker belowSubview:confirm];
        
        _block = block;
    }
    return self;
}

- (void)confirmTime {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    _block(picker.date);
}
@end