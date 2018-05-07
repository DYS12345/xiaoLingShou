//
//  PayWayViewController.m
//  ShopTest
//
//  Created by dong on 2017/9/13.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "PayWayViewController.h"
#import "DKNightVersion.h"
#import "PaymentCodeViewController.h"
#import "FBAPI.h"
#import "UserModel.h"
#import "SVProgressHUD.h"

@interface PayWayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinStateBtn;
@property (assign, nonatomic) NSInteger payWay; //1 weixin   2 zhifubao
@property (weak, nonatomic) IBOutlet UIButton *cashStatusBtn;

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.layer.cornerRadius = 3;
    [self.buyBtn dk_setBackgroundColorPicker:DKColorPickerWithKey(priceText)];
    
    self.showView.layer.masksToBounds = YES;
    self.showView.layer.cornerRadius = 5;
    
    self.priceLabel.text = [NSString stringWithFormat:@"应付款：￥%.2f", [self.total_money floatValue]];
    self.priceLabel.dk_textColorPicker = DKColorPickerWithKey(priceText);
    
    [self.weixinStateBtn dk_setImage:DKImagePickerWithNames(@"Selectedblack", @"red", @"red", @"SelectedGolden") forState:UIControlStateSelected];
    [self.zhifubaoStateBtn dk_setImage:DKImagePickerWithNames(@"Selectedblack", @"red", @"red", @"SelectedGolden") forState:UIControlStateSelected];
    [self.cashStatusBtn dk_setImage:DKImagePickerWithNames(@"Selectedblack", @"red", @"red", @"SelectedGolden") forState:UIControlStateSelected];
    
    self.weixinStateBtn.selected = YES;
    self.weixinStateBtn.userInteractionEnabled = NO;
    self.payWay = 1;
}

- (IBAction)buy:(id)sender {
    self.payWay = 1;
    NSDictionary *param = @{@"ship_mode" : self.ship_mode,
                            @"items" : @[@{@"rid" : self.rid,
                                           @"quantity" : self.quantity,
                                           @"deal_price" : self.total_money
                                           }],
                            @"sync_pay" : @"1",
                            @"from_client" : @"6"
                            };
    FBRequest *request = [FBAPI postWithUrlString:@"/orders/create" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"obrj  %@", result);
        if ([result[@"success"] integerValue] == 1) {
            PaymentCodeViewController *vc = [PaymentCodeViewController new];
            vc.codeUrl = result[@"data"][@"pay_params"][@"code_url"];
            vc.payWay = self.payWay;
            vc.image = self.image;
            vc.rid = result[@"data"][@"order"][@"rid"];
            vc.coin_money = self.coin_money;
            vc.freight = self.freight;
            vc.total_money = self.total_money;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", result[@"data"][@"status"][@"message"]]];    
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

- (IBAction)selectZhifubao:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"暂不开放"];
    return;
    self.payWay = 2;
    self.zhifubaoStateBtn.selected = YES;
    self.zhifubaoStateBtn.userInteractionEnabled = NO;
    self.weixinStateBtn.selected = NO;
    self.weixinStateBtn.userInteractionEnabled = YES;
    self.cashStatusBtn.selected = NO;
    self.cashStatusBtn.userInteractionEnabled = YES;
}

- (IBAction)selectWeiXin:(id)sender {
    self.payWay = 1;
    self.zhifubaoStateBtn.selected = NO;
    self.zhifubaoStateBtn.userInteractionEnabled = YES;
    self.weixinStateBtn.selected = YES;
    self.weixinStateBtn.userInteractionEnabled = NO;
    self.cashStatusBtn.selected = NO;
    self.cashStatusBtn.userInteractionEnabled = YES;
}

- (IBAction)selectCash:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"暂不开放"];
    return;
    self.payWay = 3;
    self.cashStatusBtn.selected = YES;
    self.cashStatusBtn.userInteractionEnabled = NO;
    self.zhifubaoStateBtn.selected = NO;
    self.zhifubaoStateBtn.userInteractionEnabled = YES;
    self.weixinStateBtn.selected = NO;
    self.weixinStateBtn.userInteractionEnabled = YES;
}

- (IBAction)otherClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
