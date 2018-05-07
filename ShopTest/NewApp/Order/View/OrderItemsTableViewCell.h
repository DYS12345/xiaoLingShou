//
//  OrderItemsTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/19.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSkuModel.h"

@interface OrderItemsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *skuIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePricelabel;
@property (weak, nonatomic) IBOutlet UILabel *countlabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, copy) NSString *status;

-(void)fuzhi:(ProductSkuModel*)model;
-(void)fuzhiStatus:(NSString *)status;

@end
