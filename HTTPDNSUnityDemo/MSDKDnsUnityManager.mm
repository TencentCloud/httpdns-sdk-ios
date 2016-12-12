//
//  MSDKDnsUnityManager.m
//  MSDKDns
//
//  Created by fu chunhui on 16/7/25.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDKDnsUnityManager.h"

@implementation MSDKDnsUnityManager

//方法实现
+ (id) sharedInstance {
    static MSDKDnsUnityManager * _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MSDKDnsUnityManager alloc] init];
    });
    return _sharedInstance;
}

//Unity与IOS相互调用时，直接传递数组，操作较复杂，转成string后再传，更简便，以";"作为分隔符
-(NSString*)GetHostByName:(const char *)domain{
    NSArray* result = [[MSDKDns sharedInstance] WGGetHostByName:[NSString stringWithUTF8String:domain]];
    if (result && result.count > 1) {
        NSString* str = [NSString stringWithFormat:@"%@;%@",result[0], result[1]];
        return str;
    } else {
        return nil;
    }
}
//TODO 异步接口回调Unity
-(void)GetHostByNameAsync:(const char*)domain{
    }

@end
#if defined(__cplusplus)
extern "C"{
#endif
    char* MakeStringCopy (const char* string)
    {
        if (string == NULL)
            return NULL;
        char* res = (char*)malloc(strlen(string) + 1);
        strcpy(res, string);
        return res;
    }
    
    char*  WGGetHostByName(const char* domain){
        char* result = MakeStringCopy([[[MSDKDnsUnityManager sharedInstance] GetHostByName:domain] UTF8String]);
        return result;
    }
    
    void WGGetHostByNameAsync(const char* domain){
        [[MSDKDns sharedInstance] WGGetHostByNameAsync:[NSString stringWithUTF8String:domain] returnIps:^(NSArray *ipsArray) {
            if (ipsArray && ipsArray.count > 1) {
                NSString* result = [NSString stringWithFormat:@"%@;%@",ipsArray[0], ipsArray[1]];
                char* resultChar = MakeStringCopy([result UTF8String]);
                UnitySendMessage(UnityReceiverObject, "onDnsNotify", resultChar);
            } else {
                char* resultChar = (char*)"0;0";
                UnitySendMessage(UnityReceiverObject, "onDnsNotify", resultChar);
            }
        }];
    }
    
#if defined(__cplusplus)
}
#endif
