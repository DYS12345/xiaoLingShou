//
//  ProductModel.m
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "ProductModel.h"
#import "MJExtension.h"

@implementation ProductModel

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{
             @"descStr" : @"description"
             };
}

@end
