//
//  GoodsDetailModel.h
//  ShopTest
//
//  Created by dong on 2017/9/4.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "Sku.h"

@interface GoodsDetailModelBase : NSObject

@property (nonatomic, strong) NSDictionary *brand;
@property (nonatomic, copy) NSString *cost_price;
@property (nonatomic, copy) NSString *desStr;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *features;
@property (nonatomic, copy) NSString *id_code;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *name;

@end
