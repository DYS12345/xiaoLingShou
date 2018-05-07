//
//  PayWayViewController.h
//  ShopTest
//
//  Created by dong on 2017/9/13.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayWayViewController : UIViewController

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSString *rid;
@property(nonatomic, copy) NSString *coin_money;
@property(nonatomic, copy) NSString *freight;
@property(nonatomic, copy) NSString *total_money;
@property(nonatomic, copy) NSString *quantity;
@property(nonatomic, copy) NSString *ship_mode; //1快递方式、2自提方式

@end
