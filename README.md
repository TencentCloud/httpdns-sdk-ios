# HTTPDNS iOS客户端接入文档（腾讯云客户专用） #
----
**本接入文档供腾讯云客户参阅**

**腾讯内部业务，请参阅文档[HTTPDNS iOS客户端接入文档（腾讯内部业务专用）.md](https://github.com/tencentyun/httpdns-ios-sdk/blob/master/HTTPDNS%20iOS%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%8E%A5%E5%85%A5%E6%96%87%E6%A1%A3%EF%BC%88%E8%85%BE%E8%AE%AF%E5%86%85%E9%83%A8%E4%B8%9A%E5%8A%A1%E4%B8%93%E7%94%A8%EF%BC%89.md)**
## GitHub目录结构说明

| 目录名称       | 说明           | 适用范围  |
| ------------- |-------------| -------------|
| HTTPDNSDemo | iOS客户端使用HttpDns api示例Demo | 所有业务 |
| HTTPDNSLibs | HTTPDNS iOS SDK目录 | 所有业务 |
| HTTPDNSUnityDemo | Unity工程使用HttpDns api示例Demo | 使用Unity引擎的业务 |
| HTTPDNS iOS客户端接入文档（腾讯云客户专用）.docx | HTTPDNS iOS客户端接入文档（腾讯云客户专用） | 腾讯云客户 |
| HTTPDNS iOS客户端接入文档（腾讯内部业务专用）.docx | HTTPDNS iOS客户端接入文档（腾讯内部业务专用） | 腾讯内部业务 |
| HTTPDNS iOS客户端接入文档（腾讯内部业务专用）.md | HTTPDNS iOS客户端接入文档（腾讯内部业务专用） | 腾讯内部业务 |
| README.md | HTTPDNS iOS客户端接入文档 | 腾讯云客户 |
| VERSION.md | HTTPDNS iOS SDK历史版本修改记录 | SDK开发维护人员 |

## 1. 功能介绍

### HttpDns的主要功能是为了有效的避免由于运营商传统LocalDns解析导致的无法访问最佳接入点的方案。原理为使用Http加密协议替代传统的DNS协议，整个过程不使用域名，大大减少劫持的可能性。


## 2. 安装包结构
压缩文件中包含demo工程，其中包含：

| 名称       | 适用说明           |
| ------------- |-------------|
| MSDKDns.framework | 适用“Build Setting->C++ Language Dialect”配置为**“GNU++98”**，“Build Setting->C++ Standard Library”为**“libstdc++(GNU C++ standard library)”**的工程。 |
| MSDKDns_C11.framework | 适用于该两项配置分别为**“GNU++11”**和**“libc++(LLVM C++ standard library with C++11 support)”**的工程。 |

## 3. 接入步骤
### 3.1 引入依赖库
#### 3.1.1 已接入灯塔（Beacon）的业务
仅需引入位于HTTPDNSLibs目录下的MSDKDns.framework（或MSDKDns_C11.framework，根据工程配置选其一）即可。
#### 3.1.2 未接入灯塔（Beacon）的业务
- 引入依赖库（位于HTTPDNSLibs目录下）：
	- BeaconAPI_Base.framework
	- MSDKDns.framework（或MSDKDns_C11.framework，根据工程配置选其一）
- 引入系统库：
	- libz.tdb
	- libsqlite3.tdb
	- libstdc++.tdb
	- libstdc++.6.0.9.tdb
	- libc++.tdb
	- Foundation.framework
	- CoreTelephony.framework
	- SystemConfiguration.framework
	- CoreGraphics.framework
	- Security.framework
- 并在application:didFinishLaunchingWithOptions:加入注册灯塔代码：

	    //已正常接入灯塔的业务无需关注以下代码，未接入灯塔的业务调用以下代码注册灯塔
		//******************************
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
		NSString *appid = dic[@"COOPERATOR_APPID"];
		[BeaconBaseInterface setAppKey:appid];
		[BeaconBaseInterface enableAnalytics:@"" gatewayIP:nil];
		//******************************

**注意：需要在Other linker flag里加入-ObjC标志。**

### 3.2 配置文件
在info.plist中进行配置如下：

| Key        | Type           | Value  |
| ------------- |-------------| -------------|
| IS_COOPERATOR | Boolean | YES |
| COOPERATOR_APPID | String | 接入时由系统或者管理员分配。 |
| TIME_OUT | Number | 请求httpdns的超时设定时间单位：ms<br>如未设置，默认为1000ms |
| DNS_ID | String | 接入时由系统或者管理员分配。 |
| DNS_KEY | String | 接入时由系统或者管理员分配。 |	
| Debug | Boolean | 日志开关配置：<br>YES为打开HttpDns日志；<br>No为关闭HttpDns日志。 |	
| IS_TEST | Boolean | 测试开关配置：<br>YES为供业务测试专用；<br>正式使用时，请设置为NO |

## 4. API及使用示例

### 4.1 获取IP: WGGetHostByName

#### 概述

引入头文件，调用WGGetHostByName接口会返回IP数组。

返回的地址格式为std::vector<unsigned char*>，固定长度为2，其中第一个值为ipv4地址，第二个值为ipv6地址。以下为返回格式的详细说明：

- [ipv4, 0]：一般业务使用的情景中，绝大部分均会返回这种格式的结果，即不存在ipv6地址，仅返回ipv4地址给业务；
- [ipv4, ipv6]：发生在ipv6环境下，ipv6及ipv4地址均会返回给业务；
- [0, 0]：在极其少数的情况下，会返回该格式给业务，此时httpdns与localdns请求均超时，业务重新调用WGGetHostByName接口即可。

	    /**
	     *
	     *  @param domain 域名
	     *  @return 查询到的IP数组，返回长度为2的数组，其中第一个值为解析到的ipv4地址；第二个值为解析到的ipv6地址，如不存在，则为0
	     *  注意：超时（1s）或者未查询到返回空数组
	     */
	    std::vector<unsigned char*> WGGetHostByName(unsigned char* domain);

#### 示例代码

接口调用示例：

	std::vector<unsigned char*> ipsVector = MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)"www.qq.com");
    if (ipsVector.size() > 1){
        NSString* ipv4 = [NSString stringWithUTF8String:(const char*)result[0]];
        NSString* ipv6 = [NSString stringWithUTF8String:(const char*)result[1]];
        if (![ipv6 isEqualToString:@"0"]) {
            //使用建议：当ipv6地址存在时，优先使用ipv6地址
			//TODO 使用ipv6地址进行连接，注意格式，ipv6需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/
        } else {
           //使用ipv4地址进行连接
        }
    }

