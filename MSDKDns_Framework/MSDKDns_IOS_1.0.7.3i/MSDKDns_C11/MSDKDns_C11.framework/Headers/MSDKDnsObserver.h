//
//  MSDKDnsObserver.h
//  MSDKDns
//
//  Created by Mike on 4/11/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#ifndef MSDKDnsObserver_h
#define MSDKDnsObserver_h

#include "MSDKDnsStructs.h"

/*! @brief MSDKDns通知类
 *
 * SDK通过通知类和外部调用者通讯
 */
class MSDKDnsObserver
{
public:
    /*! @brief 登录回调
     *
     * Dns结果通知上层App，并传递结果
     * @param loginRet 参数
     * @return void
     */
    virtual void OnMSDKDnsResultNotify(MSDKDnsRet& dnsRet) = 0;
    
    virtual ~MSDKDnsObserver() {};
    
    
};

#endif /* MSDKDnsObserver_h */
