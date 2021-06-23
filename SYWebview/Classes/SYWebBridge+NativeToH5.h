//
//  SYWebBridge+NativeToH5.h
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWebBridge (NativeToH5)

-(void)sendMsgToH5:(NSDictionary *)params
           success:(SYWebCallback _Nullable)succback
              fail:(SYWebCallback _Nullable)failback;

-(void)handleCallbackMsg:(NSDictionary *)msg;

@end

NS_ASSUME_NONNULL_END
