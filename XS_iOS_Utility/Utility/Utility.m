//
//  Utility.m
//  乐浪
//
//  Created by 肖胜 on 15/8/12.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "Utility.h"
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

@implementation lrcModel

- (id)initWithLrcDic:(NSMutableDictionary *)dic TimeArray:(NSMutableArray *)array {
    
    self = [super init];
    if (self) {
        
        self.lrcDic = dic;
        self.timeArray = array;
    }
    return self;
}

@end

@implementation Utility
//归档
+ (BOOL)archiver:(id)object Path:(NSString *)path forKey:(NSString *)key{
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    BOOL success = [data writeToFile:path atomically:YES];
    return success;
}

// 解档
+ (id)unarchiverWithPath:(NSString *)path forKey:(NSString *)key{
    
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];

    id obj = [unarchiver decodeObjectForKey:key];
    return obj;
}

// 验证手机号
+ (BOOL)isValidateMobile:(NSString *)mobile {
    
       //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];

}

// 验证邮箱号
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 字符串是否包含汉字
+ (BOOL)existChinese:(NSString *)string {

    NSString *phoneRegex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

// 火星坐标系转换
+ (CLLocationCoordinate2D)covertFromMarsCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (![self isLocationOutOfChina:coordinate]) {
        
        CLLocationCoordinate2D adjustLoc;
        
            double adjustLat = [self transformLatWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
            double adjustLon = [self transformLonWithX:coordinate.longitude - 105.0 withY:coordinate.latitude - 35.0];
            double radLat = coordinate.latitude / 180.0 * pi;
            double magic = sin(radLat);
            magic = 1 - ee * magic * magic;
            double sqrtMagic = sqrt(magic);
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
            adjustLoc.latitude = coordinate.latitude + adjustLat;
            adjustLoc.longitude = coordinate.longitude + adjustLon;
        
            return adjustLoc;
    }
    else {
        return coordinate;
    }
}

//判断是不是在中国
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

// 火星坐标纬度转换
+(double)transformLatWithX:(double)x withY:(double)y{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

// 火星坐标经度转换
+(double)transformLonWithX:(double)x withY:(double)y{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

// 数字突出显示
+ (NSMutableAttributedString *)figureHighlightWithAttribute:(NSDictionary *)attribute String:(NSString *)string{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string];
    //1.定义正则表达式
    NSString *regex = @"\\d";
    
    //2.创建正则表达式实现对象
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    //3. expression  查找符合正则表达式的字符串
    NSArray *items = [expression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    //4.循环遍历查找出来的结果
    for (NSTextCheckingResult *result in items) {
        
        //符合表达的字符串的范围
        NSRange range = [result range];
        [attrString addAttributes:attribute range:range];
    }
   
    return attrString;
}

// iso88951转码
+ (NSString *)changeISO88591StringToUnicodeString:(NSString *)iso88591String {
    NSMutableString *srcString = [[NSMutableString alloc]initWithString:iso88591String];
    
    
    
    
    
    [srcString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    
    
    
    [srcString replaceOccurrencesOfString:@"&#x" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    
    
    
    
    
    
    
    NSMutableString *desString = [[NSMutableString alloc]init] ;
    
    
    
    
    
    
    
    NSArray *arr = [srcString componentsSeparatedByString:@";"];
    
    
    
    
    
    
    
    for(int i=0;i<[arr count]-1;i++){
        
        
        
        
        
        
        
        NSString *v = [arr objectAtIndex:i];
        
        
        
        char *c = malloc(3);
        
        
        
        int value = [self changeHexStringToDec:v];
        
        
        
        c[1] = value  &0x00FF;
        
        
        
        c[0] = value >>8 &0x00FF;
        
        
        
        c[2] = '\0';
        
        
        
        [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
        
        
        
        free(c);
        
        
        
    }
    
    
    
    return desString;
}

// 逐个字符转码
+ (int) changeHexStringToDec:(NSString *)strHex{
    
    
    
    int hexLength = (int)[strHex length];
    
    
    
    int  ref = 0;
    
    
    
    for (int j = 0,i = hexLength -1; i >= 0 ;i-- )
        
        
        
    {
        
        
        
        char a = [strHex characterAtIndex:i];
        
        
        
        if (a == 'A') {
            
            
            
            ref += 10*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'B'){
            
            
            
            ref += 11*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'C'){
            
            
            
            ref += 12*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'D'){
            
            
            
            ref += 13*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'E'){
            
            
            
            ref += 14*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == 'F'){
            
            
            
            ref += 15*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '0')
            
            
            
        {
            
            
            
            ref += 0;
            
            
            
        }
        
        
        
        else if(a == '1')
            
            
            
        {
            
            
            
            ref += 1*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '2')
            
            
            
        {
            
            
            
            ref += 2*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '3')
            
            
            
        {
            
            
            
            ref += 3*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '4')
            
            
            
        {
            
            
            
            ref += 4*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '5')
            
            
            
        {
            
            
            
            ref += 5*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '6')
            
            
            
        {
            
            
            
            ref += 6*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '7')
            
            
            
        {
            
            
            
            ref += 7*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '8')
            
            
            
        {
            
            
            
            ref += 8*pow(16,j);
            
            
            
        }
        
        
        
        else if(a == '9')
            
            
            
        {
            
            
            
            ref += 9*pow(16,j);
            
            
            
        }
        
        
        
        j++;
        
        
        
    }
    
    
    
    return ref;
    
    
    
}

// 时间戳转指定格式时间字符串
+ (NSString *)timeintervalToDate:(NSTimeInterval)time Formatter:(NSString *)format {
    
    if (format == nil) {
        
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

// 格式字符串转换成时间
+ (NSDate *)stringToDate:(NSString *)string Formatter:(NSString *)format{
    
    if (format == nil) {
        
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

// 获取日期中详细信息
+ (NSDateComponents *)getDetailInfoWithDate:(NSDate *)date {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday fromDate:date];
    return comps;
}

// 经纬度转换成地理位置
+ (void)locationToAddress:(CLLocation *)location completion:(void (^)(NSArray *, NSError *))block{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        block(placemarks,error);
    }];

}

// 地理位置转换成经纬度
+ (void)addressToLocation:(NSString *)address competion:(void (^)(NSArray *, NSError *))block {
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
       
        block(placemarks,error);
    }];
}

// 根据经纬度计算距离
+ (double)LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2 {
    
    CLLocation *orig = [[CLLocation alloc]initWithLatitude:lat1 longitude:lon1];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:lat2 longitude:lon2];
    CLLocationDistance distance = [orig distanceFromLocation:dest]/1000.f;
    return distance;
}

//16进制颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

// 获取MP3文件的封面图
+ (UIImage *)getImageFromMp3WithFilePath:(NSString *)filePath {
    
    UIImage *img = [[UIImage alloc]init];
    
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    AVURLAsset *mp3Assent = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    NSString *format = [mp3Assent availableMetadataFormats][0];
    for (AVMetadataItem *metadataItem in [mp3Assent metadataForFormat:format]) {
    
        id item = metadataItem.value;
        if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
            
            img = [[UIImage alloc]initWithData:item];
        }
    }
    return img;
}

// 删除数组中重复的值
+ (NSMutableArray *)delRepeatValueFromArray:(NSArray *)array {
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (id obj in array) {
        
        if (![temp containsObject:obj]) {
            [temp addObject:obj];
        }
    }
    return temp;
}

// 将lrc歌词解析成字典
+ (lrcModel *)convertLrcToDictionary:(NSString *)lrc{
    
    // 存放歌词和时间的字典键：时间，值：歌词
    NSMutableDictionary *lrcDic = [NSMutableDictionary dictionary];

    //时间数组
    NSMutableArray *timeArray = [NSMutableArray array];
    
    // 将歌词按行分割
    NSArray *lrcArray = [lrc componentsSeparatedByString:@"\n"];
    for (NSString *lrcString in lrcArray) {
        
//        [00:00][00:01]大雪纷飞
        // 将每一行按“]”分割
        NSArray *singleArray = [lrcString componentsSeparatedByString:@"]"];
        // 临时存放每一行的时间
        NSMutableArray *times = [NSMutableArray array];
        for (int i = 0;i < singleArray.count;i++) {
            
            NSString *item = singleArray[i];
            // 如果是第一部分
            if (i == 0) {
                // 如果是时间标签
                if ([[item substringWithRange:NSMakeRange(3, 1)] isEqualToString:@":"] && item.length <10 && item.length >5) {
                    // 将时间加入临时数组
                    [times addObject:[item substringWithRange:NSMakeRange(1, 5)]];
                }
                else{
                    
                    break;
                }
            }
            // 如果有多个时间标签
            else if (i != singleArray.count-1) {
                
                // 将时间加入临时数组
                [times addObject:[item substringWithRange:NSMakeRange(1, 5)]];
                
            }
            // 如果是最后一部分，即歌词
            else {
                
                for (NSString *time in times) {
                    
                    NSArray *temp = [time componentsSeparatedByString:@":"];
                    // 将时间字符串转化成秒存入
                    [lrcDic setObject:singleArray[i] forKey:@([temp[0] integerValue]*60+[temp[1] integerValue])];
                    [timeArray addObject:@([temp[0] integerValue]*60+[temp[1] integerValue])];
                    // 排序
                    [timeArray sortUsingSelector:@selector(compare:)];
                    // 去掉数组中重复的值
                    timeArray = [Utility delRepeatValueFromArray:timeArray];
                }
            }
            
        }
        
        
    }
    // model中包括歌词时间字典和时间数组
    lrcModel *model = [[lrcModel alloc]initWithLrcDic:lrcDic TimeArray:timeArray];
    return model;
}

// 字符串转字典
+ (NSDictionary *)getDictionaryFromString:(NSString *)string {
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}


// 判断输入框输入过程中是否是合法金钱数额
+ (BOOL)isValidMoney:(UITextField *)textField Range:(NSRange)range replacementString:(NSString *)string{
        
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        
        NSCharacterSet *numbers;
        
        NSRange         pointRange = [textField.text rangeOfString:@"."];
        
        
        
        if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
            
        {
            
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            
        }
        
        else
            
        {
            
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
            
        }
        
        
        
        if ( [textField.text isEqualToString:@""] && [string containsString:@"."] )
            
        {
            
            return NO;
            
        }
        
        
        
        short remain = 2; //默认保留2位小数
        
        
        
        NSString *tempStr = [textField.text stringByAppendingString:string];
        
        NSUInteger strlen = [tempStr length];
        
        if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
            
            if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                
                return NO;
                
            }
            
            if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                
                return NO;
                
            }
            
        }
        
        
        
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        
        if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
            
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                
                textField.text = string;
                
                return NO;
                
            }else{
                
                if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    
                    if([string isEqualToString:@"0"]){
                        
                        return NO;
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        NSString *buffer;
        
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
            
        {
            
            return NO;
            
        }
    
    return YES;
    
}

// 画虚线
+ (UIImageView *)drawDashes:(CGRect)frame {
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:frame];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {1,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);

    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, frame.size.height*0.5);    //开始画线
    CGContextAddLineToPoint(line, frame.size.width, frame.size.height*0.5);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    return imageView1;
}


