//
//  JiesuanTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/17.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "JiesuanTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation JiesuanTableViewCell

-(void)setModel:(ProductSkuModel *)model{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.goodsNameLabel.text = model.product_name;
    self.skuLabel.text = [NSString stringWithFormat:@"%@ %@", model.s_color, model.s_model];
    if ([model.sale_price integerValue] == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.sale_price];
    }
    self.countLabel.text = [NSString stringWithFormat:@"数量 %@", model.count];
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
