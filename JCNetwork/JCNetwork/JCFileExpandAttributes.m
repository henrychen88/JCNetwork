//
//  JCFileExpandAttributes.m
//  JCNetwork
//
//  Created by Henry on 2017/3/15.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "JCFileExpandAttributes.h"

#import <sys/xattr.h>

@implementation JCFileExpandAttributes

+ (BOOL)extendsStringValueWithPath:(NSString *)path key:(NSString *)key value:(NSString *)value
{
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    ssize_t writelen = setxattr([path fileSystemRepresentation], [key UTF8String], [data bytes], [data length], 0, 0);
    
    return writelen == 0 ? YES : NO;
}

+ (NSString *)stringValueWithPath:(NSString *)path key:(NSString *)key
{
    ssize_t readlen = 1024;
    
    do {
        char buffer[readlen];
        bzero(buffer, sizeof(buffer));
        size_t leng = sizeof(buffer);
        readlen = getxattr([path fileSystemRepresentation], [key UTF8String], buffer, leng, 0, 0);
        
        if (readlen < 0) {
            return nil;
        } else if (readlen > sizeof(buffer)) {
            continue;
        } else {
            NSData *data = [NSData dataWithBytes:buffer length:readlen];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"result = :%@", result);
            return result;
        }
    } while (YES);
    return nil;
}

@end
