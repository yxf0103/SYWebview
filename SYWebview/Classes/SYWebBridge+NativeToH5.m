//
//  SYWebBridge+NativeToH5.m
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge+NativeToH5.h"
#import <objc/runtime.h>

const char msg_dic = 'm';

@interface SYWebNativeCallback : NSObject

@property (nonatomic,copy)SYWebCallback success;
@property (nonatomic,copy)SYWebCallback fail;

@end

@implementation SYWebNativeCallback

@end


@interface SYWebBridge ()

@property (nonatomic,strong)NSMutableDictionary *msgDic;

@end

@implementation SYWebBridge (NativeToH5)

-(NSMutableDictionary *)msgDic{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &msg_dic);
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &msg_dic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

-(void)sendMsgToH5:(SYWebMsg *)msg success:(SYWebCallback)succback fail:(SYWebCallback)failback{
    SYWebNativeCallback *nativeBack = [SYWebNativeCallback new];
    nativeBack.success = succback;
    nativeBack.fail = failback;
    self.msgDic[msg.msgId] = nativeBack;
    [msg send];
}

-(void)handleCallbackMsg:(SYWebMsg *)msg{
    NSString *msgId = msg.msgId;
    BOOL success = msg.isSuccess;
    NSDictionary *param = msg.params;
    SYWebNativeCallback *callback = self.msgDic[msgId];
    self.msgDic[msgId] = nil;
    if (callback == nil) { return; }
    if (success) {
        if (callback.success) {
            callback.success(param);
        }
        return;
    }
    if (callback.fail) {
        callback.fail(param);
    }
}




@end
