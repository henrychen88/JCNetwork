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

    [self downloadTask1];
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
    
//    NSURL *url = [NSURL ]
}


@end
