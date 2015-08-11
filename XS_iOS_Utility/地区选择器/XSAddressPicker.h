//
//  XSAddressPicker.h
//  玩械宝
//
//  Created by CaiNiao on 15/7/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^choose)(NSString *province,NSString *city,NSString *area);
@interface XSAddressPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,copy)choose chooseAction;
- (void)setChooseAction:(choose)chooseAction;
/**
 *  地区选择
 *
 *  @param frame  位置
 *  @param actoin 确定按钮回调
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame chooseAction:(choose)actoin;
@end
