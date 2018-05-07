//
//  GoodsCollectionViewCell.m
//  ShopTest
//
//  Created by dong on 2017/8/31.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DKNightVersion.h"
#import "SearchListModel.h"

@interface GoodsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *piceLabel;

@end

@implementation GoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.contentView.layer.borderWidth = 1;

    self.bgView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.titleLabel.dk_textColorPicker = DKColorPickerWithKey(GoodsTEXT);
    self.princeLabel.dk_textColorPicker = DKColorPickerWithKey(priceText);
}

#pragma mark 新增的商品模型赋值方法
-(void)setProductModel:(ProductModel *)productModel{
    [self.goodsImagView sd_setImageWithURL:[NSURL URLWithString:productModel.cover] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
    self.goodsTitle.text = productModel.name;
    if ([productModel.sale_price floatValue] == 0) {
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", productModel.price] attributes:attribtDic];
        self.princeLabel.attributedText = attribtStr;
    } else {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", productModel.sale_price] attributes:attribtDic];
        
        // 赋值
        self.princeLabel.attributedText = attribtStr;
    }
}

-(void)setModel:(GoodsModel *)model{
    [self.goodsImagView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
    self.goodsTitle.text = model.name;
    if ([model.sale_price floatValue] == 0) {
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", model.price] attributes:attribtDic];
        self.princeLabel.attributedText = attribtStr;
    } else {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", model.sale_price] attributes:attribtDic];
        
        // 赋值
        self.princeLabel.attributedText = attribtStr;
    }
}

-(void)setSearchListModel:(SearchListModel *)searchListModel{
    [self.goodsImagView sd_setImageWithURL:[NSURL URLWithString:searchListModel.cover_url] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
    self.goodsTitle.text = searchListModel.title;
//    self.princeLabel.text = [NSString stringWithFormat:@"￥%@", searchListModel.price];
}

@end
