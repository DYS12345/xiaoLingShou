//
//  OrderItemsJianTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/28.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSkuModel.h"

@interface OrderItemsJianTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *skuIdlabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuilabel;
@property (weak, nonatomic) IBOutlet UILabel *paylabel;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;

-(void)fuzhi:(ProductSkuModel*)model;
-(void)fuzhiStatus:(NSString *)status;

@end
