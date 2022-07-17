//
//  SYDelegateViewController.m
//  SYWebview_Example
//
//  Created by yxf on 2022/7/17.
//  Copyright © 2022 massyxf. All rights reserved.
//

#import "SYDelegateViewController.h"
#import <SYWebview/SYWebview.h>

@interface SYDelegateViewController ()<SYWebBridgeDelegate>{
    SYWebBridge *_bridge;
}

@end

@implementation SYDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"代理方式";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *prefences = [[WKPreferences alloc] init];
    prefences.javaScriptCanOpenWindowsAutomatically = YES;
    prefences.minimumFontSize = 30;
    config.preferences = prefences;
    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webview];
    
   _bridge = [SYWebBridge initWithWebview:webview];
    [_bridge addBridge];
    _bridge.delegate = self;
    _bridge.unDefinedWebMsgHandle = ^(WKScriptMessage * _Nonnull msg) {
        NSLog(@"其它消息:%@",msg);
    };
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"delegate_demo.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [webview loadRequest:request];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 300, 200, 40);
    [btn setTitle:@"发送非注册消息" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dadaClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)dadaClick:(id)sender{
    //非注册方式:native 发送消息到 h5
    SYWebMsg *msg = [SYWebMsg initwithKey:@"native_to_h5" param:@{@"wahaha":@"hahaha"} webview:_bridge.webview];
    [_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
        NSLog(@"非注册方式,h5处理native消息成功：%@",dic);
    } fail:^(NSDictionary * _Nullable dic) {
        NSLog(@"非注册方式,h5处理native消息失败：%@",dic);
    }];
}

//MARK: SYWebBridgeDelegate
-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg{
    if ([msg.key isEqual:@"h5_to_native"]) {
        NSLog(@"非注册方式,native处理h5消息:%@",msg.params);
        msg.fail(@{@"changeColor":@"fail"});
    }
}

@end
