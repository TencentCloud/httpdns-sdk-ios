/**
 * Copyright (c) Tencent. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MSDKDns_C11/MSDKDns.h>
//#import <MSDKDns_C11_intl/MSDKDns.h>
#if defined(__has_include)
    #if __has_include("testConfig.h")
        #include "testConfig.h"
    #endif
#endif

@interface MSDKDnsDemoTests : XCTestCase

@end

@implementation MSDKDnsDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// 测试同步解析API
- (void)syncTestGetHost :(NSString *)ipType {
    
    [[MSDKDns sharedInstance] clearCache];
    NSArray *singleRes = [[MSDKDns sharedInstance] WGGetHostByName:@"www.qq.com"];
    NSLog(@"=====singleRes=====：%@",singleRes);
    if([ipType isEqualToString:@"ipv4"]){
        XCTAssert(![singleRes[0] isEqualToString:@"0"], @"ipv4 不能等于 0");
        XCTAssert([singleRes[1] isEqualToString:@"0"], @"ipv6 必须等于 0");
    }else if([ipType isEqualToString:@"ipv6"]){
        XCTAssert([singleRes[0] isEqualToString:@"0"], @"ipv4 必须等于 0");
        XCTAssert(![singleRes[1] isEqualToString:@"0"], @"ipv6 不能等于 0");
    }else if([ipType isEqualToString:@"ipBoth"]){
        XCTAssert(![singleRes[0] isEqualToString:@"0"], @"ipv4 不能等于 0");
        XCTAssert(![singleRes[1] isEqualToString:@"0"], @"ipv6 不能等于 0");
    }
    
    
    [[MSDKDns sharedInstance] clearCache];
    NSArray *domains = @[@"youku.com",@"www.qq.com"];
    NSDictionary* singleResMultiDomain = [[MSDKDns sharedInstance] WGGetHostsByNames:domains];
    NSLog(@"=====singleResMultiDomain=====：%@",singleResMultiDomain);
    if([ipType isEqualToString:@"ipv4"]){
        XCTAssert(![singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[0]);
        XCTAssert([singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 必须等于 0", domains[0]);
        XCTAssert(![singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[1]);
        XCTAssert([singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 必须等于 0", domains[1]);
    }else if([ipType isEqualToString:@"ipv6"]){
        XCTAssert([singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 必须等于 0", domains[0]);
        XCTAssert(![singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[0]);
        XCTAssert([singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 必须等于 0", domains[1]);
        XCTAssert(![singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[1]);
    }else if([ipType isEqualToString:@"ipBoth"]){
        XCTAssert(![singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[0]);
        XCTAssert(![singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[0]);
        XCTAssert(![singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[1]);
        XCTAssert(![singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[1]);
    }
    
    
    
    [[MSDKDns sharedInstance] clearCache];
    NSArray *domains1 = @[@"www.qq.com",@"youku.com"];
    NSDictionary* multiResMultiDomain = [[MSDKDns sharedInstance] WGGetAllHostsByNames:domains1];
    NSLog(@"=====multiResMultiDomain=====：%@",multiResMultiDomain);
    NSString *firstIpv4 = multiResMultiDomain[domains1[0]][@"ipv4"][0];
    NSString *firstIpv6 = multiResMultiDomain[domains1[0]][@"ipv6"][0];
    NSString *secondIpv4 = multiResMultiDomain[domains1[1]][@"ipv4"][0];
    NSString *secondIpv6 = multiResMultiDomain[domains1[1]][@"ipv6"][0];
    if([ipType isEqualToString:@"ipv4"]){
        XCTAssert(firstIpv4 && ![firstIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
        XCTAssert(!firstIpv6 || (firstIpv6 && [firstIpv6 isEqualToString:@"0"]), @"%@ ipv6 必须等于 0", domains1[0]);
        XCTAssert(secondIpv4 && ![secondIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
        XCTAssert(!secondIpv6 || (secondIpv6 && [secondIpv6 isEqualToString:@"0"]), @"%@ ipv6 必须等于 0", domains1[0]);
    }else if([ipType isEqualToString:@"ipv6"]){
        XCTAssert(!firstIpv4 || (firstIpv4 && [firstIpv4 isEqualToString:@"0"]), @"%@ ipv4 必须等于 0", domains1[0]);
        XCTAssert(firstIpv6 && ![firstIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
        XCTAssert(!secondIpv4 || (secondIpv4 && [secondIpv4 isEqualToString:@"0"]), @"%@ ipv4 必须等于 0", domains1[0]);
        XCTAssert(secondIpv6 && ![secondIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
    }else if([ipType isEqualToString:@"ipBoth"]){
        XCTAssert(firstIpv4 && ![firstIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
        XCTAssert(firstIpv6 && ![firstIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
        XCTAssert(secondIpv4 && ![secondIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
        XCTAssert(secondIpv6 && ![secondIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
    }
}

// 测试异步解析API
- (void)asyncTestGetHost :(NSString *)ipType {
    XCTestExpectation *expectation = [self expectationWithDescription:@"操作超时。。"];
    [[MSDKDns sharedInstance] clearCache];
    [[MSDKDns sharedInstance] WGGetHostByNameAsync:@"www.qq.com" returnIps:^(NSArray *singleRes) {
        NSLog(@"==async===singleRes=====：%@",singleRes);
        if([ipType isEqualToString:@"ipv4"]){
            XCTAssert(![singleRes[0] isEqualToString:@"0"], @"ipv4 不能等于 0");
            XCTAssert([singleRes[1] isEqualToString:@"0"], @"ipv6 必须等于 0");
        }else if([ipType isEqualToString:@"ipv6"]){
            XCTAssert([singleRes[0] isEqualToString:@"0"], @"ipv4 必须等于 0");
            XCTAssert(![singleRes[1] isEqualToString:@"0"], @"ipv6 不能等于 0");
        }else if([ipType isEqualToString:@"ipBoth"]){
            XCTAssert(![singleRes[0] isEqualToString:@"0"], @"ipv4 不能等于 0");
            XCTAssert(![singleRes[1] isEqualToString:@"0"], @"ipv6 不能等于 0");
        }
        [expectation fulfill];
    }];
    
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"操作超时。。"];
    [[MSDKDns sharedInstance] clearCache];
    NSArray *domains = @[@"youku.com",@"www.qq.com"];
    [[MSDKDns sharedInstance] WGGetHostsByNamesAsync:domains returnIps:^(NSDictionary *singleResMultiDomain) {
        NSLog(@"==async===singleResMultiDomain=====：%@",singleResMultiDomain);
        if([ipType isEqualToString:@"ipv4"]){
            XCTAssert(![singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[0]);
            XCTAssert([singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 必须等于 0", domains[0]);
            XCTAssert(![singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[1]);
            XCTAssert([singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 必须等于 0", domains[1]);
        }else if([ipType isEqualToString:@"ipv6"]){
            XCTAssert([singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 必须等于 0", domains[0]);
            XCTAssert(![singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[0]);
            XCTAssert([singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 必须等于 0", domains[1]);
            XCTAssert(![singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[1]);
        }else if([ipType isEqualToString:@"ipBoth"]){
            XCTAssert(![singleResMultiDomain[domains[0]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[0]);
            XCTAssert(![singleResMultiDomain[domains[0]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[0]);
            XCTAssert(![singleResMultiDomain[domains[1]][0] isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains[1]);
            XCTAssert(![singleResMultiDomain[domains[1]][1] isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains[1]);
        }
        [expectation1 fulfill];
    }];
    
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"操作超时。。"];
    [[MSDKDns sharedInstance] clearCache];
    NSArray *domains1 = @[@"www.qq.com",@"youku.com"];
    [[MSDKDns sharedInstance] WGGetAllHostsByNamesAsync:domains1 returnIps:^(NSDictionary *multiResMultiDomain) {
        NSLog(@"==async===multiResMultiDomain=====：%@",multiResMultiDomain);
        NSString *firstIpv4 = multiResMultiDomain[domains1[0]][@"ipv4"][0];
        NSString *firstIpv6 = multiResMultiDomain[domains1[0]][@"ipv6"][0];
        NSString *secondIpv4 = multiResMultiDomain[domains1[1]][@"ipv4"][0];
        NSString *secondIpv6 = multiResMultiDomain[domains1[1]][@"ipv6"][0];
        if([ipType isEqualToString:@"ipv4"]){
            XCTAssert(firstIpv4 && ![firstIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
            XCTAssert(!firstIpv6 || (firstIpv6 && [firstIpv6 isEqualToString:@"0"]), @"%@ ipv6 必须等于 0", domains1[0]);
            XCTAssert(secondIpv4 && ![secondIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
            XCTAssert(!secondIpv6 || (secondIpv6 && [secondIpv6 isEqualToString:@"0"]), @"%@ ipv6 必须等于 0", domains1[0]);
        }else if([ipType isEqualToString:@"ipv6"]){
            XCTAssert(!firstIpv4 || (firstIpv4 && [firstIpv4 isEqualToString:@"0"]), @"%@ ipv4 必须等于 0", domains1[0]);
            XCTAssert(firstIpv6 && ![firstIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
            XCTAssert(!secondIpv4 || (secondIpv4 && [secondIpv4 isEqualToString:@"0"]), @"%@ ipv4 必须等于 0", domains1[0]);
            XCTAssert(secondIpv6 && ![secondIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
        }else if([ipType isEqualToString:@"ipBoth"]){
            XCTAssert(firstIpv4 && ![firstIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
            XCTAssert(firstIpv6 && ![firstIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
            XCTAssert(secondIpv4 && ![secondIpv4 isEqualToString:@"0"], @"%@ ipv4 不能等于 0", domains1[0]);
            XCTAssert(secondIpv6 && ![secondIpv6 isEqualToString:@"0"], @"%@ ipv6 不能等于 0", domains1[0]);
        }
        [expectation2 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:4 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    
}

# pragma mark - HTTP DES

- (void)testHTTPDesIPV4 {
    // This is an example of a functional test case.
    
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeDES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv4;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self syncTestGetHost:@"ipv4"];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self asyncTestGetHost:@"ipv4"];
}

- (void)testHTTPDesIPV6 {
    // This is an example of a functional test case.
        
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeDES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv6;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipv6"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipv6"];
    
}

- (void)testHTTPDesIPBoth {
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeDES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeDual;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipBoth"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipBoth"];
}

# pragma mark - HTTP AES

- (void)testHTTPAesIPV4 {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnsAESkey; // aes 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeAES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv4;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self syncTestGetHost:@"ipv4"];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self asyncTestGetHost:@"ipv4"];
}

- (void)testHTTPAesIPV6 {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnsAESkey; // aes 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeAES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv6;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipv6"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipv6"];
}

- (void)testHTTPAesIPBoth {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.98";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnsAESkey; // aes 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeAES;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeDual;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipBoth"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipBoth"];
}

# pragma mark - HTTPS

- (void)testHTTPSIPV4 {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.99";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeHTTPS;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv4;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self syncTestGetHost:@"ipv4"];
    
    [[MSDKDns sharedInstance] clearCache];
    
    [self asyncTestGetHost:@"ipv4"];
}

- (void)testHTTPSIPV6 {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.99";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeHTTPS;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeIPv6;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipv6"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipv6"];
}

- (void)testHTTPSIPBoth {
    // This is an example of a functional test case.
    DnsConfig *config = new DnsConfig();
    config->dnsIp = @"119.29.29.99";
#ifdef testConfig_h
    config->dnsId = TESTDnsID; // 授权 Id
    config->dnsKey = TESTDnskey; // des 加密密钥
    config->token = TESTHTTPSToken; //  https Token
#endif
    config->encryptType = HttpDnsEncryptTypeHTTPS;
//    config->debug = YES;
    config->httpOnly = YES;
    config->minutesBeforeSwitchToMain = 1;
    config->retryTimesBeforeSwitchServer = 2;
    config->enableReport = YES;
    config->addressType = HttpDnsAddressTypeDual;
    [[MSDKDns sharedInstance] initConfig: config];
    
    [[MSDKDns sharedInstance] clearCache];
    [self syncTestGetHost:@"ipBoth"];
    
    [[MSDKDns sharedInstance] clearCache];
    [self asyncTestGetHost:@"ipBoth"];
}

@end
