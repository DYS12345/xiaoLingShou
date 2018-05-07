//
//  OrderOmitTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/18.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewOrderModel.h"

@interface OrderOmitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (nonatomic, strong) NewOrderModel *model;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ridLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)fuzhi:(NewOrderModel*)model;

@end
