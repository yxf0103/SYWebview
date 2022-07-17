//
//  SYWebBridge+Register.h
//  SYWebview
//
//  Created by yxf on 2021/6/23.
//

#import <SYWebview/SYWebBridge.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SYWebRegisterHandle)(NSDictionary * _Nullable,
                                   SYWebCallback _Nullable,
                                   SYWebCallback _Nullable);

@interface SYWebBridge (Register)


/// 注册消息，native处理
/// @param key 消息名称
/// @param handle handle
-(void)registerKey:(NSString *)key handle:(SYWebRegisterHandle)handle;

/// 删除某个消息处理
/// @param key 消息名称
-(void)unRegisterKey:(NSString *)key;

/// 删除所有消息处理
-(void)unRegisterAll;

/// 判断是否是注册的消息，是的话就处理
/// @param msg h5发送来的消息
-(BOOL)handleRegisterMsg:(SYWebMsg *)msg;

@end

NS_ASSUME_NONNULL_END
