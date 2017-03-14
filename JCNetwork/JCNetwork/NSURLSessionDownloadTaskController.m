//
//  NSURLSessionDownloadTaskController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/13.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "NSURLSessionDownloadTaskController.h"

@interface NSURLSessionDownloadTaskController ()
                <
                NSURLSessionDownloadDelegate
                >

@property(nonatomic, strong) UIImageView *imageV;

@end

@implementation NSURLSessionDownloadTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self downloadTask2];
}

//使用block来处理请求结果
- (void)downloadTask1
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg"];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"complete");
        //下载的文件是保存在tmp目录下
        NSData *data = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
            [self.view addSubview:self.imageV];
        });
        
    }];
    
    [task resume];
}

//使用委托方法来处理请求过程和结果
- (void)downloadTask2
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    
    [task resume];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"----%.2f%%", totalBytesWritten * 100.0f / totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"didFinishDownloadingToURL");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error) {
        NSLog(@"error: %@", error);
    } else {
        NSLog(@"Complete");
    }
}


@end
