//
//  NewOrderTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/4/19.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "NewOrderTableViewCell.h"
#import "OrderItemsTableViewCell.h"
#import "ProductSkuModel.h"
#import "MJExtension.h"
#import "OrderItemsJianTableViewCell.h"

@implementation NewOrderTableViewCell

#pragma mark 赋值的方法
-(void)fuzhi:(NewOrderModel *)model{
    self.status = model.status;
    if ([model.status integerValue] == 1) {
        self.statusLabel.text = @"已完成";
    } else {
        self.statusLabel.text = @"未完成";
    }
    self.ridLabel.text = model.rid;
    self.countLabel.text = model.total_quantity;
    self.pricelabel.text = [NSString stringWithFormat:@"￥%.2f", [model.total_amount floatValue]];
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

-(void)fuzhiAry:(NSArray *)modelAry{
    self.modelAry = modelAry;
    [self.tableView reloadData];
}

#pragma mark -----------------tableview的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        OrderItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemsTableViewCell"];
        ProductSkuModel *model = [ProductSkuModel mj_objectWithKeyValues:self.modelAry[indexPath.row]];
        [cell fuzhi:model];
        [cell fuzhiStatus:self.status];
        return cell;
    }
    OrderItemsJianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemsJianTableViewCell"];
    ProductSkuModel *model = [ProductSkuModel mj_objectWithKeyValues:self.modelAry[indexPath.row]];
    [cell fuzhi:model];
    [cell fuzhiStatus:self.status];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 130;
    }
    return 100;
}

#pragma mark 从nib中得到视图
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderItemsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderItemsJianTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderItemsJianTableViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
