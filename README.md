# SYWebview

[![CI Status](https://img.shields.io/travis/massyxf/SYWebview.svg?style=flat)](https://travis-ci.org/massyxf/SYWebview)
[![Version](https://img.shields.io/cocoapods/v/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)
[![License](https://img.shields.io/cocoapods/l/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)
[![Platform](https://img.shields.io/cocoapods/p/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)

## Description
SYWebview是一个基于wkwebview的js交互组件，实现了消息交互和回调处理.  

inspired by [WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)  

不同于WebViewJavascriptBridge使用拦截url的方式来处理消息，SYWebview使用的是WKWebview的WKScriptMessageHandler

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SYWebview is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SYWebview'
```

## How to use
### 1.native部分
#### 1.1 native初始化
```
_bridge = [SYWebBridge initWithWebview:webview];
[_bridge addBridge];
_bridge.unDefinedWebMsgHandle = ^(WKScriptMessage * _Nonnull msg) {
    NSLog(@"其它消息:%@",msg);
};
```
#### 1.2 注册方式
#### 1.2.1 注册方式,native接收H5传递来的额消息
```
[_bridge registerKey:@"h5_to_native" handle:^(NSDictionary * _Nullable dic,SYWebCallback _Nullable success,SYWebCallback _Nullable fail) {
    NSLog(@"注册方式:native收到h5消息:%@",dic);
    success(@{@"msg":@"register test success"});
}];
```
#### 1.2.2 注册方式:native发送消息到h5
```
SYWebMsg *msg = [SYWebMsg initwithKey:@"native_to_h5"
                                param:@{@"wahaha":@"hahaha"}
                                webview:_bridge.webview];
[_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
    NSLog(@"注册方式:native 发送消息到 h5 成功:%@",dic);
} fail:^(NSDictionary * _Nullable dic) {
    NSLog(@"注册方式:native 发送消息到 h5 失败:%@",dic);
}];
```
#### 1.3 非注册方式
#### 1.3.1 非注册方式,native处理h5消息
```
//MARK: SYWebBridgeDelegate
-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg{
    if ([msg.key isEqual:@"h5_to_native"]) {
        NSLog(@"非注册方式,native处理h5消息:%@",msg.params);
        msg.fail(@{@"changeColor":@"fail"});
    }
}
```
#### 1.3.2 非注册方式:native发送消息到h5
```
SYWebMsg *msg = [SYWebMsg initwithKey:@"native_to_h5" 
                                param:@{@"wahaha":@"hahaha"} 
                                webview:_bridge.webview];
[_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
    NSLog(@"非注册方式,h5处理native消息成功：%@",dic);
} fail:^(NSDictionary * _Nullable dic) {
    NSLog(@"非注册方式,h5处理native消息失败：%@",dic);
}];
```
### 2.js部分
#### 2.1 初始化
```
//sy_web_bridge是处理消息的变量 
var sy_web_bridge = SYWebInjection();
sy_web_bridge.initWebBridge();
```

#### 2.2 注册方式
#### 2.2.1 注册方式：h5处理native消息
```
var handleTestRegister = function (params, success, fail) {
    sy_web_bridge.logInNative(params);
    success({ "msg": "h5 handle msg success,注册方式" });
};
sy_web_bridge.registerFunc("native_to_h5", handleTestRegister);
```
#### 2.2.2 注册方式：h5发送消息到native
```
sy_web_bridge.h5SendToNative("h5_to_native", { msg: "jojo" }, function (prams) {
    sy_web_bridge.logInNative(prams);
}, function (prams) {
    sy_web_bridge.logInNative(prams);
});
```

#### 2.3 非注册方式
#### 2.3.1 非注册方式:h5收到native消息
```
//请自己实现这个方法
sy_web_bridge.handleNativeMsg = function (key, params, success, fail) {
    if (key == "native_to_h5") {
        sy_web_bridge.logInNative(params);
        // success({nice:"success"});
        fail({ nice: "fail" });
        return;
    }
};
```
#### 2.3.2 非注册方式:h5发送消息到native
```
sy_web_bridge.h5SendToNative("h5_to_native", { name: "color", haha: "haha" }, function (prams) {
    sy_web_bridge.logInNative(prams);
}, function (prams) {
    sy_web_bridge.logInNative(prams);
});
```

## Author

yxf, yxfeng0103@hotmail.com

## License

SYWebview is available under the MIT license. See the LICENSE file for more info.
