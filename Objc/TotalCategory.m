//
//  NSObject+TotalCategory.m
//  GlassesKong
//
//  Created by LuoHao on 16/10/11.
//  Copyright © 2016 LuoHao. All rights reserved.
//

#import "TotalCategory.h"

#pragma mark -
#pragma mark 数组描述方法
#pragma mark -
@implementation NSArray (Description)
//数组没有对打印本地化中文做处理
//重写数组本地化打印方法即可
- (NSString *)descriptionWithLocale:(id)locale
{
    
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"(\n"];
    
    for (id obj in self) {//self 就是数组本身
        
        [str appendFormat:@"\t%@,\n", obj];//\t是缩进 \n是换行
    }
    
    [str appendString:@")"];
    
    return str;
}
@end



#pragma mark -
#pragma mark 字符串计算大小
#pragma mark -
@implementation NSString (calculateCGSize)
/**
 *  字符串调用此方法,判断字符串的CGSize
 *
 *  @param font   font的属性
 *  @param maxSize 最大值
 *
 *  @return 返回CGSize
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}

/**
 *  字符串调用此方法,传入字体的大小,判断字符串的CGSize
 *
 *  @param  sizeValue 字体的大小
 *  @param maxSize 最大值
 *
 *  @return 返回CGSize
 */
- (CGSize)sizeWithFontSize:(CGFloat)sizeValue maxSize:(CGSize)maxSize
{
    
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:sizeValue]};
    
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dict
                              context:nil].size;
}
@end

#pragma mark -
#pragma mark 字符串编码
#pragma mark -
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (URLString)

- (NSString *)encodingURLStringWith:(NSString *)encodeCharacters {
    
    
    NSString *str = [encodeCharacters stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithContentsOfFile:@""]];
    return str;
}

- (NSString *)decodingURLStringWith:(NSString *)decodeCharacters {
    return [decodeCharacters stringByRemovingPercentEncoding];
}
/**
 *  对字符串采用md5加密
 *
 *  @return 加密的字符串
 */
- (NSString *)md5
{
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return md5String;
}
@end



#import <objc/runtime.h>

#pragma mark -
#pragma mark RunTime_动态方法
#pragma mark -
@implementation NSObject (RumTime_Method)
BOOL method_swizzle(Class klass, SEL origSel, SEL altSel)
{
    if (!klass)
        return NO;
    
    Method __block origMethod, __block altMethod;
    
    void (^find_methods)() = ^
    {
        unsigned methodCount = 0;
        Method *methodList = class_copyMethodList(klass, &methodCount);
        
        origMethod = altMethod = NULL;
        
        if (methodList)
            for (unsigned i = 0; i < methodCount; ++i)
            {
                if (method_getName(methodList[i]) == origSel)
                    origMethod = methodList[i];
                
                if (method_getName(methodList[i]) == altSel)
                    altMethod = methodList[i];
            }
        
        free(methodList);
    };
    
    find_methods();
    
    if (!origMethod)
    {
        origMethod = class_getInstanceMethod(klass, origSel);
        
        if (!origMethod)
            return NO;
        
        if (!class_addMethod(klass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod)))
            return NO;
    }
    
    if (!altMethod)
    {
        altMethod = class_getInstanceMethod(klass, altSel);
        
        if (!altMethod)
            return NO;
        
        if (!class_addMethod(klass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod)))
            return NO;
    }
    
    find_methods();
    
    if (!origMethod || !altMethod)
        return NO;
    
    method_exchangeImplementations(origMethod, altMethod);
    
    return YES;
}

BOOL method_append(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || !selector)
        return NO;
    
    Method method = class_getInstanceMethod(fromClass, selector);
    
    if (!method)
        return NO;
    
    return class_addMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

void method_replace(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || ! selector)
        return;
    
    Method method = class_getInstanceMethod(fromClass, selector);
    
    if (!method)
        return;
    
    class_replaceMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}
+ (void)swizzleMethod:(SEL)originalMethod withMethod:(SEL)newMethod
{
    method_swizzle(self.class, originalMethod, newMethod);
}

+ (BOOL)appendMethod:(SEL)newMethod fromClass:(Class)klass
{
    return method_append(self.class, klass, newMethod);
}

+ (void)replaceMethod:(SEL)method fromClass:(Class)klass
{
    method_replace(self.class, klass, method);
}

- (BOOL)respondsToSelector:(SEL)selector untilClass:(Class)stopClass
{
    return [self.class instancesRespondToSelector:selector untilClass:stopClass];
}

- (BOOL)superRespondsToSelector:(SEL)selector
{
    return [self.superclass instancesRespondToSelector:selector];
}

- (BOOL)superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass
{
    return [self.superclass instancesRespondToSelector:selector untilClass:stopClass];
}

+ (BOOL)instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass
{
    BOOL __block (^ __weak block_self)(Class klass, SEL selector, Class stopClass);
    BOOL (^block)(Class klass, SEL selector, Class stopClass) = [^
                                                                 (Class klass, SEL selector, Class stopClass)
                                                                 {
                                                                     if (!klass || klass == stopClass)
                                                                         return NO;
                                                                     
                                                                     unsigned methodCount = 0;
                                                                     Method *methodList = class_copyMethodList(klass, &methodCount);
                                                                     
                                                                     if (methodList)
                                                                         for (unsigned i = 0; i < methodCount; ++i)
                                                                             if (method_getName(methodList[i]) == selector)
                                                                                 return YES;
                                                                     
                                                                     return block_self(klass.superclass, selector, stopClass);
                                                                 } copy];
    
    block_self = block;
    
    return block(self.class, selector, stopClass);
}

@end

