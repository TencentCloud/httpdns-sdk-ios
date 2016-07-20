//
//  H5ContentURLProtocol.m
//  NSURLProtocolExample
//
//  Created by Gavin on 2016-06-30.
//  Copyright (c) 2016 Tencent. All rights reserved.
//

#import "H5ContentURLProtocol.h"
#import "HttpDNS.h"


static NSObject *H5CachingSupportedSchemesMonitor;
static NSSet *H5CachingSupportedSchemes;

@interface H5ContentURLProtocol () <NSURLConnectionDelegate>

@property (nonatomic,readwrite, strong) NSURLConnection *connection;

@end

@implementation H5ContentURLProtocol

+ (void)initialize
{
    if (self == [H5ContentURLProtocol class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            H5CachingSupportedSchemesMonitor = [NSObject new];
        });
    
        [self setSupportedSchemes:[NSSet setWithArray:@[@"http", @"https"]]];
    }
}

/**
 *  单例
 *
 *  @return H5ContentURLProtocol 的单例
 */
+ (id)sharedProtocol
{
    static H5ContentURLProtocol *sharedProtocol = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedProtocol = [[self alloc] init];
        H5CachingSupportedSchemesMonitor = [NSObject new];
    });

    // 暂时只支持http 和 https
    [self setSupportedSchemes:[NSSet setWithArray:@[@"http", @"https"]]];

    return sharedProtocol;
}

+ (NSSet *)supportedSchemes
{
    NSSet *supportedSchemes;

    @synchronized(H5CachingSupportedSchemesMonitor)
    {
        supportedSchemes = H5CachingSupportedSchemes;
    }

    return supportedSchemes;
}

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes
{
    @synchronized(H5CachingSupportedSchemesMonitor)
    {
        H5CachingSupportedSchemes = supportedSchemes;
    }
}

/**
 *  进行请求的过滤
 *
 *  @param request 请求
 *
 *  @return 返回YES,表示要拦截处理
 *  @return 返回NO,表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    // 防止循环拦截的标示
    if ([NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:
         request])
    {
        // 返回NO， 表示不拦截处理
        return NO;
    }
    NSURL *requestURL = [request URL];
    
    if (![[self supportedSchemes] containsObject:[requestURL scheme]])
    {
        return NO;
    }

    // 返回YES，表示要拦截处理
    return YES;
}

/**
 *  对请求进行重定向，添加指定头部等操作，可以在该方法下进行
 *
 *  @param request 原请求
 *
 *  @return 修改后的请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

/**
 *  是否存在缓存
 *
 *  @param a 原URL请求
 *  @param b 缓存的URL请求
 *
 *  @return 缓存存在否
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

/**
 *  让被拦截的请求执行
 */
- (void)startLoading
{
    NSMutableURLRequest *newRequest;
    NSString *fileExtension = [[self.request URL] absoluteString];
    if (([fileExtension rangeOfString:@".png"].location != NSNotFound) || ([fileExtension rangeOfString:@".jpg"].location != NSNotFound) || ([fileExtension rangeOfString:@".css"].location != NSNotFound))
    {
        // 修改了请求的头部信息，同步/异步请求
        newRequest = [[H5ContentURLProtocol convertToNewRequest:self.request] mutableCopy];
    } else {
        newRequest = [self.request mutableCopy];
    }

    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];

    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

/**
 *  取消执行请求
 */
- (void)stopLoading
{
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDelegate

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(
        NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData
                                                                 *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(nonnull
                                                                   NSError *)
    error
{
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if (!challenge) {
        return;
    }
    
    /*
     * URL里面的host在使用HTTPDNS的情况下被设置成了IP，此处从HTTP Header中获取真实域名
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"Host"];
    if (!host) {
        host = self.request.URL.host;
    }
    
    /*
     * 判断challenge的身份验证方法是否是NSURLAuthenticationMethodServerTrust（HTTPS模式下会进行该身份验证流程），
     * 在没有配置身份验证方法的情况下进行默认的网络请求流程。
     */
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            /*
             * 验证完以后，需要构造一个NSURLCredential发送给发起方
             */
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            /*
             * 验证失败，取消这次验证流程
             */
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    } else {
        /*
         * 对于其他验证方法直接进行处理流程
         */
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

#pragma mark - Helper method

/**
 *  Convert Request to String
 *
 *  @param urlRequest NSURLRequest format
 *
 *  @return the NSString representation
 */
+ (NSString *)urlRequestToString:(NSURLRequest *)urlRequest
{

    NSString *requestPath = [[urlRequest URL] absoluteString];

    return requestPath;
}

+ (NSString *)urlRequestToFileExtension:(NSURLRequest *)urlRequest
{

    NSString *fileExtension = [[urlRequest URL] pathExtension];

    return fileExtension;
}

#pragma mark - HTTPDNS Conversion
/**
 *  转换URL请求
 *
 *  @param oldRequest     待转换的URL请求
 *
 *  @return 返回转换过后的URL请求
 */
+ (NSURLRequest *)convertToNewRequest:(NSURLRequest *)oldRequest {
    NSString *hostName = [[oldRequest URL] host];
    NSString *httpHostName = [NSString stringWithFormat:@"http://%@", hostName];
    NSMutableURLRequest *mutableReq = [oldRequest mutableCopy];
    NSString *filePath = [[oldRequest URL] path];

    NSString *convertedHost = [[HttpDNS shareInstance] getHostByName:httpHostName];
    
    NSString *cachedFullPath = [convertedHost stringByAppendingString:filePath];
    [mutableReq setURL:[NSURL URLWithString:cachedFullPath]];
    
    NSMutableDictionary *headers = [mutableReq.allHTTPHeaderFields mutableCopy];

    [headers setObject:hostName forKey:@"Host"];
    mutableReq.allHTTPHeaderFields = headers;
    [mutableReq setValue:hostName forHTTPHeaderField:@"Host"];
    return mutableReq;
}

@end