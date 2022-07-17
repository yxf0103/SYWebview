//
//  SYViewController.m
//  SYWebview
//
//  Created by massyxf on 06/23/2021.
//  Copyright (c) 2021 massyxf. All rights reserved.
//

#import "SYViewController.h"
#import "SYRegisterViewController.h"
#import "SYDelegateViewController.h"

@interface SYViewController ()

@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 200, 200, 40);
    [btn setTitle:@"注册方式" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *regbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:regbtn];
    regbtn.backgroundColor = [UIColor redColor];
    regbtn.frame = CGRectMake(100, 300, 200, 40);
    [regbtn setTitle:@"非注册方式" forState:UIControlStateNormal];
    [regbtn addTarget:self action:@selector(nomralBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: action
-(void)registerBtnClicked{
    SYRegisterViewController *registerVc = [SYRegisterViewController new];
    [self.navigationController pushViewController:registerVc animated:YES];
}

-(void)nomralBtnClicked{
    SYDelegateViewController *delegateVc = [SYDelegateViewController new];
    [self.navigationController pushViewController:delegateVc animated:YES];
}

@end
