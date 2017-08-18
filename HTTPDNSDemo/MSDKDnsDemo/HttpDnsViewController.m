//
//  HttpDnsViewController.m
//  MSDKDnsDevDemo
//
//  Created by Gavin on 2016-07-08.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "HttpDnsViewController.h"
#import <MSDKDns/MSDKDns.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface HttpDnsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Domain;

@end

@implementation HttpDnsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)getHostByName:(id)sender{
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSString *domain = [_Domain text];
    if (domain.length > 0)
    {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        NSArray* result = [[MSDKDns sharedInstance] WGGetHostByName:domain];
        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
        NSLog(@"本次耗时1：%f", (time2 - time1) * 1000);
        if (result && result.count > 1) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\nIPV4地址为：%@\nIPV6地址为：%@\n",result[0], result[1]];
            [self setIpv4:result[0]];
            [self setIpv6:result[1]];
            [_resultTextView insertText:str];
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        }
    }
}
- (IBAction)getHostByNameAsync:(id)sender {
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSString *domain = [_Domain text];
    if (domain.length > 0)
    {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        [[MSDKDns sharedInstance] WGGetHostByNameAsync:domain returnIps:^(NSArray *ipsArray) {
            NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
            NSLog(@"本次耗时2：%f", (time2 - time1) * 1000);
            if (ipsArray && ipsArray.count > 1) {
                NSString* str = [NSString stringWithFormat:@"\n解析结果为：\nIPV4地址为：%@\nIPV6地址为：%@\n",ipsArray[0], ipsArray[1]];
                [self setIpv4:ipsArray[0]];
                [self setIpv6:ipsArray[1]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:str];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
                });
            }
        }];
    }
}

@end
