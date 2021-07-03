//
//  SYViewController.m
//  SYWebview
//
//  Created by massyxf on 06/23/2021.
//  Copyright (c) 2021 massyxf. All rights reserved.
//

#import "SYViewController.h"
#import <SYWebview/SYWebBridge+NativeToH5.h>
#import <SYWebview/SYWebBridge+Register.h>

@interface SYViewController ()<SYWebBridgeDelegate>{
    SYWebBridge *_bridge;
}

@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [_bridge registerKey:@"h5_to_native" handle:^(NSDictionary * _Nullable dic,
                                                  SYWebCallback _Nullable success,
                                                  SYWebCallback _Nullable fail) {
        NSLog(@"注册方式,native处理h5消息:%@",dic);
        success(@{@"msg":@"register test success"});
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [webview loadRequest:request];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 300, 200, 40);
    [btn setTitle:@"直接发送消息" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dadaClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *regbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:regbtn];
    regbtn.backgroundColor = [UIColor redColor];
    regbtn.frame = CGRectMake(100, 400, 200, 40);
    [regbtn setTitle:@"发送register消息" forState:UIControlStateNormal];
    [regbtn addTarget:self action:@selector(regBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)dadaClick:(id)sender{
    NSLog(@"native 发送消息到 h5,普通方式");
    SYWebMsg *msg = [SYWebMsg initwithKey:@"test" param:@{@"wahaha":@"hahaha"} webview:_bridge.webview];
    [_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
        NSLog(@"h5处理 test 消息成功：%@",dic);
    } fail:^(NSDictionary * _Nullable dic) {
        NSLog(@"h5处理 test 消息失败：%@",dic);
    }];
}

-(void)regBtnClicked:(UIButton *)btn{
    NSLog(@"native 发送消息到 h5，注册方式");
    SYWebMsg *msg = [SYWebMsg initwithKey:@"native_to_h5"
                                    param:@{@"wahaha":@"hahaha"}
                                  webview:_bridge.webview];
    [_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
        NSLog(@"h5处理 register 消息 native_to_h5 成功:%@",dic);
    } fail:^(NSDictionary * _Nullable dic) {
        NSLog(@"h5处理 register 消息 native_to_h5 失败:%@",dic);
    }];
}


-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg{
    if ([msg.key isEqual:@"changeColor"]) {
        NSLog(@"代理方式,native处理h5消息:%@",msg.params);
        msg.fail(@{@"changeColor":@"fail"});
    }
}

@end
