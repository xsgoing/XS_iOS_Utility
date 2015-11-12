//
//  ViewController.m
//  XS_iOS_Utility
//
//  Created by 肖胜 on 15/8/11.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ViewController.h"
#import "DataService.h"
#import "ZoomImageView.h"
#import "XSAddressPicker.h"
#import "BarItem.h"
#import "Utility.h"
#import "XSDatePicker.h"
#import "XSProgress.h"
#import "XSAlertview.h"
@interface ViewController ()
{
    UILabel *address;
    XSAlertview *alertView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    address = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 200, 20)];
    address.text = @"选择城市";
    [self.view addSubview:address];
    
    // 网络请求
//    [DataService requestURL:@"https://github.com" httpMethod:@"POST" timeout:1 params:nil responseSerializer:[AFHTTPResponseSerializer serializer] completion:^(id result, NSError *error) {
//        NSLog(@"%@%@",result,error);
//    }];
    
    
    // 点击小图显示大图
    ZoomImageView *zoom = [[ZoomImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    zoom.userInteractionEnabled = YES;
    zoom.image = [UIImage imageNamed:@"胡巴.jpg"];
    zoom.urlString = @"http://cdn.duitang.com/uploads/item/201507/22/20150722123833_U5hmZ.thumb.700_0.jpeg";
    [self.view addSubview:zoom];
    
    
    // 地区选择器
    XSAddressPicker *picker = [[XSAddressPicker alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 200) chooseAction:^(NSString *province, NSString *city, NSString *area) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            address.text = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        });
    }];
    [self.view addSubview:picker];
    
    // 图片下方文字，适用于tabbar
    BarItem *item = [[BarItem alloc]initWithFrame:CGRectMake(4, self.view.frame.size.height-80, 80, 80) title:@"xsgoing" image:@"胡巴.jpg" titleColor:[UIColor blackColor]];
    [self.view addSubview:item];
    
    // 判断是否包含汉字
    [Utility existChinese:@"我就是我"];
    
    // 时间选择
    XSDatePicker *datePicker = [[XSDatePicker alloc]initWithFrame:self.view.bounds Mode:UIDatePickerModeDate CurrentDate:nil MaxDate:nil MinDate:nil  OKAction:^(NSDate *date) {
        
    }];
    [self.view addSubview:datePicker];
    
    
    
     [XSProgress show];
    
    [self performSelector:@selector(hideit) withObject:nil afterDelay:5];
}

- (void)hideit {
    
    [XSProgress hide];
    
    [self performSelector:@selector(showit) withObject:nil afterDelay:3];
}

- (void)showit {
    
    [XSProgress show];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//        
//    [XSAlertview showWithMessage:@"系统故障" BackGroungColor:nil TitleColor:nil];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

