//
//  MSDKDns.h
//  MSDKDns
//
//  Created by Mike on 6/24/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#ifndef __MSDKDns_H__
#define __MSDKDns_H__

#define MSDKDns_Version @"1.0.7.6i"

#import <Foundation/Foundation.h>
#include "MSDKDnsObserver.h"

#if defined(__has_include)
#if __has_include("MSDKFoundation/MSDKFoundation.h")
#include "MSDKFoundation/MSDKFoundation.h"
#endif

#if __has_include("Analytics/AnalyticsInterface.h")
#include "Analytics/AnalyticsInterface.h"
#endif

#if __has_include("BeaconAPI_Base/BeaconBaseInterface.h")
#include "BeaconAPI_Base/BeaconBaseInterface.h"
#endif
#endif

class MSDKDns{
private:
    static MSDKDns * m_pInst;
    
    MSDKDns();
    virtual ~MSDKDns();
    
public:
    static MSDKDns* GetInstance();
    /**
     *
     *  @param domain 域名
     *  @return 查询到的IP数组，超时（3s）或者未未查询到返回空数组
     */
    std::vector<unsigned char*> WGGetHostByName(unsigned char* domain);
    
    /**
     *  Log开关
     *  @param enabled true:打开 false:关闭
     */
    void WGOpenMSDKDnsLog(bool enabled);
    
};

#endif