/**
 * Copyright (c) Tencent. All rights reserved.
 */

#ifndef __MSDKDns_H__
#define __MSDKDns_H__

#define MSDKDns_Version @"1.10.3"

#import <Foundation/Foundation.h>

typedef enum {
    HttpDnsEncryptTypeDES = 0,
    HttpDnsEncryptTypeAES = 1,
    HttpDnsEncryptTypeHTTPS = 2
} HttpDnsEncryptType;

typedef enum {
    HttpDnsAddressTypeAuto = 0, // sdk自动检测
    HttpDnsAddressTypeIPv4 = 1, // 只支持ipv4
    HttpDnsAddressTypeIPv6 = 2, // 只支持ipv6
    HttpDnsAddressTypeDual = 3, // 支持双协议栈
} HttpDnsAddressType;

typedef struct DnsConfigStruct {
    NSString* appId; // 可选，应用ID，腾讯云控制台申请获得，用于灯塔数据上报（未集成灯塔时该参数无效）
    int dnsId; // 授权ID，腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* dnsKey; // 加密密钥，加密方式为AES、DES时必传。腾讯云控制台申请后，通过邮件发送，用于域名解析鉴权
    NSString* token; // 加密token，加密方式为 HTTPS 时必传
    NSString* dnsIp __attribute__((deprecated("v1.8.0及以上SDK内部调度，无需设置"))); // HTTPDNS 服务器 IP
    BOOL debug; // 是否开启Debug日志，YES：开启，NO：关闭。建议联调阶段开启，正式上线前关闭
    int timeout; // 可选，超时时间，单位ms，如设置0，则设置为默认值2000ms
    HttpDnsEncryptType encryptType; // 控制加密方式
    HttpDnsAddressType addressType; // 指定返回的ip地址类型，默认为 HttpDnsAddressTypeAuto sdk自动检测
    NSString* routeIp; // 可选，DNS 请求的 ECS（EDNS-Client-Subnet）值，默认情况下 HTTPDNS 服务器会查询客户端出口 IP 为 DNS 线路查询 IP，可以指定线路 IP 地址。支持 IPv4/IPv6 地址传入
    BOOL httpOnly;// 可选，是否仅返回 httpDns 解析结果。默认 false，即当 httpDns 解析失败时会返回 localDns 解析结果，设置为 true 时，仅返回 httpDns 的解析结果
    NSUInteger retryTimesBeforeSwitchServer; // 可选，切换ip之前重试次数, 默认3次
    NSUInteger minutesBeforeSwitchToMain; // 可选，设置切回主ip间隔时长，默认10分钟
    BOOL enableReport; // 是否开启解析异常上报，默认NO，不上报
    BOOL enableExperimentalBugly; // 实验性参数，仅提供给内部特定团队使用，请勿启用
} DnsConfig;

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
 * 初始化SDK
 * 通过 Dictionary 配置，字段参考 DnsConfig 结构，用于兼容 swift 项目，解决 swift 项目中无法识别 DnsConfig 类型的问题
 *
 * @param config  配置
 * @return YES：设置成功 NO：设置失败
 */
- (BOOL) initConfigWithDictionary:(NSDictionary *)config;

/**
 * 设置UserId, 进行数据上报时区分用户, 出现问题时, 依赖该Id进行单用户问题排查
 
 * @param openId 用户的唯一标识符，腾讯业务建议直接使用OpenId，腾讯云客户建议传入长度50位以内，由字母数字下划线组合而成的字符串
 * @return YES：成功 NO：失败
 */
- (BOOL) WGSetDnsOpenId:(NSString *)openId;

/**
 * 设置预解析的域名，设置的域名会在sdk初始化完成后自动进行解析
 */
- (void) WGSetPreResolvedDomains:(NSArray *)domains;

/**
 * 设置保活的域名，设置的域名会定时更新缓存，数量不能大于8个
 */
- (void) WGSetKeepAliveDomains:(NSArray *)domains;

/**
 * 启用IP优选，设置域名对应的端口号，对域名解析返回的IP列表进行IP探测，对返回的列表进行动态排序，以保证第一个IP是可用性最好的IP
 */
- (void) WGSetIPRankData:(NSDictionary *)IPRankData;

/**
 * 设置开启和关闭缓存启停功能，默认开启
 */
- (void) WGSetEnableKeepDomainsAlive: (BOOL)enableKeepDomainsAlive;

/**
 * 设置允许返回TTL过期域名的IP，默认关闭
 */
- (void) WGSetExpiredIPEnabled:(BOOL)enable;

/**
 * 设置持久化缓存功能，默认关闭
 */
- (void) WGSetPersistCacheIPEnabled:(BOOL)enable;

#pragma mark - 域名解析接口，按需调用
/**
 域名同步解析（通用接口）

 @param domain 域名
 
 @return 查询到的IP数组，超时（默认2s）或者未未查询到返回[0,0]数组
 */
- (NSArray *) WGGetHostByName:(NSString *) domain;

/**
 域名批量同步解析（通用接口）

 @param domains 域名数组
 
 @return 查询到的IP字典
 */
- (NSDictionary *) WGGetHostsByNames:(NSArray *) domains;

/**
 域名批量同步解析（查询所有ip）

 @param domains 域名数组
 
 @return 查询到的IP字典
 */
- (NSDictionary *) WGGetAllHostsByNames:(NSArray *)domains;

/**
 域名异步解析（通用接口）

 @param domain  域名
 @param handler 返回查询到的IP数组，超时（默认2s）或者未未查询到返回[0,0]数组
 */
- (void) WGGetHostByNameAsync:(NSString *) domain returnIps:(void (^)(NSArray * ipsArray))handler;

/**
 域名批量异步解析（通用接口）

 @param domains  域名数组
 @param handler 返回查询到的IP数组，超时（默认2s）或者未未查询到返回[0,0]数组
 */
- (void) WGGetHostsByNamesAsync:(NSArray *) domains returnIps:(void (^)(NSDictionary * ipsDictionary))handler;

/**
 域名批量异步解析（查询所有ip）

 @param domains  域名数组
 @param handler 返回查询到的IP数组，超时（默认2s）或者未未查询到返回[0,0]数组
 */
- (void)WGGetAllHostsByNamesAsync:(NSArray *)domains returnIps:(void (^)(NSDictionary * ipsDictionary))handler;

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

#pragma mark-清除缓存
/**
 清理本地所有缓存，除非业务明确需要，不要调用该方法
*/
- (void)clearCache;

/**
 需要清除的host域名数组。如果需要清空全部数据，传nil或者空数组即可
*/
- (void)clearHostCache:(NSArray *)hostArray;

#pragma mark-查询网络栈支持情况
/**
 查询网络栈支持情况
 @return 0: UNKNOWN, 1: IPV4_ONLY, 2: IPV6_ONLY, 3: DUAL_STACK;
*/
- (int) WGGetNetworkStack;

@end
#endif
