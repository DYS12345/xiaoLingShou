//
//  OderInfoViewController.h
//  ShopTest
//
//  Created by dong on 2017/9/1.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "GoodsSkussModel.h"
#import "GoodsDetailedModel.h"
#import "GoodsDetailModelBase.h"

@interface OderInfoViewController : UIViewController

@property(nonatomic, strong) UIImage *image;
@property (nonatomic, strong) GoodsSkussModel *modelSku;
@property (nonatomic, strong) GoodsDetailedModel *modelDetail;
@property (nonatomic, strong) GoodsDetailModelBase *modelBase;

@end
