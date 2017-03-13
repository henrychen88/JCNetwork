//
//  NSURLSessionDataTaskController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/13.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "NSURLSessionDataTaskController.h"

@interface NSURLSessionDataTaskController ()
                <
                NSURLSessionDataDelegate
                >

@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, strong) NSURLSessionDataTask *task;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) NSMutableData *data;



@end

@implementation NSURLSessionDataTaskController

- (void)viewDidLoad {
     [super viewDidLoad];
     
     self.data = [NSMutableData new];
     
     self.view.backgroundColor = [UIColor whiteColor];
    
     //delegateQueue如果不设置mainQueue，那么所有的委托方法都会在非主线程执行，如果需要操作UI就得切换到主线程
     self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

     NSString *path = @"http://farm3.staticflickr.com/2846/9823925914_78cd653ac9_b_d.jpg";
     NSURL *url = [NSURL URLWithString:path];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     
     self.task = [_session dataTaskWithRequest:request];
     
     [self.task resume];
     
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //1 不调用这个block将不会收到请求的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    //2 保存下载的数据
    NSLog(@"下载数据 Thread:%@", [NSThread currentThread]);
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //3 下载完成后显示
    NSLog(@"下载完成 Thread:%@", [NSThread currentThread]);
    if (error) {
        NSLog(@"error: %@", error);
    } else {
        self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.data]];
        [self.view addSubview:self.imageV];
    }
}


@end
