//
//  ViewController.m
//  JCNetwork
//
//  Created by Henry on 2017/3/13.
//  Copyright © 2017年 Henry. All rights reserved.
//

#import "ViewController.h"

#import "NSURLSessionDataTaskController.h"
#import "NSURLSessionDownloadTaskController.h"
#import "NSURLSessionDownloadTask2ViewController.h"
#import "NSURLSessionBackgroundDownloadController.h"
#import "NSURLSessionDataTask2Controller.h"
#import "DownLoadToolController.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title      = @"网络示例";
    self.titles     = @[@"NSURLSessionDataTask",
                        @"NSURLSessionDownloadTask",
                        @"NSURLSessionDownloadTask可暂停",
                        @"NSURLSessionDataTask离线断点",
                        @"JCDownloadTool",
                        @"NSURLSession后台下载"];
    
    NSLog(@"%@", NSTemporaryDirectory());
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    switch (indexPath.row) {
        case 0:
        {
            controller = [NSURLSessionDataTaskController new];
        }
            break;
        case 1:
        {
            controller = [NSURLSessionDownloadTaskController new];
        }
            break;
        case 2:
        {
            controller = [NSURLSessionDownloadTask2ViewController new];
        }
            break;
        case 3:
        {
            controller = [NSURLSessionDataTask2Controller new];
        }
            break;
        case 4:
        {
            controller = [DownLoadToolController new];
        }
            break;
        case 5:
        {
            controller = [NSURLSessionBackgroundDownloadController new];
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
