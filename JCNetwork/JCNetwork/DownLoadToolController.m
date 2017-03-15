//
//  DownLoadToolController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/15.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "DownLoadToolController.h"

#import "JCDownloadTool.h"

@interface DownLoadToolController ()

@property(nonatomic, strong) UILabel *progressLabel;

@property(nonatomic, strong) UIButton *beginBtn, *suspendBtn;

@property(nonatomic, strong) JCDownloadTool *downloadTool;

@end

@implementation DownLoadToolController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContent];
    
    self.downloadTool = [JCDownloadTool downloadWithURLString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" progressBlock:^(float progress) {
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
    }];
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

}

- (void)beginDownload
{
    
    [self.downloadTool startDownload];
}

- (void)suspendDownload
{
    [self.downloadTool suspendDownload];
}

@end
