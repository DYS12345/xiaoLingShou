//
//  ProductSkuModel.h
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductSkuModel : NSObject

@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *s_color;
@property (nonatomic, copy) NSString *s_model;
@property (nonatomic, copy) NSString *s_weight;
@property (nonatomic, copy) NSString *sale_price;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *stock_count;
@property (nonatomic, copy) NSString *discount_amount;
@property (nonatomic, copy) NSString *count;//选择后初始的商品数量

@end