// 验证身份证
+ (BOOL)isValidateIDCard:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

/**
 *  获取图片某点的颜色
 *
 *  @param point 像素点
 *  @param image 图片
 *
 *  @return 颜色
 */
+ (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)image {
    
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    
    if (cgctx == NULL) { return nil; /* error */ }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    unsigned char* data = CGBitmapContextGetData (cgctx);
    
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,
              blue,alpha);
        
        NSLog(@"x:%f y:%f", point.x, point.y);
        
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(cgctx);
    
    if (data) { free(data); }
    
    return color;
    
}

/**
 *  将cgimage转成bitmap
 *
 *  @param inImage 图片
 *
 *  @return bitmap
 */
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *          bitmapData;
    
    int             bitmapByteCount;
    
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
        
    {
        
        fprintf(stderr, "Error allocating color space\n");
        
        return NULL;
        
    }
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
        
    {
        
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
        
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     
                                     pixelsWide,
                                     
                                     pixelsHigh,
                                     
                                     8,
                                     
                                     bitmapBytesPerRow,
                                     
                                     colorSpace,
                                     
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
        
    {
        
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
        
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
    
}

/**
 *  生成指定内容宽度的二维码
 *
 *  @param string 内容
 *  @param width  宽度
 *
 *  @return 二维码图片
 */
- (UIImage *)createQRCodeWithString:(NSString *)string Width:(CGFloat)width {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outImg = [filter outputImage];
    
    return [self createNonInterpolatedUIImageFormCIImage:outImg withSize:200];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return UIImage
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end


