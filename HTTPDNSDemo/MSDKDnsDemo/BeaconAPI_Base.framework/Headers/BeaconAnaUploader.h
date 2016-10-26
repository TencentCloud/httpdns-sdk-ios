//
//  BeaconAnaUploader.h
//  Beacon
//
//  Created by tencent on 12-3-6.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

//此协议用于确认是否可以上报，默认时随时可以，客户端可以实现这个协议以控制上报时机
@protocol AnaUploadConformer <NSObject>
- (BOOL) confirmUpload;
@end

//此协议用于接受达到最大上传数据的通知，客户端可以监听这个通知以上传数据
@protocol AnaUplaodNotifier <NSObject>
- (void) reachMaxsize;
@end

//此协议用户获取sdk的上报数据
@protocol BeaconAnaUploader <NSObject>
//提供获取上报数据的接口，上报数据转化为byte流由客户端上报
//cleanDataAtomatic为YES，那么会清除获取数据和SDK的关系（原来存在内存或db）
//cleanDataAtomatic为NO，需要回调uploadFinishWithResult去通知sdk，由SDK处理
- (NSData*) getUploadData:(BOOL) cleanDataAtomatic error:(NSError**) err;
//通知已经完成上传动作，并告知结果，后台会根据结果删除或保留相应数据
//实时事件特使处理，成功则什么释放内存，失败则把数据村道数据库
- (BOOL) uploadFinishWithResult:(BOOL) uploadSucess  error:(NSError**) err;

@optional
//执行内置模式上报
- (BOOL) doUpload;

@end

