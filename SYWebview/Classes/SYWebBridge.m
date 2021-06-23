//
//  SYWebBridge.m
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge.h"
#import "SYWebBridge+NativeToH5.h"

static NSString *const sy_msg_from_web = @"msgFromH5";

@interface SYWebBridge ()<WKScriptMessageHandler>

@property (nonatomic,weak)WKWebView *webview;

@end

@implementation SYWebBridge

-(instancetype)init{
    if (self = [super init]) {
        _showLog = YES;
    }
    return self;
}

+(instancetype)initWithWebview:(WKWebView *)webview{
    SYWebBridge *bridge = [[self alloc] init];
    bridge.webview = webview;
    return bridge;
}

-(void)addBridge{
    [_webview.configuration.userContentController addScriptMessageHandler:self name:sy_msg_from_web];
}

-(void)removeBridge{
    [_webview.configuration.userContentController removeScriptMessageHandlerForName:sy_msg_from_web];
}

//MARK: WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@",message.body);
    if ([message.name isEqualToString:sy_msg_from_web] && [message.body isKindOfClass:NSDictionary.class]) {
        NSDictionary *params = message.body;
        NSString *msgId = params[@"callbackId"];
        NSDictionary *alParams = params[@"params"];
        NSString *name = alParams[@"key"];
        if ([name isEqualToString:@"sy_nativeCallback"]) {
            [self handleCallbackMsg:alParams];
            return;
        }
        if ([name isEqualToString:@"sy_web_log"] && _showLog) {
            NSLog(@"web日志:%@",params);
            return;
        }
        NSDictionary *realParams = alParams[@"param"];
        if ([_delegate respondsToSelector:@selector(bridge:receiveWebMsg:params:success:fail:)]) {
            __weak typeof(self) weakSelf = self;
            [_delegate bridge:self receiveWebMsg:name params:realParams
                      success:^(NSDictionary * _Nullable sucDic) {
                [weakSelf webCallback:sucDic msgid:msgId isSuccess:YES];
            } fail:^(NSDictionary * _Nullable failDic) {
                [weakSelf webCallback:failDic msgid:msgId isSuccess:NO];
            }];
        }
        return;
    }
}

//MARK: custom func
-(void)webCallback:(NSDictionary *)dic msgid:(NSString *)msgid isSuccess:(BOOL)success{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[@"callbackId"] = msgid;
    mDic[@"params"] = dic;
    mDic[@"isSucCallback"] = @(success);
    NSString *js = [NSString stringWithFormat:@"syWebcallback('%@')",[self strWithDic:mDic]];
    [_webview evaluateJavaScript:js completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        
    }];
}

-(NSString *)strWithDic:(NSDictionary *)dic{
    if (dic == nil) {
        return @"";
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if (data == nil) {
        NSLog(@"参数转换出现错误:%@",error);
        return @"";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
