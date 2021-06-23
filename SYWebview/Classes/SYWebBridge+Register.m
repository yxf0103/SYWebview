//
//  SYWebBridge+Register.m
//  SYWebview
//
//  Created by yxf on 2021/6/23.
//

#import "SYWebBridge+Register.h"
#import <objc/runtime.h>

const char reg_dic = 'r';
@interface SYWebBridge ()

@property (nonatomic,strong)NSMutableDictionary *regDic;

@end

@implementation SYWebBridge (Register)

-(NSMutableDictionary *)regDic{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &reg_dic);
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &reg_dic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dic;
}

-(void)registerKey:(NSString *)key handle:(SYWebRegisterHandle)handle{
    if (key == nil) {
        return;
    }
    self.regDic[key] = handle;
}

-(void)unRegisterKey:(NSString *)key{
    if (key == nil) {
        return;
    }
    self.regDic[key] = nil;
}

-(void)unRegisterAll{
    [self.regDic removeAllObjects];
}

-(BOOL)handleRegisterMsg:(SYWebMsg *)msg{
    SYWebRegisterHandle handle = self.regDic[msg.key];
    if (handle) {
        handle(msg.params,msg.success,msg.fail);
        return YES;
    }
    return NO;
}


@end
