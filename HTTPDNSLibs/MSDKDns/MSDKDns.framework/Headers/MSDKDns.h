//
//  MSDKDns.h
//  MSDKDns
//
//  Created by Mike on 6/24/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#ifndef __MSDKDns_H__
#define __MSDKDns_H__

#define MSDKDns_Version @"1.0.10i"

#import <Foundation/Foundation.h>
#if defined(__has_include)
#if __has_include("MSDKFoundation/MSDKFoundation.h")
#include "MSDKFoundation/MSDKFoundation.h"
#endif

#if __has_include("BeaconAPI_Base/BeaconBaseInterface.h")
#include "BeaconAPI_Base/BeaconBaseInterface.h"
#endif
#endif

@interface MSDKDns : NSObject

+ (id) sharedInstance;

/**
 *  同步接口
 *  @param domain 域名
 *  @return 查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */
- (NSArray*) WGGetHostByName:(NSString*) domain;

/**
 *  异步接口
 *  @param domain 域名
 *  @return 查询到的IP数组，超时（1s）或者未未查询到返回[0,0]数组
 */

- (void) WGGetHostByNameAsync:(NSString*) domain returnIps:(void (^)(NSArray* ipsArray))handler;

/**
 *  Log开关
 *  @param enabled true:打开 false:关闭
 */
- (void) WGOpenMSDKDnsLog:(BOOL) enabled;

@end
#endif
