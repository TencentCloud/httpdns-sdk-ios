//
//  HttpDnsUDP.h
//  MSDKDnsDevDemo
//
//  Created by fu chunhui on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#ifndef HttpDnsUDP_h
#define HttpDnsUDP_h
#import "GCDAsyncUdpSocket.h"

@interface HttpDnsUDP : NSObject <GCDAsyncUdpSocketDelegate>{
    GCDAsyncUdpSocket* _udpSocket;
}

-(void)startUdpTest:(NSString*)ip Port:(int)port;

+ (id) sharedInstance;

@end

#endif /* HttpDnsUDP_h */
