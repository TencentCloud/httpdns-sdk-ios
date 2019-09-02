//
//  MSDKDns.h
//  MSDKDns
//
//  Created by Mike on 6/24/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#ifndef __MSDKDns_H__
#define __MSDKDns_H__

#define MSDKDns_Version @"1.1.5i"

#import <Foundation/Foundation.h>
#if defined(__has_include)
#if __has_include("MSDK/MSDK.h")
#include "MSDK/MSDK.h"
#endif

#if __has_include(<MSDK/BeaconBaseInterface.h>)
#include <MSDK/BeaconBaseInterface.h>
#endif

#if __has_include("BeaconAPI_Base/BeaconBaseInterface.h")
#include "BeaconAPI_Base/BeaconBaseInterface.h"
#endif
#endif

@interface MSDKDns : NSObject

+ (id) sharedInstance;

#pragma mark - 设置业务基本信息，仅调用一次即可
/**
 设置业务基本信息（腾讯云业务使用）

 @param appkey  业务appkey，腾讯云官网（https://console.cloud.tencent.com/httpdns）申请获得，用于上报
 @param dnsid   dns解析id，腾讯云官网（https://console.cloud.tencent.com/httpdns）申请获得，用于域名解析鉴权
 @param dnsKey  dns解析key，腾讯云官网（https://console.cloud.tencent.com/httpdns）申请获得，用于域名解析鉴权
 @param debug   是否开启Debug日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
 @param timeout 超时时间，单位ms，如设置0，则设置为默认值2000ms
 @param useHttp 是否使用http路解析，YES：使用http路解析，NO：使用https路解析
 
 @return YES:设置成功 NO:设置失败
 */
- (BOOL) WGSetDnsAppKey:(NSString *) appkey DnsID:(int)dnsid DnsKey:(NSString *)dnsKey Debug:(BOOL)debug TimeOut:(int)timeout UseHttp:(BOOL)useHttp;

/**
 设置业务基本信息（腾讯内部及代理业务使用）
 
 @param appkey  业务appid，同手Q APPID
 @param debug   是否开启Debug日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
 @param timeout 超时时间，单位ms，如设置0，则设置为默认值2000ms
 @param useHttp 是否使用http路解析，YES：使用http路解析，NO：使用https路解析
 
 @return YES:设置成功 NO:设置失败
 */
- (BOOL) WGSetDnsAppKey:(NSString *) appkey Debug:(BOOL)debug TimeOut:(int)timeout UseHttp:(BOOL)useHttp;

/**
 设置用户id（腾讯内部及代理业务使用）
 
 @param dnsOpenId 用户openid
 
 @return YES:成功 NO:失败
 */
- (BOOL) WGSetDnsOpenId:(NSString *) dnsOpenId;

#pragma mark - 域名解析接口，按需调用
/**
 域名同步解析（通用接口）

 @param domain 域名
 
 @return 查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (NSArray *) WGGetHostByName:(NSString *) domain;

/**
 域名异步解析（通用接口）

 @param domain  域名
 @param handler 返回查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (void) WGGetHostByNameAsync:(NSString *) domain returnIps:(void (^)(NSArray * ipsArray))handler;

#pragma mark - SNI场景，仅调用一次即可，请勿多次调用
/**
 SNI场景下设置需要拦截的域名列表
 建议使用该接口设置，仅拦截SNI场景下的域名，避免拦截其它场景下的域名

 @param hijackDomainArray 需要拦截的域名列表
 */
- (void) WGSetHijackDomainArray:(NSArray *)hijackDomainArray;

/**
 SNI场景下设置不需要拦截的域名列表

 @param noHijackDomainArray 不需要拦截的域名列表
 */
- (void) WGSetNoHijackDomainArray:(NSArray *)noHijackDomainArray;

@end
#endif
