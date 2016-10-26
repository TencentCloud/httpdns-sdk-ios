//
//  HttpDnsViewController.m
//  MSDKDnsDevDemo
//
//  Created by Gavin on 2016-07-08.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "ViewController.h"

#import <MSDKDns/MSDKDns.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Domain;

@end

@implementation ViewController

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
        std::vector<unsigned char*> result =
        MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain UTF8String]);
        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
        NSLog(@"本次耗时：%f", (time2 - time1) * 1000);
        if (result.size() > 1) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\nIPV4地址为：%@\nIPV6地址为：%@\n",[NSString stringWithUTF8String:(const char*)result[0]], [NSString stringWithUTF8String:(const char*)result[1]]];
            [self setIpv4:[NSString stringWithUTF8String:(const char*)result[0]]];
            [self setIpv6:[NSString stringWithUTF8String:(const char*)result[1]]];
            [_resultTextView insertText:str];
            [_resultTextView insertText:[NSString stringWithFormat:@"本次耗时：%.0fms\n", (time2 - time1) * 1000]];
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        }
    }
}

#pragma mark - Run DNS Test
-(void)runDnsOnMainThread{
    NSString *domain = @"www.qq.com";
    if (domain.length > 0)
    {
        std::vector<unsigned char*> result =
        MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain UTF8String]);
        NSMutableString *ipsStr = [NSMutableString stringWithString:@""];
        for (int i = 0; i < result.size(); i++)
        {
            NSString *ip = [NSString stringWithUTF8String:(const char*)result[i]];
            [ipsStr appendFormat:@"%@,",ip];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            self.resultTextView.text = [NSString stringWithFormat:@"Dns Result: \n %@", ipsStr];
        });
        
    }
}

-(void)runDnsOnNewThread{
    [self performSelectorInBackground:@selector(testMSDKDnsCallOnOtherThread) withObject:nil];
}

- (void)testMSDKDnsCallOnOtherThread
{
    NSString *domain = @"www.qq.com";
    if (domain.length > 0)
    {
        std::vector<unsigned char*> result =
        MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain UTF8String]);
        NSMutableString *ipsStr = [NSMutableString stringWithString:@""];
        for (int i = 0; i < result.size(); i++)
        {
            NSString *ip = [NSString stringWithUTF8String:(const char*)result[i]];
            [ipsStr appendFormat:@"%@,",ip];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            self.resultTextView.text = [NSString stringWithFormat:@"Dns Result: \n %@" , ipsStr];
        });
    }
}

-(void)runPerformanceTest{
    NSString *domain1 = @"www.qq.com";
    std::vector<unsigned char*> result1 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain1 UTF8String]);
    NSMutableString *ipsStr1 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result1.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result1[i]];
        [ipsStr1 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.resultTextView.text = [NSString stringWithFormat:@"Dns Result :\n %@\n\n", ipsStr1];
    });
    
    NSString *domain2 = @"www.baidu.com";
    std::vector<unsigned char*> result2 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain2 UTF8String]);
    NSMutableString *ipsStr2 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result2.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result2[i]];
        [ipsStr2 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *result = [NSString stringWithFormat:@"Dns Result :\n %@\n\n", ipsStr2];
        self.resultTextView.text = [self.resultTextView.text stringByAppendingString:result];
    });
    
    NSString *domain3 = @"www.sina.com.cn";
    std::vector<unsigned char*> result3 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain3 UTF8String]);
    NSMutableString *ipsStr3 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result3.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result3[i]];
        [ipsStr3 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *result = [NSString stringWithFormat:@"Dns Result :\n %@\n\n", ipsStr3];
        self.resultTextView.text = [self.resultTextView.text stringByAppendingString:result];
    });
}

@end
