//
//  SelectGoodsInfoTableViewCell.h
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSkuModel.h"

@interface SelectGoodsInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;//名字
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//商品图
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *jian; //商品数量减少的按钮
@property (weak, nonatomic) IBOutlet UIButton *add; //商品数量添加的按钮

-(void)skuInfo:(ProductSkuModel*)model;

@end
