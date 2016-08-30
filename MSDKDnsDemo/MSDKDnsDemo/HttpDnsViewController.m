//
//  HttpDnsViewController.m
//  MSDKDnsDevDemo
//
//  Created by Gavin on 2016-07-08.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "HttpDnsViewController.h"


#import "LabelWithPickView.h"
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updSend) name:@"Notification_UDPSend" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updReceive) name:@"Notification_UDPReceive" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tcpConnect) name:@"Notification_TCPConnect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tcpSend) name:@"Notification_TCPSend" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tcpReceive) name:@"Notification_TCPReceive" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tcpDisconnect) name:@"Notification_TCPDisconnect" object:nil];
}

-(void)updSend{
    [_resultTextView insertText:@"\n发送数据：udpPackage"];
}

-(void)updReceive{
    [_resultTextView insertText:@"\n成功接收数据，UDP连接测试成功！\n"];
}

-(void)tcpConnect{
    [_resultTextView insertText:@"\nTCP连接成功"];
}

-(void)tcpSend{
    [_resultTextView insertText:@"\n发送数据：tcpPackage"];
}

-(void)tcpReceive{
    [_resultTextView insertText:@"\n成功接收数据，TCP连接测试成功！\n"];
}

-(void)tcpDisconnect{
    [_resultTextView insertText:@"\nTCP断开连接"];
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
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        }
    }
}

- (IBAction)qosButtonDidClicked:(id)sender{
    [_resultTextView insertText:@"\n选择了域名：qos.game.qq.com，准备开始解析..."];
    NSString *domain = @"qos.game.qq.com";
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
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        }
    }
}

- (IBAction)noqosButtonDidClicked:(id)sender{
    [_resultTextView insertText:@"\n选择了域名：noqos.game.qq.com，准备开始解析..."];
    NSString *domain = @"noqos.game.qq.com";
    if (domain.length > 0)
    {
        std::vector<unsigned char*> result =
        MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[domain UTF8String]);
        if (result.size() > 1) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\nIPV4地址为：%@\nIPV6地址为：%@\n",[NSString stringWithUTF8String:(const char*)result[0]], [NSString stringWithUTF8String:(const char*)result[1]]];
            [self setIpv4:[NSString stringWithUTF8String:(const char*)result[0]]];
            [self setIpv6:[NSString stringWithUTF8String:(const char*)result[1]]];
            [_resultTextView insertText:str];
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        }
    }
}

- (IBAction)tcpButtonDidClicked:(id)sender{
    if (!_ipv4 && ! _ipv6) {
        [_resultTextView insertText:@"\n请先选择域名！"];
    } else {
        if (![_ipv6 isEqualToString:@"0"]) {
            NSString* str = [NSString stringWithFormat:@"\n进行TCP连接测试，IP地址为：%@", _ipv6];
            [_resultTextView insertText:str];
            [[HttpDnsTCP sharedInstance] startTCPTest:_ipv6 Port:20000];
        } else {
            NSString* str = [NSString stringWithFormat:@"\n进行TCP连接测试，IP地址为：%@", _ipv4];
            [_resultTextView insertText:str];
            [[HttpDnsTCP sharedInstance]startTCPTest:_ipv4 Port:20000];
        }
    }
}

- (IBAction)udpButtonDidClicked:(id)sender{
    if (!_ipv4 && ! _ipv6) {
        [_resultTextView insertText:@"\n请先选择域名！"];
    } else {
        if (![_ipv6 isEqualToString:@"0"]) {
            NSString* str = [NSString stringWithFormat:@"\n进行UDP连接测试，IP地址为：%@", _ipv6];
            [_resultTextView insertText:str];
            [[HttpDnsUDP sharedInstance] startUdpTest:_ipv6 Port:10000];
        } else {
            NSString* str = [NSString stringWithFormat:@"\n进行UDP连接测试，IP地址为：%@", _ipv4];
            [_resultTextView insertText:str];
            [[HttpDnsUDP sharedInstance]startUdpTest:_ipv4 Port:10000];
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
