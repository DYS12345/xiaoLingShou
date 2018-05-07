//
//  ProductModel.h
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *cost_price;  //成本价
@property (nonatomic, copy) NSString *cover;  //封面图
@property (nonatomic, copy) NSString *descStr;  //描述
@property (nonatomic, copy) NSString *features;  //
@property (nonatomic, copy) NSString *id_code;  //
@property (nonatomic, copy) NSString *name;  //名字
@property (nonatomic, copy) NSString *price;  //原价
@property (nonatomic, copy) NSString *rid;  //
@property (nonatomic, copy) NSString *sale_price;  //折扣价

@end
