//
//  StatisticalTableTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/5/9.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "StatisticalTableTableViewCell.h"
#import "UIColor+Extension.h"
#import "PaiHangbangTopTableViewCell.h"
#import "PaiHangBottomTableViewCell.h"

@implementation StatisticalTableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.borderColor = [UIColor colorWithHexString:@"#ebebec"].CGColor;
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.cornerRadius = 5;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PaiHangbangTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaiHangbangTopTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PaiHangBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaiHangBottomTableViewCell"];
}

#pragma mark ------------------------------- uitableview的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PaiHangbangTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaiHangbangTopTableViewCell"];
        return cell;
    }
    PaiHangBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaiHangBottomTableViewCell"];
    return cell;
}

@end
