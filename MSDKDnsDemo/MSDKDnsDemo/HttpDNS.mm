//
//  HttpDNS.m
//
//
//  Created by Gavin on 16/7/6.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "HttpDNS.h"
#import <MSDKDns/MSDKDns.h>

@implementation HttpDNS

+ (instancetype)shareInstance
{
    static HttpDNS *_httpDNS = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _httpDNS = [[HttpDNS alloc] init];
    });

    return _httpDNS;
}


/**
 * @brief 替换urlString中的域名为IP地址
 *
 * @param urlString 请求url字串
 * @param hostName  url中的请求域名
 * @param ipString  IP地址
 *
 * @return 替换域名后的url字串
 *
 */
- (NSString *)requestURL:(NSString *)urlString stringByReplaceHostName:(NSString*)hostName byIP:(NSString *)ipString
{
    NSRange hostRange = [urlString rangeOfString:hostName];
    NSString *convertedURL = urlString;

    if (NSNotFound != hostRange.location)
    {
        convertedURL =
            [urlString stringByReplacingCharactersInRange:hostRange withString:
             ipString];
    }

    return convertedURL;
}

/**
 * @brief 同步获取域名的IP地址，可能较耗时。频繁调用建议采用异步查询方式
 *
 * @param hostName 域名，不要带http协议头!
 *
 * @return IP地址（异常会返回域名）
 *
 */
- (NSString *)getHostByNameSync:(NSString *)url
{
    @synchronized(self)
    {
        NSString *hostName = [[NSURL URLWithString:url] host];

        if (hostName.length == 0)
        {
            return url;
        }
        NSLog(@"hostName:%@", hostName);

        NSString *ipAdress = url;
        NSLog(@"ip0Address:%@", url);
        std::vector<unsigned char *> ipsVector =
            MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[hostName UTF8String]);
        if (ipsVector.size() > 0)
        {
            NSLog(@"isReturn back");
            ipAdress =
                [NSString stringWithUTF8String:(const char *)ipsVector[0]];
            NSLog(@"ip1Address:%@", ipAdress);
            if (ipAdress.length != 0)
            {
                ipAdress = [self requestURL:url stringByReplaceHostName:hostName byIP:ipAdress];
            }
        }
        NSLog(@"ipAddress:%@", ipAdress);

        return ipAdress;
    }
}

/**
 * @brief 异步获取域名的IP地址
 *
 * @param hostName       域名，不要带http协议头!
 * @param resultCallback 查询IP地址的回调（异常会返回域名）
 *
 */
- (void)getHostByNameAsync:(NSString *)url dnsCallback:(httpDnsBlock)dnsCallback
{
    NSString *hostName = [[NSURL URLWithString:url] host];

    if (hostName.length == 0)
    {
        if (dnsCallback)
        {
            dnsCallback(url);
        }

        return;
    }

    __block NSString *ipAdress = url;


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        std::vector<unsigned char *> ipsVector =
            MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)[hostName UTF8String]);
        if (ipsVector.size() > 0)
        {
            ipAdress = [NSString stringWithUTF8String:(const char *)ipsVector[0]];
            if (ipAdress.length != 0)
            {
                ipAdress =
                    [self requestURL:url stringByReplaceHostName:hostName byIP:
                     ipAdress];
            }
        }
        if (dnsCallback)
        {
            dnsCallback(ipAdress);
        }

    });
}

@end
