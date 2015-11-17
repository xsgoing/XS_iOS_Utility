//
//  ChooseTableView.m
//  MasonryExe
//
//  Created by 肖胜 on 15/11/17.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "ChooseTableView.h"
#import "UIView+EXT.h"
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CELLHEIGHT 35.0
@implementation ChooseTableView
UITableView *_tableView;

- (instancetype)initWithDataSource:(NSArray *)data ChildType:(ChildDataType)type Key:(NSString *)key{
    
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
        _data = data;
        _type = type;
        _key = key;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH*0.2, 80, KSCREEN_WIDTH*0.6, (_data.count * CELLHEIGHT) < (KSCREEN_HEIGHT-160)?(_data.count*CELLHEIGHT):(KSCREEN_HEIGHT-160))];
        _tableView.y = (KSCREEN_HEIGHT-_tableView.frame.size.height)/2.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 6;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
        
    }
    return self;
}

// 将被添加到父视图
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (newSuperview != nil) {
    
        [self addSubview:_tableView];
        _tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:.4 animations:^{
            
            _tableView.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self remove];
}

// 移除
- (void)remove {
    
    [UIView animateWithDuration:.4 animations:^{
       
        _tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        
        [_tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    if (_type == String) {
        
        cell.textLabel.text = _data[indexPath.row];
    }
    else if (_type == Dictionary){
        
        cell.textLabel.text = _data[indexPath.row][_key];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_block) {
        
        _block(indexPath);
    }
    [self remove];
}


@end
