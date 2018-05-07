//
//  NewOrderModel.h
//  Shop
//
//  Created by 董永胜 on 2018/4/18.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewOrderModel : NSObject

@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *rid;
@property(nonatomic, copy) NSString *total_quantity;
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, copy) NSString *total_amount;
@property(nonatomic, copy) NSString *created_at;

@end
