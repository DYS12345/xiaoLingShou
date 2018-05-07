//
//  JiesuanTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/17.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSkuModel.h"

@interface JiesuanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) ProductSkuModel *model;

@end
