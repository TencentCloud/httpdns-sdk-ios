/**
 * Copyright (c) Tencent. All rights reserved.
 */

#ifndef __MSDKDns_H__
#define __MSDKDns_H__

#define MSDKDns_Version @"1.2.0"

#import <Foundation/Foundation.h>

#if defined(__has_include)
    #if __has_include("MSDK/MSDK.h")
        #include "MSDK/MSDK.h"
    #endif
#endif

typedef enum {
    HttpDnsEncryptTypeDES = 0,
    HttpDnsEncryptTypeAES = 1,
    HttpDnsEncryptTypeHTTPS = 2
} HttpDnsEncryptType;

struct DnsConfig {
    NSString* appId; // 应用ID，腾讯云控制台申请获得，用于上报
    int dnsId; // 授权ID，腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* dnsKey; // 加密密钥，加密方式为AES、DES时必传。腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* token; // 加密方式为 HTTPS 时必传
    NSString* dnsIp; // HTTPDNS 服务器IP
    BOOL debug; // 是否开启Debug日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
    int timeout; // 超时时间，单位ms，如设置0，则设置为默认值2000ms
    HttpDnsEncryptType encryptType; // 控制加密方式
    NSString* routeIp; // 查询线路IP地址
};

@interface MSDKDns : NSObject

+ (id) sharedInstance;

#pragma mark - 设置业务基本信息，仅调用一次即可
/**
 * 初始化SDK
 *
 * @param config  配置
 * @return YES：设置成功 NO：设置失败
 */
- (BOOL) initConfig:(DnsConfig *)config;

/**
 * @deprecated This method is deprecated starting in version 1.2.1i
 * @note Please use @code initConfig:dnsId:dnsKey:dnsIp:debug:timeout @endcode instead.
 */
- (BOOL) WGSetDnsAppKey:(NSString *) appkey DnsID:(int)dnsid DnsKey:(NSString *)dnsKey DnsIP:(NSString *)dnsip Debug:(BOOL)debug TimeOut:(int)timeout DEPRECATED_ATTRIBUTE;

/**
 * @deprecated This method is deprecated starting in version 1.2.1i
 * @note Please use @code initConfig:dnsIp:debug:timeout @endcode instead.
*/
- (BOOL) WGSetDnsAppKey:(NSString *) appkey DnsIP:(NSString *)dnsip Debug:(BOOL)debug TimeOut:(int)timeout DEPRECATED_ATTRIBUTE;

/**
 * 设置UserId, 进行数据上报时区分用户, 出现问题时, 依赖该Id进行单用户问题排查
 
 * @param openId 用户的唯一标识符，腾讯业务建议直接使用OpenId，腾讯云客户建议传入长度50位以内，由字母数字下划线组合而成的字符串
 * @return YES：成功 NO：失败
 */
- (BOOL) WGSetDnsOpenId:(NSString *)openId;

#pragma mark - 域名解析接口，按需调用
/**
 域名同步解析（通用接口）

 @param domain 域名
 
 @return 查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (NSArray *) WGGetHostByName:(NSString *) domain;

/**
 域名批量同步解析（通用接口）

 @param domains 域名数组
 
 @return 查询到的IP字典
 */
- (NSDictionary *) WGGetHostsByNames:(NSArray *) domains;

/**
 域名异步解析（通用接口）

 @param domain  域名
 @param handler 返回查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (void) WGGetHostByNameAsync:(NSString *) domain returnIps:(void (^)(NSArray * ipsArray))handler;

/**
 域名批量异步解析（通用接口）

 @param domains  域名数组
 @param handler 返回查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (void) WGGetHostsByNamesAsync:(NSArray *) domains returnIps:(void (^)(NSDictionary * ipsDictionary))handler;

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

#pragma mark - 返回详细数据
/**
详细数据查询接口

@param domain 域名

@return 查询到的详细信息
 格式示例：
 {
 "v4_ips":"1.1.1.1,2.2.2.2",
 "v6_ips":"FF01::1,FF01::2",
 "v4_ttl":"100",
 "v6_ttl":"100",
 "v4_client_ip":"6.6.6.6"
 "v6_client_ip":"FF01::6"
 }
*/
- (NSDictionary *) WGGetDnsDetail:(NSString *) domain;

@end
#endif
