//
//  NSObject+TotalCategory.h
//  GlassesKong
//
//  Created by LuoHao on 16/10/11.
//  Copyright © 2016 LuoHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark 数组描述方法
#pragma mark -
@interface NSArray (Description)
- (NSString *)descriptionWithLocale:(id)locale;
@end



#pragma mark -
#pragma mark 字符串计算大小
#pragma mark -
@interface NSString (calculateCGSize)
/**
 *  字符串调用此方法,传入字体的属性,判断字符串的CGSize
 *
 *  @param font   font的属性
 *  @param maxSize 最大值
 *
 *  @return 返回CGSize
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 *  字符串调用此方法,传入字体的大小,判断字符串的CGSize
 *
 *  @param  sizeValue 字体的大小
 *  @param maxSize 最大值
 *
 *  @return 返回CGSize
 */
- (CGSize)sizeWithFontSize:(CGFloat )sizeValue maxSize:(CGSize)maxSize;
@end



#pragma mark -
#pragma mark 字符串编码
#pragma mark -
@interface NSString (Coding)

/**
 *  对url字符串进行特殊字符编码
 *
 *  @param encodeCharacters 要编码的字符集
 *
 *  @return 编码后的字符集
 */
- (NSString *)encodingURLStringWith:(NSString *)encodeCharacters;

/**
 *  对特殊字符集编码后的字符串进行解码
 *
 *  @param decodeCharacters <#decodeCharacters description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)decodingURLStringWith:(NSString *)decodeCharacters;

-(NSString *)md5;
@end


#pragma mark -
#pragma mark RunTime_动态方法
#pragma mark -
@interface NSObject (RumTime_Method)

/**
 *  动态替换方法
 */
+ (void)swizzleMethod:(SEL)originalMethod withMethod:(SEL)newMethod;

/**
 *  动态为某个类添加方法
 */
+ (BOOL)appendMethod:(SEL)newMethod fromClass:(Class)klass;

/**
 *  动态为某个类替换方法
 */
+ (void)replaceMethod:(SEL)method fromClass:(Class)klass;

/**
 Check whether the receiver implements or inherits a specified method up to and exluding a particular class in hierarchy.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)respondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether a superclass implements or inherits a specified method.
 
 @param selector A selector that identifies a method.
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)superRespondsToSelector:(SEL)selector;

/**
 Check whether a superclass implements or inherits a specified method.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether the receiver's instances implement or inherit a specified method up to and exluding a particular class in hierarchy.
 
 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
+ (BOOL)instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass;
@end
