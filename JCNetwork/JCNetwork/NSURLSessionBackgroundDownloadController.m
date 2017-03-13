//
//  NSURLSessionBackgroundDownloadController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/13.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "NSURLSessionBackgroundDownloadController.h"

@interface NSURLSessionBackgroundDownloadController ()
<
NSURLSessionDelegate,
NSURLSessionDownloadDelegate,
NSURLSessionTaskDelegate,
NSURLSessionDataDelegate
>

@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, strong) NSURLSessionDataTask *task;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) NSMutableData *data;

@end

@implementation NSURLSessionBackgroundDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableData new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"JC"];
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //@"http://dlsw.baidu.com/sw-search-sp/soft/3f/12289/Weibo.4.5.3.37575common_wbupdate.1423811415.exe"
    NSString *path = @"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg";
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _task = [_session dataTaskWithRequest:request];
    
    [_task resume];
    
    NSLog(@"%@", NSTemporaryDirectory());
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"下载数据 Thread:%@", [NSThread currentThread]);
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"下载完成 Thread:%@", [NSThread currentThread]);
    if (error) {
        NSLog(@"error: %@", error);
    } else {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.data]];
        [self.view addSubview:_imageV];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    NSLog(@"下载数据");
    NSLog(@"--------%f", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    NSLog(@"下载完成");
    
    _imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.data]];
    [self.view addSubview:_imageV];
    
}

@end
