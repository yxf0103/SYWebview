//
//  SYRegisterViewController.m
//  SYWebview_Example
//
//  Created by yxf on 2022/7/17.
//  Copyright © 2022 massyxf. All rights reserved.
//

#import "SYRegisterViewController.h"
#import <SYWebview/SYWebview.h>

@interface SYRegisterViewController (){
    SYWebBridge *_bridge;
}

@end

@implementation SYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册方式";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *prefences = [[WKPreferences alloc] init];
    prefences.javaScriptCanOpenWindowsAutomatically = YES;
    prefences.minimumFontSize = 30;
    config.preferences = prefences;
    WKWebView *webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webview];
    
    _bridge = [SYWebBridge initWithWebview:webview];
    [_bridge addBridge];
    //注册方式,native接收H5传递来的额消息
    [_bridge registerKey:@"h5_to_native" handle:^(NSDictionary * _Nullable dic,
                                                  SYWebCallback _Nullable success,
                                                  SYWebCallback _Nullable fail) {
        NSLog(@"注册方式:native收到h5消息:%@",dic);
        success(@{@"msg":@"register test success"});
    }];
    _bridge.unDefinedWebMsgHandle = ^(WKScriptMessage * _Nonnull msg) {
        NSLog(@"其它消息:%@",msg);
    };
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"register_demo.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [webview loadRequest:request];
    
    UIButton *regbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:regbtn];
    regbtn.backgroundColor = [UIColor redColor];
    regbtn.frame = CGRectMake(100, 400, 200, 40);
    [regbtn setTitle:@"发送注册消息" forState:UIControlStateNormal];
    [regbtn addTarget:self action:@selector(regBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)regBtnClicked:(UIButton *)btn{
    //注册方式:native 发送消息到 h5
    SYWebMsg *msg = [SYWebMsg initwithKey:@"native_to_h5"
                                    param:@{@"wahaha":@"hahaha"}
                                  webview:_bridge.webview];
    [_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
        NSLog(@"注册方式:native 发送消息到 h5 成功:%@",dic);
    } fail:^(NSDictionary * _Nullable dic) {
        NSLog(@"注册方式:native 发送消息到 h5 失败:%@",dic);
    }];
}

@end
