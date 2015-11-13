//
//  Utility.h
//  乐浪
//
//  Created by 肖胜 on 15/8/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

@interface lrcModel : NSObject

@property (nonatomic,strong)NSMutableDictionary *lrcDic;
@property (nonatomic,strong)NSMutableArray *timeArray;
- initWithLrcDic:(NSMutableDictionary *)dic TimeArray:(NSMutableArray *)array;

@end

@interface Utility : NSObject

/**
*  自定义对象归档
*
*  @param object 自定义对象
*  @param path   归档文件存放路径
*  @param key    通过key取值
*
*  @return 是否归档成功
*/
+ (BOOL)archiver:(id)object Path:(NSString *)path forKey:(NSString *)key;


/**
 *  自定义对象解档
 *
 *  @param path 文件路径
 *  @param key  通过key取值
 *
 *  @return 返回自定义对象
 */
+ (id)unarchiverWithPath:(NSString *)path forKey:(NSString *)key;

/**
 *  判断手机号
 *
 *  @param mobile 手机号码
 *
 *  @return 是否是手机号
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  判断邮箱号
 *
 *  @param email 邮箱账号
 *
 *  @return 是否合法
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  判断是否包含汉字
 *
 *  @param string 要判断的字符串
 *
 *  @return 是否包含汉字
 */
+ (BOOL)existChinese:(NSString *)string;

/**
 *  火星坐标系转换
 *
 *  @param coordinate 偏移的坐标系
 *
 *  @return 正常坐标
 */
+ (CLLocationCoordinate2D)covertFromMarsCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 *  数字突出显示的字符串
 *
 *  @param attribute 数字显示的属性
 *
 *  @return 转换好的属性字符串
 */
+ (NSMutableAttributedString *)figureHighlightWithAttribute:(NSDictionary *)attribute String:(NSString *)string;

/**
 *  iso88591转码
 *
 *  @param iso88591String iso88591码
 *
 *  @return 标准字符串
 */
+ (NSString *) changeISO88591StringToUnicodeString:(NSString *)iso88591String;

/**
 *  时间戳转指定格式时间字符串
 *
 *  @param time   时间戳
 *  @param format 时间格式
 *
 *  @return 格式字符串
 */
+ (NSString *)timeintervalToDate:(NSTimeInterval)time Formatter:(NSString *)format;

/**
 *  格式字符串转换成时间
 *
 *  @param string 格式字符串
 *  @param format 时间格式
 *  @return 时间
 */
+ (NSDate *)stringToDate:(NSString *)string Formatter:(NSString *)format;

/**
 *  获取日期中的详细信息
 *
 *  @param date 日期
 *
 *  @return 详细信息
 */
+ (NSDateComponents *)getDetailInfoWithDate:(NSDate *)date;

/**
 *  经纬度转换成地理位置
 *
 *  @param location 经纬度
 *  @param block    返回数据或错误
 */
+ (void)locationToAddress:(CLLocation *)location
               completion:(void(^)(NSArray *placemarks, NSError *error))block;

/**
 *  地理位置转换成经纬度
 *
 *  @param address 地理位置
 *  @param block   返回数据或错误
 */
+ (void)addressToLocation:(NSString *)address
                competion:(void(^)(NSArray *placemarks, NSError *error))block;

/**
 *  根据经纬度计算距离
 *
 *  @param lon1 起点经度
 *  @param lat1 起点纬度
 *  @param lon2 终点经度
 *  @param lat2 终点纬度
 *
 *  @return 距离/km
 */
+ (double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

/**
 *  16进制转换成UIColor
 *
 *  @param color 16进制字符
 *
 *  @return 转换后的UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  获取MP3文件中的封面缩略图
 *
 *  @param filePath 文件路径
 *
 *  @return     封面缩略图
 */
+ (UIImage *)getImageFromMp3WithFilePath:(NSString *)filePath;

/**
 *  删除数组中重复的值
 *
 *  @param array 原数组
 *
 *  @return 返回的数组
 */
+ (NSMutableArray *)delRepeatValueFromArray:(NSArray *)array;

/**
 *  将lrc歌词解析成字典
 *
 *  @param lrc lrc字符串
 *
 *  @return lrc字典：键-值：时间-歌词
 */
+ (lrcModel *)convertLrcToDictionary:(NSString *)lrc;

/**
 *  字符串转字典
 *
 *  @param string 字符串
 *
 *  @return 自定
 */
+ (NSDictionary *)getDictionaryFromString:(NSString *)string;

/**
 *  判断输入框输入过程中是否是合法金钱数额
 *
 *  @param textField 文本框
 *  @param range     文本返回
 *  @param string    新文本
 *
 *  @return 是否合法
 */
+ (BOOL)isValidMoney:(UITextField *)textField Range:(NSRange)range replacementString:(NSString *)string;

/**
 *  画虚线
 *
 *  @param frame 虚线位置
 *
 *  @return 虚线
 */
+ (UIImageView *)drawDashes:(CGRect)frame;

/**
 *  验证身份证号
 *
 *  @param value 字符串
 *
 *  @return 是否身份证
 */
+ (BOOL)isValidateIDCard:(NSString *)value;

/**
 *  获取图片某点的颜色
 *
 *  @param point 像素点
 *  @param image 图片
 *
 *  @return 颜色
 */
+ (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image;

/**
 *  生成指定内容宽度的二维码
 *
 *  @param string 内容
 *  @param width  宽度
 *
 *  @return 二维码图片
 */
- (UIImage *)createQRCodeWithString:(NSString *)string Width:(CGFloat)width;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return UIImage
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
@end
