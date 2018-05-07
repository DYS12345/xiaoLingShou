//
//  GoodsDetailViewController.m
//  ShopTest
//
//  Created by dong on 2017/9/1.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "OderInfoViewController.h"
#import "FBAPI.h"
#import "UIColor+Extension.h"
#import "FBConfig.h"
#import "UIImageView+WebCache.h"
#import "UIView+FSExtension.h"
#import "DKNightVersion.h"
#import "SVProgressHUD.h"
#import "UserModel.h"
#import "BaseNavController.h"
#import "LoginViewController.h"
#import "GoodsViewController.h"
#import "GoodsDetailModelBase.h"
#import "GoodsDetailedModel.h"
#import "GoodsSkussModel.h"
#import "UserModel.h"

@interface GoodsDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescreb;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (nonatomic, strong) GoodsDetailModelBase *modelBase;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIView *goodsDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsDetailViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnTop;
@property (nonatomic, strong) GoodsDetailedModel *goodsModel;
@property (nonatomic, strong) GoodsSkussModel *goodsModelSkuss;

@end

@implementation GoodsDetailViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.priceLabel.dk_textColorPicker = DKColorPickerWithKey(priceText);
    self.buyBtn.dk_backgroundColorPicker = DKColorPickerWithKey(priceText);
    
    self.pageLabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:0.4];
    self.pageLabel.layer.masksToBounds = YES;
    self.pageLabel.layer.cornerRadius = 15;
    
    [self.closeBtn dk_setBackgroundColorPicker:DKColorPickerWithKey(priceText)];
    self.closeBtn.layer.masksToBounds = YES;
    self.closeBtn.layer.cornerRadius = 15;
    
    self.rateLabel.layer.masksToBounds = YES;
    self.rateLabel.layer.cornerRadius = 1;
    self.rateLabel.layer.borderWidth = 1;
    self.rateLabel.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    //获取基础信息
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
    NSString *str = [NSString stringWithFormat:@"/products/%@", self.infoId];
    FBRequest *request = [FBAPI getWithUrlString:str requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        NSLog(@"opppgnpnp  %@", result);
        self.modelBase = [GoodsDetailModelBase mj_objectWithKeyValues:result[@"data"]];
        
        self.goodsTitle.text = self.modelBase.name;
        self.goodsDescreb.text = self.modelBase.desStr;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.modelBase.price];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
//    详细信息
    NSString *str1 = [NSString stringWithFormat:@"/products/%@/detail", self.infoId];
    FBRequest *request1 = [FBAPI getWithUrlString:str1 requestDictionary:nil delegate:self];
    [request1 startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"o'g'n  %@", result);
        self.goodsModel = [GoodsDetailedModel mj_objectWithKeyValues:result[@"data"]];
        NSArray *ary = self.goodsModel.images;
        for (int i = 0; i<ary.count; i++) {
            UIImageView *imageview=[[UIImageView alloc]init];
            [imageview sd_setImageWithURL:[NSURL URLWithString:ary[i][@"view_url"]] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
            //            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.scrollView addSubview:imageview];
        }
        
        UITapGestureRecognizer * privateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
        privateLetterTap.numberOfTouchesRequired = 1; //手指数
        privateLetterTap.numberOfTapsRequired = 1; //tap次数
        [self.scrollView addGestureRecognizer:privateLetterTap];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*ary.count, SCREEN_HEIGHT);
        [self.scrollView flashScrollIndicators];
        if (ary.count == 0) {
            self.pageLabel.text = [NSString stringWithFormat:@"%@/%lu", @"0", (unsigned long)ary.count];
            self.leftBtn.userInteractionEnabled = NO;
            self.rightBtn.userInteractionEnabled = NO;
        } else {
            self.pageLabel.text = [NSString stringWithFormat:@"%@/%lu", @"1", (unsigned long)ary.count];
            self.leftBtn.userInteractionEnabled = YES;
            self.rightBtn.userInteractionEnabled = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    //商品的sku列表
    UserModel *usermodel = [[UserModel findAll] lastObject];
    NSDictionary *paramSkuList = @{@"rid" : self.infoId, @"store_rid" : usermodel.store_rid};
    FBRequest *request2 = [FBAPI getWithUrlString:@"/products/skus" requestDictionary:paramSkuList delegate:self];
    [request2 startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsModelSkuss = [GoodsSkussModel mj_objectWithKeyValues:result[@"data"]];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    self.scrollView.delegate = self;
}

- (void)tapAvatarView: (UITapGestureRecognizer *)gesture{
    NSInteger n = 1;
    if (self.goodsDetailViewBottom.constant == 0) {
        n = -125;
    } else {
        n = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.goodsDetailViewBottom.constant = n;
        if (self.pageLabelTop.constant == -33) {
            self.pageLabelTop.constant = 30;
            self.closeBtnTop.constant = 28;
        } else {
            self.pageLabelTop.constant = -33;
            self.closeBtnTop.constant = -33;
        }
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)close:(id)sender {
    if (self.flagCategory == 2) {
        UserModel *model = [[UserModel findAll] lastObject];
        BaseNavController *navVC;
        if (!model.isLogin) {
            navVC = [[BaseNavController alloc] initWithRootViewController:[LoginViewController new]];
        } else {
            navVC = [[BaseNavController alloc] initWithRootViewController:[GoodsViewController new]];
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buy:(id)sender {
    if (self.goodsModelSkuss.items.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"商品信息不全，无法购买"];
        return;
    }
    
    OderInfoViewController *vc = [OderInfoViewController new];
    vc.image = [self fullScreenshots];
    vc.modelSku = self.goodsModelSkuss;
    vc.modelDetail = self.goodsModel;
    vc.modelBase = self.modelBase;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)left:(id)sender {
    CGFloat x = self.scrollView.contentOffset.x;
    if (x == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(x-SCREEN_WIDTH, self.scrollView.contentOffset.y);
        }];
    }
}

- (IBAction)right:(id)sender {
    CGFloat x = self.scrollView.contentOffset.x;
    if (x == (self.goodsModel.images.count-1)*SCREEN_WIDTH) {
        return;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(x+SCREEN_WIDTH, self.scrollView.contentOffset.y);
        }];
    }
}

-(UIImage*)fullScreenshots{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%lu", x/SCREEN_WIDTH+1, (unsigned long)self.goodsModel.images.count];
}

@end
