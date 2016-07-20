//
//  H5DnsViewController.m
//  MSDKDnsDevDemo
//
//  Created by Gavin on 2016-07-07.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "H5DnsViewController.h"
#import "HttpDNS.h"
#import "H5ContentURLProtocol.h"

@interface H5DnsViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation H5DnsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ******************************
    // 接入H5解析
    [NSURLProtocol registerClass:[H5ContentURLProtocol class]];
    // Init the webview
    self.webView =
        [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height)
        ];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSURLRequest *request =
        [NSURLRequest requestWithURL:[NSURL URLWithString:
                                      @"http://guang.m.yohobuy.com/info/index?id=50541"
         ]];

    NSString *hostName = [[request URL] host];
    NSMutableURLRequest *mutableReq = [request mutableCopy];
    NSMutableDictionary *header = [mutableReq.allHTTPHeaderFields mutableCopy];

    NSString *url = [[request URL] absoluteString];

    url = [[HttpDNS shareInstance]getHostByName:url];
    [header setObject:hostName forKey:@"Host"];
    mutableReq.allHTTPHeaderFields = header;
    [mutableReq setValue:hostName forHTTPHeaderField:@"Host"];
    [mutableReq setURL:[NSURL URLWithString:url]];
    
//    NSLog(@"Host: %@ connection new URL:%@", hostName, url);
    
    [self.webView loadRequest:mutableReq];
    [self.view addSubview:webViewProgressView];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{

    webViewProgressView.progress = 0;
    theBool = false;
    
    proressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    theBool = true;
}

-(void)timerCallback{
    if (theBool) {
        if (webViewProgressView.progress >= 1) {
            webViewProgressView.hidden = true;
            [proressTimer invalidate];
        }else{
            webViewProgressView.progress += 0.1;
        }
    }
    else{
        webViewProgressView.progress += 0.05;
        if (webViewProgressView.progress >= 0.95) {
            webViewProgressView.progress = 0.95;
        }
    }
}

@end
