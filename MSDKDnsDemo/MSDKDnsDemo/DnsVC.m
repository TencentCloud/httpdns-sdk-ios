//
//  ViewController.m
//  MSDKDnsDevDemo
//
//  Created by 付亚明 on 7/1/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "DnsVC.h"
#import <MSDKDns/MSDKDns.h>

@interface DnsVC ()

@property (weak, nonatomic) IBOutlet UITextField *ipTF;

@end

@implementation DnsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MSDKDns::GetInstance()->WGOpenMSDKDnsLog(true);
}

- (IBAction)dnsButtonDidClicked:(id)sender
{
    NSString *domain = self.ipTF.text;
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dns Result" message:ipsStr delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
            [alertView show];
        });

    }
}

- (IBAction)doMSDKDnsOnNewThread:(id)sender
{
    [self performSelectorInBackground:@selector(testMSDKDnsCallOnOtherThread) withObject:nil];
}

- (void)testMSDKDnsCallOnOtherThread
{
    NSString *domain = self.ipTF.text;
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dns Result" message:ipsStr delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
}

- (void)showResultOnMainThread:(NSArray *)dataSourceArray
{
    [self performSegueWithIdentifier:@"SEG_TO_ResultVC" sender:dataSourceArray];
}

- (IBAction)doPerformanceTest:(id)sender
{
    NSString *domain1 = @"www.qq.com";
    //MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain1 UTF8String]);
    std::vector<unsigned char*> result1 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain1 UTF8String]);
    NSMutableString *ipsStr1 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result1.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result1[i]];
        [ipsStr1 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dns Result" message:ipsStr1 delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
        [alertView show];
    });
    
    NSString *domain2 = @"www.baidu.com";
    //MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain2 UTF8String]);
    std::vector<unsigned char*> result2 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain2 UTF8String]);
    NSMutableString *ipsStr2 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result2.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result2[i]];
        [ipsStr2 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dns Result" message:ipsStr2 delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
        [alertView show];
    });

    NSString *domain3 = @"www.sina.com.cn";
    //MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain3 UTF8String]);
    std::vector<unsigned char*> result3 =
    MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain3 UTF8String]);
    NSMutableString *ipsStr3 = [NSMutableString stringWithString:@""];
    for (int i = 0; i < result3.size(); i++)
    {
        NSString *ip = [NSString stringWithUTF8String:(const char*)result3[i]];
        [ipsStr3 appendFormat:@"%@,",ip];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dns Result" message:ipsStr3 delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil, nil];
        [alertView show];
    });

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
