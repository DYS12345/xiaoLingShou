//
//  OderInfoViewController.m
//  ShopTest
//
//  Created by dong on 2017/9/1.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "OderInfoViewController.h"
#import "UIColor+Extension.h"
#import "UIImageView+WebCache.h"
#import "UIView+FSExtension.h"
#import "FBAPI.h"
#import "PaymentCodeViewController.h"
#import "KuaiDiViewController.h"
#import "UserModel.h"
#import "DKNightVersion.h"
#import "PayWayViewController.h"
#import "SkuCollectionViewCell.h"
//#import "ZFFlowLayout.h"
#import "SVProgressHUD.h"

@interface OderInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *orderShowView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UILabel *colorCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *ziTiBtn;
@property (weak, nonatomic) IBOutlet UIButton *kuaiDiBtn;
@property (strong, nonatomic) NSMutableArray *btnAry;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showViewHeight;
@property (strong, nonatomic) NSMutableArray *flagAry;

@end

@implementation OderInfoViewController

-(NSMutableArray *)flagAry{
    if (!_flagAry) {
        _flagAry = [NSMutableArray array];
    }
    return _flagAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    
    self.price.dk_textColorPicker = DKColorPickerWithKey(priceText);
    self.ziTiBtn.dk_backgroundColorPicker = DKColorPickerWithKey(priceText);
    self.kuaiDiBtn.dk_backgroundColorPicker = DKColorPickerWithKey(priceText);
    
    self.orderShowView.layer.masksToBounds = YES;
    self.orderShowView.layer.cornerRadius = 5;
    
    self.ziTiBtn.layer.masksToBounds = YES;
    self.ziTiBtn.layer.cornerRadius = 2;
    
    self.kuaiDiBtn.layer.masksToBounds = YES;
    self.kuaiDiBtn.layer.cornerRadius = 2;
    
    self.goodsImg.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    self.goodsImg.layer.borderWidth = 1;
    NSString *imgUrl = self.modelBase.cover;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    self.goodsTitle.text = self.modelBase.name;
    NSDictionary *s = self.modelSku.items[0];
    self.price.text = [NSString stringWithFormat:@"￥%@", s[@"sale_price"]];
    self.color.text = s[@"mode"];
    
    self.btnAry = [NSMutableArray array];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SkuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SkuCollectionViewCell"];
    
//    UICollectionViewFlowLayout * flowLayout = [ZFFlowLayout flowLayoutWithFlowLayoutType:FlowLayoutType_leftAlign];
//    self.collectionView.collectionViewLayout = flowLayout;
    
    for (int i = 0; i<self.modelSku.items.count; i++) {
        [self.flagAry addObject:@"0"];
    }
    [self.flagAry replaceObjectAtIndex:0 withObject:@"1"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelSku.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SkuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SkuCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *s = self.modelSku.items[indexPath.row];
    cell.str = s[@"mode"];
    cell.selectedStr = self.flagAry[indexPath.row];
    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(colorTap:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *s = self.modelSku.items[indexPath.row];
    self.color.text = s[@"mode"];
    self.price.text = [NSString stringWithFormat:@"￥%@", s[@"price"]];
    [self.flagAry replaceObjectAtIndex:indexPath.row withObject:@"0"];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *s = self.modelSku.items[indexPath.row];
    CGFloat w = [self calculateRowWidth:s[@"mode"]]+20;
    return CGSizeMake(w, 50/2);
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 50/2)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

-(void)colorTap:(UIButton*)sender{
    for (int i = 0; i<self.modelSku.items.count; i++) {
        SkuCollectionViewCell *cell = (SkuCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.btn.selected = NO;
        cell.btn.userInteractionEnabled = YES;
    }

    self.color.text = sender.titleLabel.text;
    NSDictionary *s = self.modelSku.items[sender.tag];
    self.price.text = [NSString stringWithFormat:@"￥%@", s[@"price"]];
    [self.flagAry removeAllObjects];
    for (int i = 0; i<self.modelSku.items.count; i++) {
        [self.flagAry addObject:@"0"];
    }
    [self.flagAry replaceObjectAtIndex:sender.tag withObject:@"1"];

    sender.selected = YES;
    sender.userInteractionEnabled = NO;
}

- (IBAction)jian:(id)sender {
    NSInteger n = [self.numLabel.text integerValue];
    if (n == 0) {
        return;
    } else {
        n = n - 1;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)n];
}

- (IBAction)add:(id)sender {
    NSInteger n = [self.numLabel.text integerValue];
    n = n+1;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)n];
}

