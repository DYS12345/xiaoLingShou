//
//  OrderItemsTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/19.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "OrderItemsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation OrderItemsTableViewCell

#pragma mark 赋值的方法
-(void)fuzhi:(ProductSkuModel *)model{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.skuIdLabel.text = model.rid;
    self.productNameLabel.text = model.product_name;
    if ([model.sale_price integerValue] == 0) {
        self.salePricelabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    } else {
        self.salePricelabel.text = [NSString stringWithFormat:@"￥%@", model.sale_price];
    }
    self.countlabel.text = model.quantity;
    self.youhuiLabel.text = [NSString stringWithFormat:@"￥%@", model.discount_amount];
    if ([model.sale_price integerValue] == 0) {
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue] - [model.discount_amount floatValue]];
    } else {
        self.salePricelabel.text = [NSString stringWithFormat:@"￥%.2f", [model.sale_price floatValue] - [model.discount_amount floatValue]];
    }
}

-(void)fuzhiStatus:(NSString *)status{
    if ([status integerValue] == 1) {
        self.statusLabel.text = @"已完成";
    } else {
        self.statusLabel.text = @"未完成";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
