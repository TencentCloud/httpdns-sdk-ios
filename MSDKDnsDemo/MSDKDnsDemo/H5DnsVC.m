//
//  H5DnsVC.m
//  MSDKDnsDemo
//
//  Created by Gavin on 16/6/28.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "H5DnsVC.h"
#import "HttpDNS.h"
#import "H5ContentURLProtocol.h"

@interface H5DnsVC () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation H5DnsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册NSURLProtocol
    [NSURLProtocol registerClass:[H5ContentURLProtocol class]];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height - 64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://guang.m.yohobuy.com/info/index?id=50541"]];

    // 修改了请求的头部信息
    NSString *hostName = [[request URL] host];
    NSMutableURLRequest *mutableReq = [request mutableCopy];
    NSMutableDictionary *headers = [mutableReq.allHTTPHeaderFields mutableCopy];

    NSString *url = [[request URL] absoluteString];

    url = [[HttpDNS shareInstance] getHostByNameSync:url];
    [headers setObject:hostName forKey:@"Host"];
    mutableReq.allHTTPHeaderFields = headers;
    [mutableReq setValue:hostName forHTTPHeaderField:@"Host"];
    [mutableReq setURL:[NSURL URLWithString:url]];
    NSLog(@"Host:%@ connection new URL:%@", hostName, url);

    [self.webView loadRequest:mutableReq];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
