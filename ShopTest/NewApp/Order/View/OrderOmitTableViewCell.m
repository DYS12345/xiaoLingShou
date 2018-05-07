//
//  OrderOmitTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/18.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "OrderOmitTableViewCell.h"
#import "UIView+FSExtension.h"

@implementation OrderOmitTableViewCell

#pragma mark 赋值的方法
-(void)fuzhi:(NewOrderModel *)model{
    self.model = model;
    if ([model.status integerValue] == 1) {
        self.statusLabel.text = @"已完成";
    } else {
        self.statusLabel.text = @"未完成";
    }
    self.ridLabel.text = model.rid;
    self.countLabel.text = model.total_quantity;
    self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.total_amount floatValue]];
    
    self.timeLabel.text = [self TimeStamp:model.created_at];
}

#pragma mark 时间戳转化时间的方法
-(NSString *)TimeStamp:(NSString *)strTime

{
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
