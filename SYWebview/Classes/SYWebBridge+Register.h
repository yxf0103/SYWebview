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

-(void)registerKey:(NSString *)key handle:(SYWebRegisterHandle)handle;

-(void)unRegisterKey:(NSString *)key;
-(void)unRegisterAll;

-(BOOL)handleRegisterMsg:(SYWebMsg *)msg;

@end

NS_ASSUME_NONNULL_END
