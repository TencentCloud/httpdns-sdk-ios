/**
 * Copyright (c) Tencent. All rights reserved.
 */

#ifndef Beacon_Framework_AnaPublicDefines_h
#define Beacon_Framework_AnaPublicDefines_h

//sdk的状态，未开启，初始化中，初始化完成，与服务器同步完成，错误
typedef enum AnlyticsSDKStatus {
    notenabled, initialing, initialed, syncedwithserver, error
} sdkstatus;

#endif
