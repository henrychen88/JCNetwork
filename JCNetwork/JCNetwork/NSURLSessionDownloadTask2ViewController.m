//
//  NSURLSessionDownloadTask2ViewController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/14.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "NSURLSessionDownloadTask2ViewController.h"

@interface NSURLSessionDownloadTask2ViewController ()
<
NSURLSessionDownloadDelegate
>

@property(nonatomic, strong) UILabel *progressLabel;

@property(nonatomic, strong) UIButton *beginBtn, *suspendBtn, *cancelBtn;

@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, strong) NSURLSessionDownloadTask *task;

@property(nonatomic, strong) NSData *resumeData;

@end

@implementation NSURLSessionDownloadTask2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
}

- (void)setupContent {
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, width, 40)];
    self.progressLabel.font = [UIFont systemFontOfSize:30];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.progressLabel];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginBtn.frame = CGRectMake(0, 150, width, 40);
    [self.beginBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    [self.beginBtn addTarget:self action:@selector(beginDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.beginBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.beginBtn];
    
    self.suspendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.suspendBtn.frame = CGRectMake(0, 250, width, 40);
    [self.suspendBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
    [self.suspendBtn addTarget:self action:@selector(suspendDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.suspendBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.suspendBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(0, 350, width, 40);
    [self.cancelBtn setTitle:@"继续下载" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:self.cancelBtn];
    
}

- (void)beginDownload
{
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    
    self.task = [self.session downloadTaskWithURL:url];
    
    [self.task resume];
}

- (void)suspendDownload
{
    //如果使用suspend来挂起任务，重新启动任务只要使用resume方法即可
//    [self.task suspend];
    
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

- (void)cancelDownload
{
//    [self.task resume];
    
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithResumeData:self.resumeData];
    [task resume];
    
    self.task = task;
    
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", totalBytesWritten * 100.0f / totalBytesExpectedToWrite];
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
