//
//  SelectGoodsInfoTableViewCell.m
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "SelectGoodsInfoTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SelectGoodsInfoTableViewCell

-(void)skuInfo:(ProductSkuModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.label.text = [NSString stringWithFormat:@"%@", model.product_name];
    if (model.s_model.length == 0) {
        self.skuLabel.text = [NSString stringWithFormat:@"%@", model.s_color];
    } else {
        self.skuLabel.text = [NSString stringWithFormat:@"%@ %@", model.s_color, model.s_model];
    }
    if ([model.sale_price integerValue] == 0) {
        self.salePriceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    } else {
        self.salePriceLabel.text = [NSString stringWithFormat:@"¥%@", model.sale_price];
    }
    self.countLabel.text = model.count;
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
