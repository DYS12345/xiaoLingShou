//
//  GoodsDetailModel.m
//  ShopTest
//
//  Created by dong on 2017/9/4.
//  Copyright © 2017年 dong. All rights reserved.
//

#import "GoodsDetailModelBase.h"

@implementation GoodsDetailModelBase

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"desStr" : @"description"
             };
}

@end
