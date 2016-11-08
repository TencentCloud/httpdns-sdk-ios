//
//  BeaconAnaPublicDefines.h
//  Beacon
//
//  Created by tencent on 12-11-20.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#ifndef Beacon_Framework_AnaPublicDefines_h
#define Beacon_Framework_AnaPublicDefines_h

//sdk的状态，未开启，初始化中，初始化完成，与服务器同步完成，错误
typedef enum AnlyticsSDKStatus {
    notenabled, initialing, initialed, syncedwithserver, error
} sdkstatus;

#define SPEED_TEST_SUCCESS 0
#define SPEED_SSO_SCOKET_CREATE_ERR -10001
#define SPEED_SSO_SOCKET_CONNECT_ERR -10002
#define SPEED_SSO_WRITE_ERR -10003

#define SPEED_SSO_READ_ERR -10005
#define SPEED_SSO_DATA_NOT_MATCH -10006

#define SPEED_SSO_CONN_OUTTIME_ERR -10004
#define SPEED_SSO_WRITE_OUTTIME_ERR -10008
#define SPEED_SSO_READ_OUTTIME_ERR -10009

#define SPEED_IP_TEST_NORMAL 0
#define SPEED_IP_TEST_SSO 1

//merge 事件 的统计key
#define RQD_MERGEVENT_UPDATE_TIME @"rqdUT"
#define RQD_MERGEVENT_EVENT_COUNT @"rqdEC"
#define RQD_MERGEVENT_TRUE_ESCAPE @"rqdTE"
#define RQD_MERGEVENT_TRUE_SIZE @"rqdTS"
#define RQD_MERGEVENT_FALSE_COUNT @"rqdFC"
#define RQD_MERGEVENT_FALSE_ESCAPE @"rqdFE"
#define RQD_MERGEVENT_FALSE_SIZE @"rqdFS"

#endif
