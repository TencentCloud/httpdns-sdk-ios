//
//  HttpDnsUDP.m
//  MSDKDnsDevDemo
//
//  Created by fu chunhui on 16/7/18.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDnsUDP.h"

@implementation HttpDnsUDP

+ (id) sharedInstance{
    static HttpDnsUDP * _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HttpDnsUDP alloc] init];
    });
    return _sharedInstance;
}

-(void)startUdpTest:(NSString*)ip Port:(int)port{
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![_udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![_udpSocket beginReceiving:&error]) {
        NSLog(@"Error receiving: %@", error);
        return;
    }
    
//    NSLog(@"Ready");
    
    NSString* sendString = @"udpPackage";
    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:port withTimeout:-1 tag:0]; //发送udp
}

#pragma mark - GCDAsyncUdpSocket Delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
//    NSLog(@"didReceiveData: %@, From Address:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding]);
    //发通知给主界面，发送成功消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UDPReceive" object:nil];
    [_udpSocket close];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
//    NSLog(@"didNotConnect, withError: %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket*)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"didSendDataWithTag");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UDPSend" object:nil];
}

- (void)udpSocket:(GCDAsyncUdpSocket*)sock didNotSendDataWithTag:(long)tag dueToError:(NSError*)error
{
//    NSLog(@"didNotSendDataWithTag");
//    NSLog(@"Message not send for error: %@",error);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket*)sock withError:(NSError*)error
{
//    NSLog(@"onUdpSocketDidClose, withError: %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
//    NSLog(@"didConnectToAddress: %@", [[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding]);
}

@end