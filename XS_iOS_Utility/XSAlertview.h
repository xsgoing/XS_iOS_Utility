//
//  XSAlertview.h
//  XS_iOS_Utility
//
//  Created by 肖胜 on 15/11/9.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSAlertview : UIWindow
+ (id)shareInstance;

+ (void)showWithMessage:(NSString *)message BackGroungColor:(UIColor *)backColor TitleColor:(UIColor *)titleColor;
@end
