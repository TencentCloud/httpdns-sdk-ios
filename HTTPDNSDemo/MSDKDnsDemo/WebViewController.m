//
//  WebViewController.m
//  MSDKDnsDemo
//
//  Created by eric hu on 2024/1/29.
//  Copyright © 2024 Tencent. All rights reserved.
//
#import <WebKit/WebKit.h>
#import <MSDKDns_C11/MSDKDns.h>
#import <MSDKDns_C11/MSDKDnsHttpMessageTools.h>
#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, strong) WKWebView *wkWebView;
@property(nonatomic, strong) UIScrollView* scrollViewForWk;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLProtocol registerClass:[MSDKDnsHttpMessageTools class]];
    
    DnsConfig config = {
        .dnsId = dns授权id,
        .dnsKey = @"DesKey加密密钥",
        .encryptType = HttpDnsEncryptTypeDES,
    };
    [[MSDKDns sharedInstance] initConfig: &config];

   // 设置需要进行预解析的域名
    [[MSDKDns sharedInstance] WGSetPreResolvedDomains:@[@"dnspod.com", @"dnspod.cn"]];
    
    // show webview
    _scrollViewForWk = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 200, self.view.bounds.size.width - 20, 500)];
    _scrollViewForWk.scrollEnabled = YES;
    _scrollViewForWk.showsVerticalScrollIndicator = YES;
    _scrollViewForWk.showsHorizontalScrollIndicator = YES;
    _scrollViewForWk.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    [self.view addSubview:_scrollViewForWk];

}

- (IBAction)showWkWebview:(id)sender {
    // Do any additional setup after loading the view.
   
    if (self.wkWebView == nil) {
        //注册scheme
        Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
        if ([cls respondsToSelector:sel]) {
            // 通过http和https的请求，同理可通过其他的Scheme 但是要满足ULR Loading System
            [cls performSelector:sel withObject:@"http"];
            [cls performSelector:sel withObject:@"https"];
        }
        
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViewForWk.bounds.size.width, self.scrollViewForWk.bounds.size.height)
                                            configuration:config];
        [self.scrollViewForWk addSubview:self.wkWebView];
    }
    
    NSURL* url = [NSURL URLWithString:@"https://www.qq.com"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.wkWebView loadRequest:request];
    
}

@end
