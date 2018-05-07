//
//  GoodsDetailedModel.h
//  ShopStore
//
//  Created by dong on 2018/4/4.
//  Copyright © 2018年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailedModel : NSObject

@property(nonatomic, strong) NSArray *content;
@property(nonatomic, strong) NSArray *images; //created_at\filename\filepath\id\view_url
@property(nonatomic, copy) NSString *tags;

@end
