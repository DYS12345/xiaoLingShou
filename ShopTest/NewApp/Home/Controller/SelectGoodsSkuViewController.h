//
//  SelectGoodsSkuViewController.h
//  Shop
//
//  Created by 董永胜 on 2018/4/12.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface SelectGoodsSkuViewController : UIViewController

@property (nonatomic, strong) NSArray *modelAry;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView; // 背景图
@property (nonatomic, strong) UIImage *bgImg; // 背景图
@property (nonatomic, strong) ProductModel *model; // 商品的基本信息的模型

-(void)fuzhi:(ProductModel*)model;//传递过来的商品基本信息模型的方法，进行赋值

@end
