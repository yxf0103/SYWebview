//
//  SYWebBridge.h
//  SYWebKit
//
//  Created by yxf on 2021/6/22.
//

#import <Foundation/Foundation.h>
#import "SYWebMsg.h"

NS_ASSUME_NONNULL_BEGIN

@class SYWebBridge;
@protocol SYWebBridgeDelegate <NSObject>

-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg;

@end

@interface SYWebBridge : NSObject

@property (nonatomic,weak)id<SYWebBridgeDelegate> delegate;
@property (nonatomic,weak,readonly)WKWebView *webview;
///展示日志，默认为YES
@property (nonatomic,assign)BOOL showLog;

+(instancetype)initWithWebview:(WKWebView *)webview;

-(void)addBridge;
-(void)removeBridge;

@end

NS_ASSUME_NONNULL_END
