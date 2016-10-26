//
//  MSDKDnsStructs.h
//  MSDKDns
//
//  Created by Mike on 4/11/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#ifndef MSDKDnsStructs_h
#define MSDKDnsStructs_h

#include <string>
#include <vector>

typedef struct {
    std::string desc;       //返回描述
    std::string domain;
    std::vector<unsigned char*> ip; //结果ip
}MSDKDnsRet;


#endif /* MSDKDnsStructs_h */
