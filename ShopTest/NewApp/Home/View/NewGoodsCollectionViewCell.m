//
//  NewGoodsCollectionViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/13.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "NewGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsImageView.layer.masksToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 5;
}

#pragma mark 新增的商品模型赋值方法
-(void)setProductModel:(ProductModel *)productModel{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:productModel.cover] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
    self.goodsTitle.text = productModel.name;
    if ([productModel.sale_price integerValue] == 0) {
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", [productModel.price floatValue]];
        self.price.hidden = YES;
    } else {
        self.goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", [productModel.sale_price floatValue]];
        self.price.hidden = NO;
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f", [productModel.price floatValue]] attributes:attribtDic];
    self.price.attributedText = attribtStr;
}

@end
