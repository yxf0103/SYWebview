//
//  SYWebMsg.m
//  SYWebview
//
//  Created by yxf on 2021/6/23.
//


static NSString *const sy_web_callback = @"sy_web_callback";

/*
 msg = {
 sy_msgid:xxx,
 sy_key:xxx,
 sy_params:xxx,
 sy_success:bool
 }
 */


#import "SYWebMsg.h"

@interface SYWebMsg ()
///当前webview
@property (nonatomic,weak)WKWebView *webview;
///消息ID
@property (nonatomic,copy)NSString *msgId;
@property (nonatomic,copy)NSString *msgIdPrefix;
@property (nonatomic,assign)NSUInteger msgUniqueId;

///消息key
@property (nonatomic,copy)NSString *key;
///消息带的参数
@property (nonatomic,copy)NSDictionary *params;
///消息为回调消息时是否是成功的回调
@property (nonatomic,assign)BOOL isSuccess;

@end

@implementation SYWebMsg

+(instancetype)initWithMsg:(NSDictionary *)msg webview:(nonnull WKWebView *)webview{
    SYWebMsg *model = [[self alloc] init];
    model.msgId = msg[sy_msgid];
    model.key = msg[sy_key];
    model.params = msg[sy_params];
    model.isSuccess = [msg[sy_success] boolValue];
    model.webview = webview;
    return model;
}

+(instancetype)initwithKey:(NSString *)key param:(NSDictionary *)param webview:(WKWebView *)webview{
    SYWebMsg *model = [[self alloc] init];
    model.key = key;
    model.params = param;
    model.webview = webview;
    return model;
}

-(instancetype)init{
    if (self = [super init]) {
        _msgIdPrefix = @"0";
        _msgUniqueId = 0;
    }
    return self;
}

//MARK: getter
-(SYWebCallback)success{
    __weak typeof(self) weakSelf = self;
    return ^(NSDictionary *params){
        [weakSelf webCallback:params isSuccess:YES];
    };
}

-(SYWebCallback)fail{
    __weak typeof(self) weakSelf = self;
    return ^(NSDictionary *params){
        [weakSelf webCallback:params isSuccess:NO];
    };
}

-(NSString *)msgId{
    if (!_msgId || _msgId.length == 0) {
        _msgId = [self createMsgid];
    }
    return _msgId;
}

-(NSString *)key{
    if (!_key) {
        _key = @"";
    }
    return _key;
}


//MARK: public
-(void)sendToH5WithBridgeId:(NSString *)bridgeId{
    if (bridgeId == nil) {
        return;
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[sy_msgid] = _msgId;
    mDic[sy_params] = _params;
    mDic[sy_success] = @(_isSuccess);
    mDic[sy_key] = _key;
    
    NSMutableDictionary *bridgeDic = [NSMutableDictionary dictionary];
    bridgeDic[sy_bridge_id] = bridgeId;
    bridgeDic[sy_bridge_params] = mDic;
    
    [self sendMsgToH5:bridgeDic];
}

//MARK: custom
-(void)webCallback:(NSDictionary *)dic isSuccess:(BOOL)success{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[sy_msgid] = _msgId;
    mDic[sy_params] = dic;
    mDic[sy_success] = @(success);
    mDic[sy_key] = sy_web_callback;
    [self sendMsgToH5:mDic];
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

-(void)sendMsgToH5:(NSDictionary *)dic{
    NSString *js = [NSString stringWithFormat:@"nativeSendToH5('%@')",[self strWithDic:dic]];
    [_webview evaluateJavaScript:js completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        
    }];
}

-(NSString *)createMsgid{
    NSString *str = @"";
    @synchronized (self) {
        if (_msgUniqueId > 10000) {
            _msgIdPrefix = [NSString stringWithFormat:@"%@0",_msgIdPrefix];
            _msgUniqueId = 0;
        }
        str = [NSString stringWithFormat:@"sy_native_msg_%p_%@_%lu",self,_msgIdPrefix,_msgUniqueId];
    }
    return str;
}

@end
