//
//  SYWebBridge+NativeToH5.h
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWebBridge (NativeToH5)

/// native发送消息到h5
/// @param msg native消息
/// @param succback 成功的回调
/// @param failback 失败的回调
-(void)sendMsgToH5:(SYWebMsg *)msg
           success:(SYWebCallback _Nullable)succback
              fail:(SYWebCallback _Nullable)failback;


/// native发送消息到h5之后，h5处理完毕之后出发的回调事件
/// @param msg h5发送来的回调消息
-(void)handleCallbackMsg:(SYWebMsg *)msg;

@end

NS_ASSUME_NONNULL_END
