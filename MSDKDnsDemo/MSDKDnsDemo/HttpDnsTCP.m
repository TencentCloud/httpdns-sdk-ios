//
//  HttpDnsTCP.m
//  MSDKDnsDevDemo
//
//  Created by fu chunhui on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDnsTCP.h"
@implementation HttpDnsTCP

+ (id) sharedInstance{
    static HttpDnsTCP * _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HttpDnsTCP alloc] init];
    });
    return _sharedInstance;
}

- (void)startTCPTest:(NSString *)ip Port:(int)port{
    _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_tcpSocket connectToHost:ip onPort:port error:&error];
    if (error) {
        NSLog(@"%@",error);
    }

//    NSLog(@"Ready.");
    NSString *tcpString = @"tcpPackage";
    // 把string转成NSData
    NSData *data = [tcpString dataUsingEncoding:NSUTF8StringEncoding];
    [_tcpSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"didConnectToHost:%@, Port:%d", host, port);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_TCPConnect" object:nil];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
//    NSLog(@"socketDidSecure");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"didWriteDataWithTag:%ld", tag);
    // 需要自己调用读取方法，socket才会调用代理方法读取数据
    [_tcpSocket readDataWithTimeout:-1 tag:tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_TCPSend" object:nil];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSLog(@"didReadData: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //TODO 发通知给主界面，发送成功消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_TCPReceive" object:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    NSLog(@"socketDidDisconnect with error:%@", err);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_TCPDisconnect" object:nil];
}

@end