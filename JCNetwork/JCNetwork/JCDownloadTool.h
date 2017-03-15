//
//  JCDownloadTool.h
//  JCNetwork
//
//  Created by Henry on 2017/3/15.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock) (float progress);

@interface JCDownloadTool : NSObject

+ (instancetype)downloadWithURLString:(NSString *)urlString
                        progressBlock:(ProgressBlock)progressBlock;

- (void)startDownload;

- (void)suspendDownload;

@end
