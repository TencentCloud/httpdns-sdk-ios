//
//  H5ContentURLProtocol.h
//  NSURLProtocolExample
//
//  Created by Gavin on 2016-06-30.
//  Copyright (c) 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5ContentURLProtocol : NSURLProtocol

+(id) sharedProtocol;
+ (NSURLRequest *)convertToNewRequest:(NSURLRequest *)oldRequest;
@end
