//
//  SYWebBridge.m
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import "SYWebBridge.h"
#import "SYWebBridge+NativeToH5.h"
#import "SYWebBridge+Register.h"

static NSString *const sy_msg_from_web = @"syMsgFromH5";

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
    NSString *jsStr = [self injectionJs];
    if (jsStr.length > 0) {
        //注入时机是在webview加载状态WKUserScriptInjectionTimeAtDocumentStart、WKUserScriptInjectionTimeAtDocumentEnd
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [_webview.configuration.userContentController addUserScript:userScript];
    }
    
    [_webview.configuration.userContentController addScriptMessageHandler:self name:sy_msg_from_web];
}

-(void)removeBridge{
    [_webview.configuration.userContentController removeScriptMessageHandlerForName:sy_msg_from_web];
}

-(NSString *)injectionJs{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *jsName = @"SYWebInjection.js";
    NSString *jspath = [bundle pathForResource:jsName ofType:nil];
    if (jspath == nil) {
        NSString *bundlepath = [bundle pathForResource:@"SYWebview.bundle" ofType:nil];
        bundle = [NSBundle bundleWithPath:bundlepath];
        jspath = [bundle pathForResource:jsName ofType:nil];
    }
    if (jspath == nil) {
        return @"";
    }
    return [NSString stringWithContentsOfFile:jspath encoding:NSUTF8StringEncoding error:nil];
}


//MARK: WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:sy_msg_from_web] && [message.body isKindOfClass:NSDictionary.class]) {
        NSDictionary *params = message.body;
        SYWebMsg *msgModel = [SYWebMsg initWithMsg:params webview:_webview];
        //native发送消息到h5收到的回调
        if ([msgModel.key isEqualToString:@"sy_nativeCallback"]) {
            [self handleCallbackMsg:msgModel];
            return;
        }
        //打印h5日志
        if ([msgModel.key isEqualToString:@"sy_web_log"] && _showLog) {
            NSLog(@"web日志:%@",msgModel.params);
            return;
        }
        //处理注册过的消息
        if ([self handleRegisterMsg:msgModel]) {
            return;
        }
        if ([_delegate respondsToSelector:@selector(bridge:receiveWebMsg:)]) {
            [_delegate bridge:self receiveWebMsg:msgModel];
        }
        return;
    }
    NSLog(@"其他消息：%@",message.body);
}

@end
