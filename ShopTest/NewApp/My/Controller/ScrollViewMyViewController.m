//
//  ScrollViewMyViewController.m
//  Shop
//
//  Created by 董永胜 on 2018/4/23.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "ScrollViewMyViewController.h"
#import "FBAPI.h"
#import "UserModel.h"
#import "BaseNavController.h"
#import "LoginViewController.h"

@interface ScrollViewMyViewController ()

@end

@implementation ScrollViewMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 退出登录的方法
- (IBAction)logOut:(id)sender {
    //创建网络请求对象，调用接口，成功后清空usermodel的数据表，回到登录的界面
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/logout" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"ifhvn  %@", result);
        if ([result[@"status"][@"code"] integerValue] == 401) {
            [UserModel clearTable];
            BaseNavController *navVC = [[BaseNavController alloc] initWithRootViewController:[LoginViewController new]];
            [self presentViewController:navVC animated:YES completion:nil];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

@end