**注意：
      注意：使用ipv6地址进行URL请求时，需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/*********

**使用建议：**
      1、ipv6为0，直接使用ipv4地址连接
      2、ipv6地址不为0，优先使用ipv6连接，如果ipv6连接失败，再使用ipv4地址进行连接
      注：返回给业务的地址格式为 ："dns=ipv4,ipv6",如果没有ipv6地址，返回为0,例如:dns=192.168.1.1,0

### 4.2 控制台日志: WGOpenMSDKDnsLog

#### 概述

业务可以通过开关控制是否打印HttpDns相关的Log。

	/**
     *
     *  @param enabled true:打开 false:关闭
     */
    void WGOpenMSDKDnsLog(bool enabled);

#### 示例代码

接口调用示例：

 	MSDKDns::GetInstance()->WGOpenMSDKDnsLog(true);

## 5. 注意事项

1. 如果客户端的业务是与host绑定的，比如是绑定了host的http服务或者是cdn的服务，那么在用HTTPDNS返回的IP替换掉URL中的域名以后，还需要指定下Http头的host字段。

	- 以NSURLConnection为例：

			NSURL* httpDnsURL = [NSURL URLWithString:@”使用解析结果ip拼接的URL”];
			float timeOut = 设置的超时时间;
			NSMutableURLRequest* mutableReq = [NSMutableURLRequest requestWithURL:httpDnsURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: timeOut];
			[mutableReq setValue:@"原域名" forHTTPHeaderField:@"host"];
			NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:mutableReq delegate:self];
			[connection start];

	- 以curl为例：

		假设你要访问www.qq.com，通过HTTPDNS解析出来的IP为192.168.0.111，那么通过这个方式来调用即可：

			curl -H "host:www.qq.com" http://192.168.0.111/aaa.txt.

