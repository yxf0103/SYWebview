//
//  SYWebBridge+NativeToH5.m
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge+NativeToH5.h"
#import <objc/runtime.h>

const char msg_dic = 'm';
static NSUInteger msg_unique_id = 1;

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

-(void)sendMsgToH5:(NSDictionary *)params success:(SYWebCallback _Nullable)succback fail:(SYWebCallback _Nullable)failback{
    NSString *msgId = [self createMsgid];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    newDic[@"callbackId"] = msgId;
    newDic[@"params"] = params;
    
    SYWebNativeCallback *nativeBack = [SYWebNativeCallback new];
    nativeBack.success = succback;
    nativeBack.fail = failback;
    self.msgDic[msgId] = nativeBack;
    
    NSString *js = [NSString stringWithFormat:@"nativeSendToH5('%@')",[self strWithDic:newDic]];
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        
    }];
}

-(void)handleCallbackMsg:(NSDictionary *)msg{
    NSString *msgId = msg[@"msgId"];
    BOOL success = [msg[@"issuccess"] boolValue];
    NSDictionary *param = msg[@"param"];
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

-(NSString *)createMsgid{
    NSString *str = @"";
    @synchronized (self) {
        str = [NSString stringWithFormat:@"sy_native_msg_%lu_%p",(unsigned long)msg_unique_id,self];
        msg_unique_id += 1;
    }
    return str;
}


@end
