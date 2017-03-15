//
//  JCDownloadTool.m
//  JCNetwork
//
//  Created by Henry on 2017/3/15.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "JCDownloadTool.h"
#import "JCFileExpandAttributes.h"

#define Key_File_Total_Size     @"keyFileTotalSize"

@interface JCDownloadTool ()<NSURLSessionDataDelegate>
//会话
@property(nonatomic, strong) NSURLSession *session;
//任务
@property(nonatomic, strong) NSURLSessionDataTask *task;
//文件全路径
@property(nonatomic, copy) NSString *fullPath;
//进度
@property(nonatomic, copy) ProgressBlock progressBlock;
//总文件大小
@property(nonatomic, assign) NSInteger currentFileSize;
//已下载文件大小
@property(nonatomic, assign) NSInteger totalFileSize;
//输出流
@property(nonatomic, strong) NSOutputStream *stream;

@end

@implementation JCDownloadTool

+ (instancetype)downloadWithURLString:(NSString *)urlString progressBlock:(ProgressBlock)progressBlock
{
    JCDownloadTool *tool = [JCDownloadTool new];
    tool.progressBlock = progressBlock;
    
    [tool getFileSizeWithURLString:urlString];
    [tool crateDownloadSessionTaskWithURLString:urlString];
    
    return tool;
}



- (void)getFileSizeWithURLString:(NSString *)urlString
{
    //文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取文件各个部分
    NSArray *fileComponents = [manager componentsToDisplayForPath:urlString];
    //获取下载之后的文件名
    NSString *fileName = fileComponents.lastObject;
    //根据文件名拼接沙盒全路径
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    
    NSDictionary *attrDict = [manager attributesOfItemAtPath:self.fullPath error:nil];
    NSInteger fileCurrentSize = [attrDict[@"NSFileSize"] integerValue];
    if (fileCurrentSize != 0) {
        //获取文件的总大小
        self.totalFileSize = [[JCFileExpandAttributes stringValueWithPath:self.fullPath key:Key_File_Total_Size] integerValue];
        self.currentFileSize = fileCurrentSize;
        
        self.progressBlock(1.0 * self.currentFileSize / self.totalFileSize);
    }
    
    NSLog(@"%@", self.fullPath);
    NSLog(@"attrDict:%@", attrDict);
}

- (void)crateDownloadSessionTaskWithURLString:(NSString *)urlString
{
    if (self.currentFileSize == self.totalFileSize && self.currentFileSize != 0) {
        //文件已经下载完成
        return;
    }
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentFileSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    self.task = [self.session dataTaskWithRequest:request];
}

- (void)suspendDownload
{
    [self.task suspend];
}

- (void)startDownload
{
    [self.task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSOutputStream *outputStream = [[NSOutputStream alloc]initToFileAtPath:self.fullPath append:YES];
    [outputStream open];
    self.stream = outputStream;
    
    if (self.currentFileSize == 0) {
        self.totalFileSize = response.expectedContentLength;
        NSString *totalSizeString = [NSString stringWithFormat:@"%ld", self.totalFileSize];
        [JCFileExpandAttributes extendsStringValueWithPath:self.fullPath key:Key_File_Total_Size value:totalSizeString];
    }
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];
    
    self.currentFileSize += data.length;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBlock(1.0 * self.currentFileSize / self.totalFileSize);
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.stream close];
    self.stream = nil;
    
    [self.session invalidateAndCancel];
}

@end
