//
//  GoodsSkussModel.h
//  ShopStore
//
//  Created by dong on 2018/4/4.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sku.h"

@interface GoodsSkussModel : NSObject

@property (nonatomic, strong) NSArray *colors; //name, valid
@property (nonatomic, strong) NSArray *items; // cost_price, cover, mode, price, product_name, rid, s_color, s_model, s_weight, sale_price, stock_count

@end
