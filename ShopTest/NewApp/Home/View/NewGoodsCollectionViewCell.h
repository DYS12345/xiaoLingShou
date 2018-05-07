//
//  NewGoodsCollectionViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/13.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface NewGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView; //商品的图片
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;//商品的名称
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;//商品的现销售价格
@property (weak, nonatomic) IBOutlet UILabel *price;//注销的销售价格
@property (weak, nonatomic) IBOutlet UIButton *addBtn; //商品添加按钮
@property(nonatomic, strong) ProductModel *productModel; //新增的商品模型

@end
