//
//  ChooseTableView.h
//  MasonryExe
//
//  Created by 肖胜 on 15/11/17.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    Dictionary = 0,
    String = 1,
} ChildDataType;

@interface ChooseTableView : UIView<UITableViewDataSource,UITableViewDelegate>
/**
 *  数据源
 */
@property (nonatomic,strong)NSArray *data;
/**
 *  数组中子数据类型
 */
@property (nonatomic,assign)ChildDataType type;

/**
 *  如果单元格数据是字典，字典取值的键
 */
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)void(^block)(NSIndexPath *);
- (instancetype)initWithDataSource:(NSArray *)data ChildType:(ChildDataType)type Key:(NSString *)key;
@end
