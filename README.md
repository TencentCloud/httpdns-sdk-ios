# HttpDns介绍 #
----

## 1. 功能介绍
### MSDKDns的主要功能是为了有效的避免由于运营商传统LocalDns解析导致的无法访问最佳接入点的方案。原理为使用Http加密协议替代传统的DNS协议，整个过程不使用域名，大大减少劫持的可能性。

> ## 注意：
> ### 如果客户端的业务是与host绑定的，比如是绑定了host的http服务或者是cdn的服务，那么在用HTTPDNS返回的IP替换掉URL中的域名以后，还需要指定下Http头的Host字段。以curl为例，假设你要访问www.qq.com，通过HTTPDNS解析出来的IP为192.168.0.111，那么通过这个方式来调用即可： curl -H "Host:www.qq.com" http://192.168.0.111/aaa.txt.


## 2. 安装包结构
压缩文件中包含demo工程，其中包含：

> 1. MSDKDns.framework：适用“Build Setting->C++ Language Dialect”配置为GNU++98，“Build Setting->C++ Standard Library”为“libstdc++(GNU C++ standard library)”的工程。

> 2. MSDKDns_C11.framework：适用于该两项配置分别为“GNU++11”和“libc++(LLVM C++ standard library with C++11 support)”的工程。

## 3. 接入步骤
### 3.1 引入依赖库
> 1. 内部APP（包括自研及代理游戏）：
MSDKDns依赖**MSDK2.14.0i及其以上版本**，接入MSDKDns之前必须接入**MSDKFoundation.framework**、**MSDK.framework**。

> 2. 外部APP：

>> 1. 已接入MSDK的应用，如上接入MSDKDns之前接入MSDKFoundation.framework、MSDK.framework即可；

>> 2. 未接入MSDK的应用，在接入MSDKDns之前必须引入，以下依赖库：
>
>>> 1. Demo中的**BeaconAPI_Base.framework**，

>>> 2. 系统公共库：
>
>>>>- libz.tdb
>>>>- libsqlite3.tdb
>>>>- libstdc++.tdb
>>>>- libstdc++.6.0.9.tdb
>>>>- libc++.tdb
>>>>- Foundation.framework
>>>>- CoreTelephony.framework
>>>>- SystemConfiguration.framework
>>>>- CoreGraphics.framework
>>>>- Security.framework
>
>>> 并在application:didFinishLaunchingWithOptions:加入注册灯塔代码
>
>
    //已正常接入MSDK的游戏无需关注以下代码，未接入MSDK的外部APP调用以下代码注册灯塔
    //******************************
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *appid = dic[@"COOPERATOR_APPID"];
    [BeaconBaseInterface setAppKey:appid];
    [BeaconBaseInterface enableAnalytics:@"" gatewayIP:nil];
    //******************************

**注意：需要在Other linker flag里加入-ObjC标志。**

### 3.2 引入MSDKDns

### 3.3 配置文件
在info.plist中配置允许http声明，具体配置如下：

| Key        | Type           | Value  |
| ------------- |-------------| -------------|
| IS_COOPERATOR | Boolean | 外部应用填“YES”<br>内部应用填“NO” |
| QQAppID | String | 腾讯内部应用对应的QQAppid |
| COOPERATOR_APPID | String | 外部应用对应的上报appid，见key_ios.txt中 |
| TIME_OUT | Number | 请求httpdns超时设定时间<br>单位：ms |
| DNS_ID | String | 参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |
| DNS_KEY | String | 参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |	
| Debug | Boolean | 日志开关配置，YES为打开MSDKDns日志，No为关闭MSDKDns日志 |	
| IS_TEST | Boolean | 测试开关配置，YES为外部业务测试专用 |

## 4. API及使用示例

### 4.1 获取IP: WGGetHostByName

#### 概述

引入头文件，调用WGGetHostByName接口会返回IP数组。

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
      使用ipv6地址进行连接时，注意格式，ipv6需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/*********

**使用建议：**
      1、ipv6为0，直接使用ipv4地址连接
      2、ipv6地址不为0，优先使用ipv6连接，如果ipv6连接失败，再使用ipv4地址进行连接
      注：返回给业务的地址格式为 ："dns=ipv4,ipv6",如果没有ipv6地址，返回为0,例如:dns=192.168.1.1,0

### 4.2 控制台日志: WGOpenMSDKDnsLog

#### 概述

游戏可以通过开关控制是否打印MSDKDns相关的Log，**注意和MSDKLog区分**。

	/**
     *
     *  @param enabled true:打开 false:关闭
     */
    void WGOpenMSDKDnsLog(bool enabled);

#### 示例代码

接口调用示例：

 	MSDKDns::GetInstance()->WGOpenMSDKDnsLog(true);

## 5. 注意事项

1. 异常情况下，httpdns可能会解析失败：

	表现形式为：WGGetHostByName接口返回为空

	解决方案：

	1. 业务再次请求一次WGGetHostByName即可，或者
	2. 走业务原本的解析逻辑。

2. 针对iOS 9以上版本，请关闭 ATS（Application Transport Secure）特性。即在info.plist中添加如下配置项：

    	<key>NSAppTransportSecurity</key>
    	<dict>
        	<key>NSAllowsArbitraryLoads</key>
        	<true/>
    	</dict>


# 实践场景 #
---

## 1. Unity接入说明

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

## 2. H5页面内元素HTTP_DNS加载

### 原理

#### 拦截网络请求

使用iOS原生的NSURLProtocol，拦截webview的网络请求。然后根据网络请求URL的文件名后缀进行过滤。拿到过滤后的URL以后，截取URL的的域名，然后进行HTTP_DNS请求。然后用结果的IP地址拼接处原有的文件网络请求。
 

### 实现方法

* 在NSURLProtocol抽象类方法startLoading中进行HttpDns解析，将域名替换成ip后进行URLConnection

		/**
		 *  让被拦截的请求执行，在此处进行HttpDns解析，将域名替换成ip后进行URLConnection
		 */
		- (void)startLoading
		{
		    NSMutableURLRequest *newRequest;
		    NSString *fileExtension = [[self.request URL] absoluteString];

		    //根据业务需求，进行png，jpg，css等格式的URL域名解析
		    if ([fileExtension containsString:@".png"] || [fileExtension containsString:@".jpg"] || [fileExtension containsString:@".css"])
		    {
		        // 修改了请求的头部信息，同步/异步请求
		        newRequest = [[H5ContentURLProtocol convertToNewRequest:self.request isSynchronous:NO] mutableCopy];
		    } else {
		        newRequest = [self.request mutableCopy];
		    }
		
		    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
		
		    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
		}
具体详见**[httpdns-ios-sdk](https://github.com/tencentyun/httpdns-ios-sdk)** 

## 3. Https场景

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
 	    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"Host"];		
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

具体详见**[httpdns-ios-sdk](https://github.com/tencentyun/httpdns-ios-sdk)** 
