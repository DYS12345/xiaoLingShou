//
//  LoginViewController.m
//  ShopTest
//
//  Created by dong on 2017/8/30.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "FBAPI.h"
#import "FBConfig.h"
#import "UserModel.h"
#import "UIColor+Extension.h"
#import "HomeViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *psdView;
@property (weak, nonatomic) IBOutlet UIButton *psdSeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) UIView *left;
@property (nonatomic, strong) UIView *left2;

@end

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self circle:self.phoneView];
    [self circle:self.psdView];
    [self circle:self.loginBtn];
    
    [self.userNameTF setValue:[UIColor colorWithHexString:@"#02A65A"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.userNameTF.tintColor = [UIColor whiteColor];
    self.userNameTF.leftView = self.left;
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.psdTF setValue:[UIColor colorWithHexString:@"#02A65A"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.psdTF.tintColor = [UIColor whiteColor];
    self.psdTF.leftView = self.left2;
    self.psdTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.psdTF.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self login:self.loginBtn];
    return YES;
}

- (IBAction)psdSee:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.psdTF.secureTextEntry = NO;
    } else {
        self.psdTF.secureTextEntry = YES;
    }
}

-(UIView *)left{
    if (!_left) {
        _left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _left.backgroundColor = [UIColor clearColor];
    }
    return _left;
}

-(UIView *)left2{
    if (!_left2) {
        _left2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _left2.backgroundColor = [UIColor clearColor];
    }
    return _left2;
}

-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
}


- (IBAction)login:(id)sender {
//    1059232202@qq.com
//    111111
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    if (self.userNameTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"账号未填写"];
    } else if (self.psdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码位数不够"];
    } else {
        NSDictionary *params = @{
                                 @"email":self.userNameTF.text,
                                 @"password":self.psdTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:@"/auth/business_login" requestDictionary:params delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            NSLog(@"sasdsadtrtrb %@",result);
            if (![[NSString stringWithFormat:@"%@", result[@"status"][@"code"]] isEqualToString:@"200"]) {
                [SVProgressHUD showInfoWithStatus:result[@"message"]];
            } else {
                NSDictionary *dataDict = [result objectForKey:@"data"];
                UserModel *model = [UserModel mj_objectWithKeyValues:dataDict];
                model.isLogin = YES;
                model.token = result[@"data"][@"token"];
                model.psd = self.psdTF.text;
                model.store_rid = result[@"data"][@"store_rid"];
                [model saveOrUpdate];
                FBRequest *request1 = [FBAPI postWithUrlString:@"/auth/exchange_token" requestDictionary:@{@"store_rid" : result[@"data"][@"store_rid"]} delegate:self];
                [request1 startRequestSuccess:^(FBRequest *request, id result) {
                    model.access_token = result[@"data"][@"access_token"];
                    model.app_key = result[@"data"][@"app_key"];
                    [model saveOrUpdate];
                    HomeViewController *vc = [HomeViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

@end
