//
//  XSAddressPicker.m
//  玩械宝
//
//  Created by CaiNiao on 15/7/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "XSAddressPicker.h"

@implementation XSAddressPicker
{
    NSArray *_provinces;
    NSArray *_cities;
    NSArray *_areas;
    NSString *province;
    NSString *city;
    NSString *area;
}

- (instancetype)initWithFrame:(CGRect)frame chooseAction:(choose)actoin
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _loadView];
        [self _loadData];
        _chooseAction = actoin;
    
    }
    return self;
}


- (void)_loadView {
    
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-40)];
    picker.dataSource = self;
    picker.delegate = self;
    [self addSubview:picker];
    
    UIButton *choose = [UIButton buttonWithType:UIButtonTypeCustom];
    choose.frame = CGRectMake(self.frame.size.width*0.1, 10, self.frame.size.width * 0.8, 30);
    [choose setTitle:@"确定" forState:UIControlStateNormal];
    choose.layer.cornerRadius = 5;
    choose.backgroundColor = [UIColor colorWithRed:0.302f green:0.678f blue:1.000f alpha:1.00f];
    [choose addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:choose];
}

- (void)_loadData {
    
    _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
    _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
    
    province = @"北京";
    city = @"通州";
    area = @"";


}

#pragma mark - UIPickerView delegate
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}
// 每列行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return _provinces.count;
            break;
        case 1:
            return _cities.count;
            break;
        case 2:
            return _areas.count;
            break;
        default:
            return 0;
            break;
    }
}

// 标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return [_areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}
// 选中行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            
            _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            province = [[_provinces objectAtIndex:row] objectForKey:@"state"];
            city = [[_cities objectAtIndex:0] objectForKey:@"city"];
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:0];
            } else{
                area = @"";
            }
            break;
        case 1:
            _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            city = [[_cities objectAtIndex:row] objectForKey:@"city"];
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:0];
            } else{
                area = @"";
            }
            break;
        case 2:
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:row];
            } else{
                area = @"";
            }
            break;
        default:
            break;
    }
    
}

- (void)chooseAddress {
    
    if (_chooseAction != nil) {
        
        _chooseAction(province,city,area);
    }
    
}

@end
