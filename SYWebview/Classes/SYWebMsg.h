//
//  SYWebMsg.h
//  SYWebview
//
//  Created by yxf on 2021/6/23.
//


#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const sy_msgid = @"sy_msgid";
static NSString *const sy_key = @"sy_key";
static NSString *const sy_params = @"sy_params";
static NSString *const sy_success = @"sy_success";

typedef void (^SYWebCallback)(NSDictionary *_Nullable);

@interface SYWebMsg : NSObject

///消息ID
@property (nonatomic,copy,readonly)NSString *msgId;
///消息key
@property (nonatomic,copy,readonly)NSString *key;
///消息带的参数
@property (nonatomic,copy,readonly)NSDictionary *params;
///消息为回调消息时是否是成功的回调
@property (nonatomic,assign,readonly)BOOL isSuccess;


@property (nonatomic,copy,readonly)SYWebCallback success;
@property (nonatomic,copy,readonly)SYWebCallback fail;

+(instancetype)initWithMsg:(NSDictionary *)msg webview:(WKWebView *)webview;
+(instancetype)initwithKey:(NSString *)key param:(NSDictionary *)param webview:(WKWebView *)webview;

-(void)send;

@end

NS_ASSUME_NONNULL_END
