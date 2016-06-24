# httpdns-ios-sdk
# MSDKDns介绍 #
----

## 1. 功能介绍
### MSDKDns的主要功能是为了提升手游用户接入体验，有效的避免由于运营商传统LocalDns解析导致的无法访问最佳接入点的方案。原理为使用Http加密协议替代传统的DNS协议，整个过程不使用域名，大大减少劫持的可能性。

> ## 注意：
> ### 如果客户端的业务是与host绑定的，比如是绑定了host的http服务或者是cdn的服务，那么在用HTTPDNS返回的IP替换掉URL中的域名以后，还需要指定下Http头的Host字段。以curl为例，假设你要访问www.qq.com，通过HTTPDNS解析出来的IP为192.168.0.111，那么通过这个方式来调用即可： curl -H "Host:www.qq.com" http://192.168.0.111/aaa.txt.


## 2. 安装包结构
压缩文件中包含demo工程，其中包含：

> - MSDKDns.framework：适用“Build Setting->C++ Language Dialect”配置为GNU++98，“Build Setting->C++ Standard Library”为“libstdc++(GNU C++ standard library)”的工程。

> - MSDKDns_C11.framework：适用于该两项配置分别为“GNU++11”和“libc++(LLVM C++ standard library with C++11 support)”的工程。

## 3. 接入步骤
### 3.1 引入依赖库
> - 内部APP（包括自研及代理游戏）：
MSDKDns依赖MSDK2.14.0i及其以上版本，接入MSDKDns之前必须接入MSDKFoundation.framework、MSDK.framework。

> - 外部APP：

>> -  已接入MSDK的应用，如上接入MSDKDns之前接入MSDKFoundation.framework、MSDK.framework即可；

>> - 未接入MSDK的应用，在接入MSDKDns之前必须引入Demo中的BeaconAPI_Base.framework，并在application:didFinishLaunchingWithOptions:加入注册灯塔代码
>
>
    //已正常接入MSDK的游戏无需关注以下代码，未接入MSDK的外部APP调用以下代码注册灯塔
    //******************************
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *appid = dic[@"COOPERATOR_APPID "];
    [BeaconBaseInterface setAppKey:appid];
    [BeaconBaseInterface enableAnalytics:@"" gatewayIP:nil];
    //******************************

### 3.2 引入MSDKDns

### 3.3 配置文件
在info.plist中配置允许http声明，具体配置如下：

| Key        | Type           | Value  |
| ------------- |:-------------:| -----------------:|
| IS_COOPERATOR      | Boolean | 外部应用填“YES”<br>内部应用填“NO” |
| QQAppID      | String      |   腾讯内部应用对应的QQAppid |
| COOPERATOR_APPID | String      |    外部应用对应的上报appid，见key_ios.txt中 |
| TIME_OUT | Number      |    请求httpdns超时设定时间<br>单位：ms |
| DNS_ID | String      |    参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |
| DNS_KEY | String      |    参照版本包中key_ios.txt文件中相应内容填写即可(腾讯内部应用可以不填) |	

## 4. API及使用示例

### 4.1 获取IP: WGGetHostByName

#### - 概述

引入头文件，调用WGGetHostByName接口会返回IP数组。

    /**
     *
     *  @param domain 域名
     *  @return 查询到的IP数组，超时（3s）或者未未查询到返回空数组
     */
    std::vector<unsigned char*> WGGetHostByName(unsigned char* domain);

#### - 示例代码

接口调用示例：

	std::vector<unsigned char*> ipsVector = MSDKDns::GetInstance()->WGGetHostByName((unsigned char *)"www.qq.com");
    if (ipsVector.size() > 0){
        unsigned char* ip = ipsVector[0];
        //Use ip to do something.
    }


### 4.2 控制台日志: WGOpenMSDKDnsLog

#### - 概述

游戏可以通过开关控制是否打印MSDKDns相关的Log，**注意和MSDKLog区分**。

	/**
     *
     *  @param enabled true:打开 false:关闭
     */
    void WGOpenMSDKDnsLog(bool enabled);

#### - 示例代码

接口调用示例：

 	MSDKDns::GetInstance()->WGOpenMSDKDnsLog(true);

## 5. 注意事项

1. 当httpdns解析失败时，WGGetHostByName接口会返回为空，此时业务再次请求一次即可，或者走业务原本的解析逻辑。