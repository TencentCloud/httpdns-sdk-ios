/**
 * Copyright (c) Tencent. All rights reserved.
 */

#import "SNIViewController.h"
#import <MSDKDns_C11/MSDKDns.h>
#import <MSDKDns_C11/MSDKDnsHttpMessageTools.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface SNIViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableData *connectionResponseData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UITextView *logView;

@end

@implementation SNIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 注册拦截请求的NSURLProtocol
    [NSURLProtocol registerClass:[MSDKDnsHttpMessageTools class]];
    
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.99";
//    config->dnsId = @"your dnsId";
//    config->dnsKey = @"your dnsKey";
//    config->encryptType = HttpDnsEncryptTypeDES;
    config->debug = YES;
    config->timeout = 10000;
    [[MSDKDns sharedInstance] initConfig: config];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)usingConnection:(id)sender {
    // 需要设置SNI的URL
    NSString *originalUrl = @"https://www.qq.com/";
    NSURL* url = [NSURL URLWithString:originalUrl];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSArray* result = [[MSDKDns sharedInstance] WGGetHostByName:url.host];
    NSString* ip = nil;
    if (result && result.count > 1) {
        if (![result[1] isEqualToString:@"0"]) {
            ip = result[1];
        } else {
            ip = result[0];
        }
    }
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    if (ip) {
        NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            request.URL = [NSURL URLWithString:newUrl];
            [request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];
}

- (IBAction)usingSession:(id)sender {
    // 需要设置SNI的URL
    NSString *originalUrl = @"业务的URL";
    NSURL* url = [NSURL URLWithString:originalUrl];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSArray* result = [[MSDKDns sharedInstance] WGGetHostByName:url.host];
    NSString* ip = nil;
    if (result && result.count > 1) {
        if (![result[1] isEqualToString:@"0"]) {
            ip = result[1];
        } else {
            ip = result[0];
        }
    }
    // 通过HTTPDNS获取IP成功，进行URL替换和HOST头设置
    if (ip) {
        NSRange hostFirstRange = [originalUrl rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            NSString *newUrl = [originalUrl stringByReplacingCharactersInRange:hostFirstRange withString:ip];
            request.URL = [NSURL URLWithString:newUrl];
            [request setValue:url.host forHTTPHeaderField:@"host"];
        }
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSArray *protocolArray = @[[MSDKDnsHttpMessageTools class]];
    configuration.protocolClasses = protocolArray;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [session dataTaskWithRequest:request];
    [self.task resume];
    
    // 注*：使用NSURLProtocol拦截NSURLSession发起的POST请求时，HTTPBody为空。
    // 解决方案有两个：1. 使用NSURLConnection发POST请求。
    // 2. 先将HTTPBody放入HTTP Header field中，然后在NSURLProtocol中再取出来。
    // 下面主要演示第二种解决方案
    // NSString *postStr = [NSString stringWithFormat:@"param1=%@&param2=%@", @"val1", @"val2"];
    // [_request addValue:postStr forHTTPHeaderField:@"originalBody"];
    // _request.HTTPMethod = @"POST";
    // NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // NSArray *protocolArray = @[ [CFHttpMessageURLProtocol class] ];
    // configuration.protocolClasses = protocolArray;
    // NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    // NSURLSessionTask *task = [session dataTaskWithRequest:_request];
    // [task resume];
}

- (void)viewDidDisappear:(BOOL)animated {
    // 取消注册CFHttpMessageURLProtocol，避免拦截其他场景的请求
    [NSURLProtocol unregisterClass:[MSDKDnsHttpMessageTools class]];
}

- (void)dealloc
{
    [self setConnectionResponseData:nil];
    [self.connection cancel];
    [self setConnection:nil];
    [self.task cancel];
    [self setTask:nil];
}


#pragma mark NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString* errorString = error.userInfo[@"NSLocalizedDescription"];
    NSLog(@"connectionDidFailWithError:%@", errorString);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView insertText:[NSString  stringWithFormat:@"请求失败，错误为：%@\n", errorString]];
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"HttpsResolver didReceiveResponse!");
    self.connectionResponseData = nil;
    _connectionResponseData = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"HttpsResolver didReceiveData!");
    if (data && data.length > 0)
    {
        [self.connectionResponseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* responeString = [[NSString alloc] initWithData:self.connectionResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"connectionDidFinishLoading: %@",responeString);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView insertText:[NSString  stringWithFormat:@"请求成功，请求到的数据为：%@\n", responeString]];
    });
}


#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString* responeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData: %@", responeString);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView insertText:[NSString  stringWithFormat:@"请求成功，请求到的数据为：%@\n", responeString]];
    });
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"response: %@", response);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSString* errorString = error.userInfo[@"NSLocalizedDescription"];
        NSLog(@"connectionDidFailWithError:%@", errorString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_logView insertText:[NSString  stringWithFormat:@"请求失败，错误为：%@\n", errorString]];
        });
    }
    else
    NSLog(@"complete");
}

@end
