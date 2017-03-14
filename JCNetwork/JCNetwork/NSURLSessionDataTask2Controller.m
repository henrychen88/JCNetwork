//
//  NSURLSessionDataTask2Controller.m
//  JCNetwork
//
//  Created by Henry on 2017/3/14.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "NSURLSessionDataTask2Controller.h"


#define kFileName @"123.mp4"

@interface NSURLSessionDataTask2Controller ()
<
NSURLSessionDataDelegate
>

@property(nonatomic, strong) UILabel *progressLabel;

@property(nonatomic, strong) NSOutputStream *stream;

@property(nonatomic, assign) NSInteger totalSize;

@property(nonatomic, assign) NSInteger currentSize;

@property(nonatomic, strong) UIButton *beginBtn, *suspendBtn, *cancelBtn;

@property(nonatomic, strong) NSURLSessionDataTask *task;

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation NSURLSessionDataTask2Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContent];
    
}

- (void)setupContent
{
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

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSessionDataTask *)task
{
    if (!_task) {
        
        self.currentSize = [self getCurrentS];
        
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}

- (NSInteger)getCurrentS
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kFileName];
    
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSLog(@"%@", fileDict);
    return [fileDict[@"NSFileSize"] integerValue];
}

- (void)beginDownload
{
    [self.task resume];
}

- (void)suspendDownload
{
    [self.task suspend];
}

- (void)cancelDownload
{
    [self.task resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //文件大小
    self.totalSize = response.expectedContentLength + self.currentSize;;
    //拼接文件的全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kFileName];
    NSLog(@"%@", fullPath);
    
    //创建输出流
    self.stream = [[NSOutputStream alloc] initToFileAtPath:fullPath append:YES];
    //打开输出流
    [self.stream open];
    
    //1 不调用这个block将不会收到请求的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];
    
    self.currentSize += data.length;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", _currentSize * 100.0f / _totalSize];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.stream close];
    
    self.stream = nil;
}

- (void)dealloc
{
    [_session invalidateAndCancel];
}

@end
