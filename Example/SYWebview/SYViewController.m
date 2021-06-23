//
//  SYViewController.m
//  SYWebview
//
//  Created by massyxf on 06/23/2021.
//  Copyright (c) 2021 massyxf. All rights reserved.
//

#import "SYViewController.h"
#import <SYWebview/SYWebBridge+NativeToH5.h>

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [webview loadRequest:request];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 300, 80, 40);
    [btn setTitle:@"dada" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dadaClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)dadaClick:(id)sender{
    SYWebMsg *msg = [SYWebMsg initwithKey:@"test" param:@{@"wahaha":@"hahaha"} webview:_bridge.webview];
    [_bridge sendMsgToH5:msg success:^(NSDictionary * _Nullable dic) {
        NSLog(@"成功：%@",dic);
    } fail:^(NSDictionary * _Nullable dic) {
        NSLog(@"失败：%@",dic);
    }];
}

-(void)bridge:(SYWebBridge *)bridge receiveWebMsg:(SYWebMsg *)msg{
    if ([msg.key isEqual:@"changeColor"]) {
        //msg.success(@{@"changeColor":@"success"});
        msg.fail(@{@"changeColor":@"fail"});
    }
}

@end
