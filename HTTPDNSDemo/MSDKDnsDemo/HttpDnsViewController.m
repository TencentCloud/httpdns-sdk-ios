/**
 * Copyright (c) Tencent. All rights reserved.
 */

#import "HttpDnsViewController.h"
#import <MSDKDns_C11/MSDKDns.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface HttpDnsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Domain;
@property (weak, nonatomic) IBOutlet UITextField *DnsIp;
@property (weak, nonatomic) IBOutlet UITextField *DnsId;
@property (weak, nonatomic) IBOutlet UITextField *DnsKey;
@property (weak, nonatomic) IBOutlet UITextField *Token;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Channel;
@property (weak, nonatomic) IBOutlet UITextField *RouteIp;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (assign, nonatomic) DnsConfig *config;

@end

@implementation HttpDnsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _resultTextView.layoutManager.allowsNonContiguousLayout= NO;
    _config = new DnsConfig();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)readConfig {
    _config->dnsIp = [_DnsIp text];
    _config->dnsId = [_DnsId text].intValue;
    _config->dnsKey = [_DnsKey text];
    _config->token = [_Token text];
    _config->encryptType = [self getEncryptType];
    _config->debug = YES;
    _config->routeIp = [_RouteIp text];
    _config->minutesBeforeSwitchToMain = 1;
    _config->retryTimesBeforeSwitchServer = 2;
    _config->enableReport = YES;
    [[MSDKDns sharedInstance] initConfig: _config];
    [[MSDKDns sharedInstance] clearCache];
}


-(IBAction)getHostByName:(id)sender {
    _resultTextView.text = @"";
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSArray *domains = [self getQueryDomains];
    if ([domains count] == 1)
    {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        NSArray* result = [[MSDKDns sharedInstance] WGGetHostByName:domains[0]];
        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
        NSLog(@"=====本次耗时=====：%fms", (time2 - time1) * 1000);
        if (result && result.count > 1) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\nIPV4地址为：%@\nIPV6地址为：%@\n", result[0], result[1]];
            [_resultTextView insertText:str];
            [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
            [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
        }
    } else if ([domains count] > 1) {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        NSDictionary* result = [[MSDKDns sharedInstance] WGGetHostsByNames:domains];
        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
        NSLog(@"=====本次耗时=====：%fms", (time2 - time1) * 1000);
        if (result && [result count] > 0) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\n %@\n",result];
            [_resultTextView insertText:str];
            [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
        } else {
            [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
            [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
        }
    }
}
- (IBAction)getHostByNameAsync:(id)sender {
    _resultTextView.text = @"";
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSArray *domains = [self getQueryDomains];
    if ([domains count] == 1)
    {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        [[MSDKDns sharedInstance] WGGetHostByNameAsync:domains[0] returnIps:^(NSArray *ipsArray) {
            NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
            NSLog(@"=====本次耗时=====：%fms", (time2 - time1) * 1000);
            if (ipsArray && ipsArray.count > 1) {
                NSString* str = [NSString stringWithFormat:@"\n解析结果为 \nIPV4地址为：%@\nIPV6地址为：%@\n", ipsArray[0], ipsArray[1]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:str];
                    [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
                    [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
                });
            }
        }];
    } else if ([domains count] > 1) {
        NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
        [[MSDKDns sharedInstance] WGGetHostsByNamesAsync:domains returnIps:^(NSDictionary *ipsDict) {
            NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
            NSLog(@"=====本次耗时=====：%fms", (time2 - time1) * 1000);
            if (ipsDict && [ipsDict count] > 0) {
                NSString* str = [NSString stringWithFormat:@"\n解析结果为：\n：%@\n",ipsDict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:str];
                    [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
                    [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
                });
            }
        }];
    }
}

- (NSArray *)getQueryDomains {
    NSString *inputStr = [_Domain text];
    if (inputStr.length > 0) {
        return [inputStr componentsSeparatedByString:@","];
    }
    return @[];
}

- (HttpDnsEncryptType)getEncryptType {
    NSUInteger index = [_Channel selectedSegmentIndex];
    if(index == 0) {
        return HttpDnsEncryptTypeAES;
    } else if(index == 2) {
        return HttpDnsEncryptTypeHTTPS;
    }
    return HttpDnsEncryptTypeDES;
}

@end
