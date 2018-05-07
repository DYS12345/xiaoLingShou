//
//  GoodsCollectionViewCell.h
//  ShopTest
//
//  Created by dong on 2017/8/31.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RowsModel.h"
#import "ProductModel.h" //新增的商品模型
@class SearchListModel;

@interface GoodsCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) GoodsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImagView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *princeLabel;
@property(nonatomic, strong) SearchListModel *searchListModel;
@property(nonatomic, strong) ProductModel *productModel; //新增的商品模型

@end
