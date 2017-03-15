//
//  JCFileExpandAttributes.h
//  JCNetwork
//
//  Created by Henry on 2017/3/15.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCFileExpandAttributes : NSObject

//为文件增加一个扩展属性，值是字符串
+ (BOOL)extendsStringValueWithPath:(NSString *)path
                               key:(NSString *)key
                             value:(NSString *)value;


//读取文件扩展属性，值是字符串
+ (NSString *)stringValueWithPath:(NSString *)path
                              key:(NSString *)key;

@end
