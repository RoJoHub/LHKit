//
//  LHUtility_Obj.m
//  GlassesKong
//
//  Created by LuoHao on 16/9/12.
//  Copyright © 2016 LuoHao. All rights reserved.
//

#import "LHUtility_Obj.h"

//判断手机空间是否足够
#import <sys/param.h>
#import <sys/mount.h>
#import <objc/runtime.h>

@implementation LHUtility_Obj

#pragma mark -
#pragma mark 定时器
#pragma mark -
+(NSTimer *)returnTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return timer;
}




#pragma mark -
#pragma mark 本地推送
#pragma mark -

+ (void)registerLocalNotification:(NSInteger)alertTime string:(NSString *)string key:(NSString *)key{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    //需要使用时间戳
    //    NSDate *fireDate = [NSDate dateWithTimeIntervalSince1970:alertTime];
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    NSLog(@"fireDate=%@",fireDate);
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = 1;//0表示不重复
    // 通知内容
    notification.alertBody =  string;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:string forKey:key];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        //        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        //        notification.repeatInterval = NSDayCalendarUnit; //ios7使用
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}





#pragma mark -
#pragma mark 得到geojson的数据
#pragma mark -
+ (id)getJsonDataJsonWithName:(NSString *)jsonname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@"geojson"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        NSLog(@"%s: JSON解码失败",__func__);
        return nil;
    } else {
        return jsonObj;
    }
}
#pragma mark -
#pragma mark 返回App的当前语言
#pragma mark -
+(NSArray *)currentAppleLanguage{
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置,第一位是
    
    /*
     zh-Hans-CN,
     en-CN,
     */
    
    return [defaults objectForKey : @"AppleLanguages" ];
}


#pragma mark 判断手机
+ (BOOL)validatePhone:(NSString *)phone {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188 (147,178)
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[2-478])\\d)\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,176,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[56]|76|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,153,173,177,180,181,189
     */
    NSString * CT = @"^1((33|53|7[39]|8[019])[0-9]|349)\\d{7}$";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}






+(void)versionUpdate:(NSString *)urlString isUpdate:(void(^)(void))isUpdate{
    
    
//    [LHUtility POST_Connect:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    
        NSArray *array =nil;
//    NSArray *array = responseObject[@"results"];
    NSDictionary *dict = [array lastObject];
    NSString *New_Version=dict[@"version"];
    NSString *oldVersion= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (New_Version && ([New_Version compare:oldVersion] == 1)) {
        NSLog(@"有新版本");
        if (isUpdate) {
            isUpdate();
        }
    }

}


#pragma mark -
#pragma mark 返回外网 IP
#pragma mark -
+(NSString *)deviceWANIPAdress

{
    
    NSError *error;
    
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    //判断返回字符串是否为所需数据
    
    if ([ip hasPrefix:@"var returnCitySN = "])
        
    {
        
        //对字符串进行处理，然后进行json解析
        
        //删除字符串多余字符串
        
        NSRange range = NSMakeRange(0, 19);
        
        [ip deleteCharactersInRange:range];
        
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        
        //将字符串转换成二进制进行Json解析
        
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        return dict[@"cip"];
        
    }
    return @"114.114.114.114";
}
@end
