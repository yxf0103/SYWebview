# SYWebview

[![CI Status](https://img.shields.io/travis/massyxf/SYWebview.svg?style=flat)](https://travis-ci.org/massyxf/SYWebview)
[![Version](https://img.shields.io/cocoapods/v/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)
[![License](https://img.shields.io/cocoapods/l/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)
[![Platform](https://img.shields.io/cocoapods/p/SYWebview.svg?style=flat)](https://cocoapods.org/pods/SYWebview)

## Description
SYWebview是一个基于wkwebview的js交互组件，实现了消息交互和回调处理.

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
1.js初始化,在js中实现
```
var bridge = SYWebInjection();
bridge.handleNativeMsg = function(key,params, success, fail) {
}
```
2.native初始化
```
_bridge = [SYWebBridge initWithWebview:webview];
 [_bridge addBridge];
 _bridge.delegate = self;
```
3.native给h5发送消息
```
SYWebMsg *msg = [SYWebMsg initwithKey:@"test" param:@{@"wahaha":@"hahaha"} webview:_bridge.webview];
[_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
    NSLog(@"成功：%@",dic);
} fail:^(NSDictionary * _Nullable dic) {
    NSLog(@"失败：%@",dic);
}];
```
4.native处理h5发过来的消息
代理模式
```
-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg{
    if ([msg.key isEqual:@"changeColor"]) {
        ...do something
        //msg.success(@{@"changeColor":@"success"});
        //msg.fail(@{@"changeColor":@"fail"});
    }
}

```
注册模式
```
[_bridge registerKey:@"h5_to_native" handle:^(NSDictionary * _Nullable dic,
                                              SYWebCallback _Nullable success,
                                              SYWebCallback _Nullable fail) {
    NSLog(@"处理h5消息:%@",dic);
    //success(@{@"msg":@"register test success"});
}];
```
5.js给native发送消息
```
bridge.h5SendToNative("h5_to_native",{msg:"jojo"},function(prams){
    //...成功的回调处理
},function(prams){
    //...失败的回调处理
});
```
6.js处理native发过来的消息
直接处理：实现1中的方法
```
bridge.handleNativeMsg = function(key,params, success, fail) {
}
```
注册模式
```
var handleTestRegister = function(params,success,fail){
    bridge.logInNative(params);
    success({"msg":"h5 handle msg success"});
};
bridge.registerFunc("native_to_h5",handleTestRegister);
```

## Author

yxf, yxfeng0103@hotmail.com

## License

SYWebview is available under the MIT license. See the LICENSE file for more info.
