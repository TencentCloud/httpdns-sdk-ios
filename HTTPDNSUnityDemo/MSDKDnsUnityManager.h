//
//  MSDKDnsUnityManager.h
//  MSDKDns
//
//  Created by fu chunhui on 16/7/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#ifndef MSDKDnsUnityManager_h
#define MSDKDnsUnityManager_h

#define UnityReceiverObject "ClickObject"

// 如引入framework为MSDKDns时，引入头文件<MSDKDns/MSDKDns.h>
#import <MSDKDns/MSDKDns.h>
// 如引入framework为MSDKDns_C11，则改为引入头文件<MSDKDns_C11/MSDKDns.h>
// #import <MSDKDns_C11/MSDKDns.h>

@interface MSDKDnsUnityManager : NSObject 

- (NSString*)GetHostByName:(const char*) domain;
+ (id) sharedInstance;

@end

#endif /* MSDKDnsUnityManager_h */
