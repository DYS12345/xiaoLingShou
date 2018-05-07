//
//  SuccessViewController.m
//  Shop
//
//  Created by 董永胜 on 2018/4/17.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "SuccessViewController.h"
#import "UIColor+Extension.h"

@interface SuccessViewController ()

@property (weak, nonatomic) IBOutlet UIView *dayinView;//打印小票的View
@property (weak, nonatomic) IBOutlet UIView *backHomeView;//返回首页的View
@property (weak, nonatomic) IBOutlet UIView *showView;//展示用的白底view
@property (weak, nonatomic) IBOutlet UIImageView *bgImageViw; //在后面的背景图片

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dayinView.layer.masksToBounds = YES;
    self.dayinView.layer.cornerRadius = 5;
    
    self.backHomeView.layer.masksToBounds = YES;
    self.backHomeView.layer.cornerRadius = 5;
    self.backHomeView.layer.borderColor = [UIColor colorWithHexString:@"#02A65A"].CGColor;
    self.backHomeView.layer.borderWidth = 1;
    
    self.showView.layer.masksToBounds = YES;
    self.showView.layer.cornerRadius = 10;
    
    self.bgImageViw.image = self.imag;
}
#pragma mark 返回首页按钮
- (IBAction)home:(id)sender {
    //回退，然后发送通知让页面右移，然后刷新页面
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
    }];
}

#pragma mark 打印按钮
- (IBAction)dayin:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
