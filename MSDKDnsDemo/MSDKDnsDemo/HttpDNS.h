//
//  HttpDNS.h
//
//  Created by Gavin on 16/7/67.
//  Copyright (c) 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^httpDnsBlock)(NSString *url);

@interface HttpDNS : NSObject

+ (instancetype)shareInstance;

/**
 * @brief 同步获取域名的IP地址，可能较耗时。频繁调用建议采用异步查询方式
 *
 * @param hostName 域名，不要带http协议头!!!
 *
 * @return IP地址（异常会返回域名）
 *
 */
- (NSString *)getHostByName:(NSString *)url;

@end
