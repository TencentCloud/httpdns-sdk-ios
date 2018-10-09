//
//  BeaconBaseInterface.h
//  Beacon
//  
//  Created by tencent on 16/1/19.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "BeaconAnaPublicDefines.h"
#import "BeaconAnaUploader.h"

/**
 一般用法，完全交由监控sdk自行收集数据并上报
 **/
@interface BeaconBaseInterface : NSObject

//1 fetal 2 error 3 warn 4 info
//in debug version: 5 debug 10 all
+ (void)setLogLevel:(int)logLevel;

//获取当前sdk'的运行状态
+ (sdkstatus)getSDKStatus;

//得到灯塔sdk的版本
+ (NSString *)getBeaconSDKVersion;

//启用事件上报功能
+ (BOOL)enableEventRecord:(BOOL)enable;

//@end

/**
 一般的监控启动调用
 **/
//@interface AnalyticsInterface(AnalyticsNormal)

//设置sdk进行与服务器同步的延时（初次启动不会有延时，如果上次发生crash也不会延迟）
//主要是控制sdk在启动过程中占用更多资源
+ (void)setSynchServerTimerDelay:(int)delay;

//注册监控服务，将会向服务器查询策略，并初始化各个模块的默认数据上传器，参数userId为用户qua，参数gateWayIP为当前网络网关IP，不填则默认使用服务器下发的IP
+ (BOOL)enableAnalytics:(NSString *)userId gatewayIP:(NSString *)gatewayIP;

//@end

/**
 主要是微薄提的需求，没有上报和查询策略的操作，只提供数据，交由微薄自己调用接口上报
 **/
//@interface AnalyticsInterface(NoAnalyticsNetwork)

//注册监控服务，不会向服务器查询策略，需要客户端主动设置，可以调用setStrategyForMaxPkgSize
//需要客户端调用getMixDataUploader等接口自己获取数据，并在上传完成后通知sdk
//客户端可以在任意时刻调用接口获取数据，也可以注册AnaUplaodNotifier协议以便能收到sdk提供的存储数据量达到上限的通知以便能及时上传，因为sdk对存储在本地的数据量时有限制的，超过的将不予存储
+ (BOOL)enableAnalyticsWithoutNetwork:(NSString *)userId gatewayIP:(NSString *)gatewayIP;

//获取各种类型数据的上传者，从上传者那里可以得到上传的数据，
//getMixData
+ (id<BeaconAnaUploader>)getMixDataUploader;
//getRealTimeEventData
+ (id<BeaconAnaUploader>)getRealTimeEventDataUploader;


//注册一个混合数据到达上限的监听器，以便能接收信号
+ (BOOL)registMixDataUploadNotifier:(id<AnaUplaodNotifier>)notifier;
//注册一个实时事件到达上限的监听器，以便能接收信号
+ (BOOL)registRealTimeEventDataUploadNotifier:(id<AnaUplaodNotifier>)notifier;

//@end

/**
 事件上报接口
 分为实时事件和普通事件
 **/
//@interface AnalyticsInterface(UserEventUpload)

//用户事件上报通用接口，该接口会保存用户事件到本地，根据上报策略择机上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL)onUserAction:(NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;

//实时用户事件上报通用接口，该接口会保存用户事件实时上报
//event 事件名称 isSucceed 事件执行是否成功 elapse 事件执行耗时，单位ms size 上报包大小，单位kb params 其他参数，用户自定义
+ (BOOL)onDirectUserAction: (NSString *)eventName isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;
// 1.8.7 立即上报接口
+ (BOOL)onDirectUserAction: (NSString *)eventName isImmediately:(BOOL)isImmediately isSucceed:(BOOL)isSucceed elapse:(long)elapse size:(long)size params:(NSDictionary *)params;

//设置实时事件上报的间隔,默认为1分钟,单位是分钟  最小1分钟 最大10分钟
+ (BOOL)setRealTimeEventUploadDuration:(int)minitues;
//!!!
//!!!注意，设置时间太小会带来更多的网络请求，占用更多系统资源，在实时事件使用比较频繁的情况下会带来更多风险
//!!!
+ (void)setUserRealEventDurationSecond:(int)seconds ;

//设置实时事件上报的最大累计上报条数（满足条数即上报)
//默认分别为10，保护区间<=50 >＝5
+ (BOOL)setRealTimeEventUploaMaxCount:(int)maxPkgSize;

//@end

/**
  用户相关属性设置
 **/
//@interface AnalyticsInterface(UserPorperty)

//设置appKey（灯塔事件）
+ (void)setAppKey:(NSString *)appKey;

//设置一个GUID的标识,用以通过GUID标识和分类异常用户信息
+ (void)setGUID:(NSString *)guid;

//更换用户时设置userId,一般是QQ号
+ (void)setUserId:(NSString *)userId;

//QIMEI
+ (void)setQIMEI:(NSString *)qimei;
+ (NSString *)getQIMEI;

//sessionid 设置sessionid可以帮您区分哪些事件属于同一次会话
+ (void)setSessionid:(NSString *)sessionid;
+ (NSString *)getSessionid;

//设置MSF的appId
+ (void)setAppId:(NSString*)appId;

//设置渠道（灯塔事件）
+ (void)setChannelId:(NSString*)chanId;

//设置SDK的版本号，宿主appVersion设置到A95扩展字段
+ (void)setSDKVersion:(NSString *)bundleVer;

