//
//  HttpDnsTCP.h
//  MSDKDnsDevDemo
//
//  Created by fu chunhui on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#ifndef HttpDnsTCP_h
#define HttpDnsTCP_h
#import "GCDAsyncSocket.h"

@interface HttpDnsTCP : NSObject <GCDAsyncSocketDelegate>{
    GCDAsyncSocket* _tcpSocket;
}

-(void)startTCPTest:(NSString*)ip Port:(int)port;

+ (id) sharedInstance;

@end

#endif /* HttpDnsTCP_h */
