//
//  OrderItemsJianTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/28.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "OrderItemsJianTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation OrderItemsJianTableViewCell

#pragma mark 赋值的方法
-(void)fuzhi:(ProductSkuModel *)model{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.skuIdlabel.text = model.rid;
    self.goodsNameLabel.text = model.product_name;
    if ([model.sale_price integerValue] == 0) {
        self.salePrice.text = [NSString stringWithFormat:@"￥%@", model.price];
    } else {
        self.salePrice.text = [NSString stringWithFormat:@"￥%@", model.sale_price];
    }
    self.countLabel.text = model.quantity;
    self.youhuilabel.text = [NSString stringWithFormat:@"￥%@", model.discount_amount];
    if ([model.sale_price integerValue] == 0) {
        self.paylabel.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue] - [model.discount_amount floatValue]];
    } else {
        self.paylabel.text = [NSString stringWithFormat:@"￥%.2f", [model.sale_price floatValue] - [model.discount_amount floatValue]];
    }
}

-(void)fuzhiStatus:(NSString *)status{
    if ([status integerValue] == 1) {
        self.statuslabel.text = @"已完成";
    } else {
        self.statuslabel.text = @"未完成";
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
