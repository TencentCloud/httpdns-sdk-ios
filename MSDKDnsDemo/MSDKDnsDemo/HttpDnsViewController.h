//
//  HttpDnsViewController.h
//  MSDKDnsDevDemo
//
//  Created by Gavin on 2016-07-08.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDnsTCP.h"
#import "HttpDnsUDP.h"

@interface HttpDnsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic, readwrite) NSString* ipv4;
@property (strong, nonatomic, readwrite) NSString* ipv6;

@end