2. 如发现编译时报错: **"string file not found"**，将调用WGGetHostByName接口的.m文件，后缀名改为.mm即可。

3. 针对iOS 9以上版本，请关闭 ATS（Application Transport Secure）特性。即在info.plist中添加如下配置项：

    	<key>NSAppTransportSecurity</key>
    	<dict>
        	<key>NSAllowsArbitraryLoads</key>
        	<true/>
    	</dict>


# 实践场景 #
---

## 1. Unity工程接入

1. 在cs文件中进行接口声明：

		#if UNITY_IOS
        [DllImport("__Internal")]
		private static extern string WGGetHostByName(string domain);
		#endif

2. 在需要进行域名解析的部分，调用**WGGetHostByName(string domain)**方法，并建议进行如下处理：

		string ips = WGGetHostByName(domainStr);
		string[] sArray=ips.Split(new char[] {';'}); 
		if (sArray != null && sArray.Length > 1) {
			if (!sArray[1].Equals("0")) {
				//使用建议：当ipv6地址存在时，优先使用ipv6地址
				//TODO 使用ipv6地址进行连接，注意格式，ipv6需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/
				
			} else {
				//使用ipv4地址进行连接
				
			}
		}

3. 将unity工程打包为xcode工程，并按如上说明，引入依赖库等操作即可。

## 2. Https场景下使用HttpDns解析结果

### 原理

在进行证书校验时，将IP替换成原来的域名，再进行证书验证。

### Demo示例

以NSURLConnection接口为例：

	#pragma mark - NSURLConnectionDelegate		
 			
 	- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust		
 	                  forDomain:(NSString *)domain		
 	{		
 	    /*		
 	     * 创建证书校验策略		
 	     */		
 	    NSMutableArray *policies = [NSMutableArray array];		
 	    if (domain) {		
 	        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];		
 	    } else {		
 	        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];		
 	    }		
 	    		
 	    /*		
 	     * 绑定校验策略到服务端的证书上		
 	     */		
 	    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);		
 	    		
 	    /*		
 	     * 评估当前serverTrust是否可信任，		
 	     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed		
 	     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html		
 	     * 关于SecTrustResultType的详细信息请参考SecTrust.h		
 	     */		
 	    SecTrustResultType result;		
 	    SecTrustEvaluate(serverTrust, &result);		
 	    		
 	    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);		
 	}		
 			
 	- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge		
 	{		
 	    if (!challenge) {		
 	        return;		
 	    }		
 	    		
 	    /*		
 	     * URL里面的host在使用HTTPDNS的情况下被设置成了IP，此处从HTTP Header中获取真实域名		
 	     */		
 	    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];		
 	    if (!host) {		
 	        host = self.request.URL.host;		
 	    }		
 	    		
 	    /*		
 	     * 判断challenge的身份验证方法是否是NSURLAuthenticationMethodServerTrust（HTTPS模式下会进行该身份验证流程），		
 	     * 在没有配置身份验证方法的情况下进行默认的网络请求流程。		
 	     */		
 	    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])		
 	    {		
 	        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {		
 	            /*		
 	             * 验证完以后，需要构造一个NSURLCredential发送给发起方		
 	             */		
 	            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];		
 	            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];		
 	        } else {		
 	            /*		
 	             * 验证失败，取消这次验证流程		
 	             */		
 	            [[challenge sender] cancelAuthenticationChallenge:challenge];		
 	        }		
 	    } else {		
 	        /*		
 	         * 对于其他验证方法直接进行处理流程		
 	         */		
 	        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];		
 	    }		
 	}
