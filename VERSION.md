
==============================修改历史============================================ 1.0.7.6

【代码变更】

1. 去掉外层函数中不必要的超时等待逻辑
2. 梳理逻辑，增加必要的日志打印，及注释

==============================修改历史============================================ 1.0.7.5

【代码变更】

1. 去掉不必要的加解密功能
2. 未配置TIME_OUT项时，默认给1s
3. 修正上报逻辑，修复上报时dns字段为空的情况
4. 新增unity接入文件
5. 新增IS_TEST配置项

==============================修改历史============================================ 1.0.7.4

【代码变更】

1. 返回结果更改为以下格式：固定返回长度为2的std::vector<unsigned char*>，其中，第一个值为解析到的ipv4地址；第二个值为解析到的ipv6地址，如不存在，则为0。

2. 增加日志开关配置项

3. 上报接口改为非实时上报接口

==============================修改历史============================================ 1.0.7.3

【代码变更】

1. 增加异常处理代码

==============================修改历史============================================ 1.0.7.2

【代码变更】

1. 如果plist文件中未配置TIME_OUT，默认为3s


==============================修改历史============================================ 1.0.7.1

【代码变更】

1. 修复偶现bug

==============================修改历史============================================ 1.0.7

【代码变更】

1. 更换灯塔版本，兼容MSDK2.14及以上版本

	灯塔初始化代码更改为：

    	//已正常接入MSDK的游戏无需关注以下代码，未接入MSDK的外部APP调用以下代码注册灯塔
    	//******************************
    	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    	NSString *appid = dic[@"COOPERATOR_APPID "];
    	[BeaconBaseInterface setAppKey:appid];
    	[BeaconBaseInterface enableAnalytics:@"" gatewayIP:nil];
    	//******************************

2. 支持only-ipv6

==============================修改历史============================================ 1.0.6

【代码变更】

1. 接口调用方式改回同步方式

2. 修复返回时偶现随机字符串的bug

==============================修改历史============================================ 1.0.5

【代码变更】

1. 接口调用方式改为异步回调方式

==============================修改历史============================================ 1.0.4

【代码变更】

1. 支持外部游戏调用。

2. 外部游戏接入说明(内部游戏无需关注)：

2.1 引入Demo中的MSDK.framework和MSDKFoundation.framework以及MSDKDns.framework

2.2 在info.plist添加如下配置项


| Key        | Type           | Value  |
| ------------- |-------------| -------------|
| IS_COOPERATOR | Boolean | 外部应用填“YES”<br>内部应用填“NO” |
| QQAppID | String | 腾讯内部应用对应的QQAppid |
| COOPERATOR_APPID | String | 外部应用对应的上报appid，见key_ios.txt中 |
| TIME_OUT | Number | 请求httpdns超时设定时间<br>单位：ms |
| DNS_ID | String | 参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |
| DNS_KEY | String | 参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |	

2.3 在AppDelegate.m中引入头文件 #import &lt;MSDK/MSDK.h&gt;

2.4 在application:didFinishLaunchingWithOptions:加入注册灯塔代码

    //已正常接入MSDK的游戏无需关注以下代码，未接入MSDK的游戏调用以下代码注册灯塔
    //******************************
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *appid = dic[@"QQAppID"];
    [AnalyticsInterface setAppKey:appid];
    [AnalyticsInterface enableAnalytics:@"" gatewayIP:nil];
    //******************************

2.5 在需要使用Dns的地方引入Dns头文件#import &lt;MSDKDns/MSDKDns.h&gt;，传入域名调用接口，具体调用可参考Demo中DnsVC.m dnsButtonDidClicked:方法


==============================修改历史============================================ 1.0.3

【代码变更】

1.支持iOS9编译，支持bitcode。

2.支持分线程调用。


==============================修改历史============================================ 1.0.2

【代码变更】

1.修改灯塔上报字段、上报逻辑。

2.修正LocalDns解析域名错误的问题。


==============================修改历史============================================ 1.0.0

【代码变更】

1.【NEW】新增如下两个接口：

     /**
     *
     *  @param domain 域名
     *  @return 查询到的IP数组，超时（3s）或者未未查询到返回空数组
     */
    std::vector<unsigned char*> WGGetHostByName(unsigned char* domain);
    
    /**
     *  Log开关
     *  @param enabled true:打开 false:关闭
     */
    void WGOpenMSDKDnsLog(bool enabled);

【注意事项】

1. MSDKDns.framework依赖于MSDK2.4.0i及其以上版本。