//设置联系方式 ,only for crash report
+ (void)setContact:(NSString *)contact;

//设置appVersion
+ (void)setAppVersion:(NSString *)bundleVer;

+ (void)setGatewayIp:(NSString *)gateWayIp;

//重新设置db路径并且重组数据库,可以在analytics启动之后动态设置
+ (BOOL)setDBPathAndReBuild:(NSString *)dbPath error:(NSError *)err;

//重新设置db路径,必须在enableAnalytics之前调用
+ (BOOL)setDBPath:(NSString *)dbPath;
//@end

/**
 能够控制策略的接口
 **/
//该开关为YES的时候会在本地策略生效的时候就开启功能开关（测速／异常），等服务器策略生效后再更新一次
//如果为NO那么会等到服务器策略生效后才开启功能开关
//影响范围：服务器策略生效之前的事件记录和异常处理函数的问题注册
+ (BOOL)enableModuleFunctionBeforeSeverStrategy:(BOOL)enable;

//设置事件上报的最大累计上报条数（满足条数即上报)，及本地数据库的最大容量（超过限额不予存储）
//默认分别为50 200，保护区间20～100, 100～200
//注意：采用默认调用方式，sdk会在与服务器通讯获取策略后更新本地策略，所以该模式下调用该API无效
+ (BOOL)setStrategyForMaxPkgSize:(int)maxPkgSize dbMaxSize:(int)dbMaxSize;

//设置每天最多执行测速的次数，默认是-1不加限制
+ (BOOL)setDayMaxSpeedTrackCount:(int)count;


//@interface AnalyticsInterface (QZoneDefinedEvent)

//登录事件
+ (BOOL)onLogin: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//上传图片事件
+ (BOOL)onUploadPicture: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写日志事件
+ (BOOL)onWriteBlog: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

//启动事件
+ (BOOL)onStart: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//写操作
+ (BOOL)onWrite: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//刷新操作
+ (BOOL)onRefresh: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;
//界面渲染
+ (BOOL)onRender: (BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params;

//@end


/**
 测试接口，只在Test的模式下生效
 **/
// 这是控查询serverUlr
+ (BOOL)setAnalyticsServer:(NSString *)serverUrl;

//开启和关闭灯塔上报（包括属性采集／启动上报／退出事件／使用状况上报）
+ (BOOL)setEnableBeaconReport:(BOOL)enabled;

/**
 通用参数, 设置所有事件都会带的参数
 **/
+ (void)setAdditionalInfo:(NSDictionary *)dic;

//1.8.4
/**
 * wifi上报控制
 */
+ (void)isOnlyWifiUpload:(BOOL)yesOrNo;

/**
 * 只在wifi下上报事件接口
 */
+ (BOOL)onUserAction: (NSString*) eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params isOnlyWifiUpload:(BOOL)isOnlyWifiUpload;
+ (BOOL)onDirectUserAction: (NSString*) eventName isSucceed:(BOOL) isSucceed elapse:(long) elapse size:(long) size params:(NSDictionary *) params isOnlyWifiUpload:(BOOL)isOnlyWifiUpload;

/**
 * 临时关掉灯塔上报, 达到上报条件的事件先存数据库
 */
+ (void)setEventUploadClose:(BOOL)isClose;

// 1.9.0
/**
 * 实时联调测试功能
 * @param yesOrNo 是否开启实时联调，默认为NO
 */
+ (void)setAccessTest:(BOOL)yesOrNo;

//2.3.4
/**
 * 事件接口总开关
 * @param isEventUpOnOff 默认为YES
 */
+ (void)setEventUpOnOff:(BOOL)isEventUpOnOff;

/**
 * 业务事件接口开关
 * @param isBizEventUpload 默认为YES
 */
+ (void)setBizEventUpload:(BOOL)isBizEventUpload;

/**
 * 是否开启后台上报
 * @param isBackgroundUp 默认为YES
 */
+ (void)setBackgroundUp:(BOOL)isBackgroundUp;

/**
 * 是否开启ATS，默认是开启
 */
+ (void)setAtsEnable:(BOOL)isAtsEnable;

/**
 * 路径分析功能开启/关闭接口，默认开启此功能
 */
+ (void)enblePagePath:(BOOL)yesOrNo;

/**
 * Socket上报开启/关闭接口，默认开启
 */
+ (void)setSocketOnOff:(BOOL)yesOrNo;

/*************** 精简版 *****************/
/**
 * 手动心跳上报接口
 * 正常情况下无需调用,只有越狱情况下一直在后台运行的应用可每天调用一次
 */
+ (void)heartEventUpload;

/**
 网速监控和统计接口
 **/
//@interface AnalyticsInterface(NetFlowData)
+ (BOOL)enableNetFlowRecord:(BOOL)enalbe;
//获取当月已用总流量
+ (long)getCurrentMonthTotalNetFlow;
//获取当天已用总流量
+ (long)getToDayUsedNetFlow;
//清零流量数据
+ (BOOL)cleanNetFlowData;
//设置日最高流量
+ (BOOL)setDayMaxUpFlow:(long)dayFlow;

// 1.8.7
/**
 * SDK自身质量上报开关, 默认YES
 */
+ (void)enableSDKQuaUpload:(BOOL)enable;

/**
 * SDK logId上报开关, 默认NO
 */
+ (void)enableLogIdUpload:(BOOL)enable;
/************************************/

@end
