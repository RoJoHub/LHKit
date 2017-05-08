//
//  LHUtility_Obj.h
//  GlassesKong
//
//  Created by LuoHao on 16/9/12.
//  Copyright © 2016 LuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LHUtility_Obj : NSObject

#pragma mark -
#pragma mark 定时器
#pragma mark -
+(NSTimer *)returnTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;


#pragma mark -
#pragma mark 本地推送
#pragma mark -

+ (void)registerLocalNotification:(NSInteger)alertTime string:(NSString *)string key:(NSString *)key;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;


#pragma mark -
#pragma mark 得到geojson的数据
#pragma mark -
+ (id)getJsonDataJsonWithName:(NSString *)jsonname;
#pragma mark -
#pragma mark 返回App的当前语言
#pragma mark -
+(NSArray *)currentAppleLanguage;
#pragma mark 判断手机
+ (BOOL)validatePhone:(NSString *)phone;
+(void)versionUpdate:(NSString *)urlString isUpdate:(void(^)(void))isUpdate;

#pragma mark -
#pragma mark 返回外网 IP
#pragma mark -
+(NSString *)deviceWANIPAdress;
@end