- (IBAction)otherClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ziti:(id)sender {
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD show];
    NSString *skuId = @"";
    NSString *skuMoney = @"";
    for (int i = 0; i<self.modelSku.items.count; i++) {
        NSDictionary *s = self.modelSku.items[i];
        if ([s[@"mode"] isEqualToString:self.color.text]) {
            skuId = s[@"rid"];
            skuMoney = [NSString stringWithFormat:@"%f", [s[@"price"] floatValue] * [self.numLabel.text floatValue]];
        }
    }
    
    PayWayViewController *vc = [PayWayViewController new];
    vc.ship_mode = @"2";
    vc.image = self.image;
    vc.rid = skuId;
    vc.coin_money = @"0";
    vc.freight = @"0";
    vc.total_money = skuMoney;
    vc.quantity = self.numLabel.text;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
//    UserModel *userModel = [[UserModel findAll] lastObject];
//    NSDictionary *param = @{
//                            @"target_id" : skuId,
//                            @"type" : @(2),
//                            @"n" : self.numLabel.text,
//                            @"storage_id" :userModel.storage_id
//                            };
//    FBRequest *request = [FBAPI postWithUrlString:@"/shopping/now_buy" requestDictionary:param delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        [SVProgressHUD dismiss];
//        NSDictionary *param = @{
//                                @"rrid" : result[@"data"][@"order_info"][@"_id"],
//                                @"is_nowbuy" : @(1),
//                                @"delivery_type" : @(2),
//                                @"app_type" : @(2),
//                                @"from_site" : @(11)
//                                };
//        FBRequest *request1 = [FBAPI postWithUrlString:@"/shopping/confirm" requestDictionary:param delegate:self];
//        [request1 startRequestSuccess:^(FBRequest *request, id result) {
//            NSString *ridStr = result[@"data"][@"rid"];
//            PayWayViewController *vc = [PayWayViewController new];
//            vc.image = self.image;
//            vc.rid = ridStr;
//            vc.coin_money = result[@"data"][@"coin_money"];
//            vc.freight = result[@"data"][@"freight"];
//            vc.total_money = result[@"data"][@"total_money"];
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:vc animated:YES completion:nil];
//        } failure:^(FBRequest *request, NSError *error) {
//        }];
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
}

- (IBAction)kuaiDi:(id)sender {
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD show];
    NSString *skuId = @"";
    for (int i = 0; i<self.modelSku.items.count; i++) {
        NSDictionary *s = self.modelSku.items[i];
        if ([s[@"mode"] isEqualToString:self.color.text]) {
            skuId = s[@"rid"];
        }
    }
    KuaiDiViewController *vc = [KuaiDiViewController new];
//    vc.rid = result[@"data"][@"order_info"][@"_id"];
    vc.image = self.image;
    vc.modelSku = self.modelSku;
    vc.modelBase = self.modelBase;
    vc.modelDetail = self.modelDetail;
    vc.color = self.color.text;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
//    UserModel *userModel = [[UserModel findAll] lastObject];
//    NSDictionary *param = @{
//                            @"target_id" : skuId,
//                            @"type" : @(2),
//                            @"n" : self.numLabel.text,
//                            @"storage_id" :userModel.storage_id
//                            };
//    FBRequest *request = [FBAPI postWithUrlString:@"/shopping/now_buy" requestDictionary:param delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        [SVProgressHUD dismiss];
//        KuaiDiViewController *vc = [KuaiDiViewController new];
//        vc.rid = result[@"data"][@"order_info"][@"_id"];
//        vc.image = self.image;
//        vc.modelSku = self.modelSku;
//        vc.modelBase = self.modelBase;
//        vc.modelDetail = self.modelDetail;
//        vc.color = self.color.text;
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:vc animated:YES completion:nil];
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
}

@end
