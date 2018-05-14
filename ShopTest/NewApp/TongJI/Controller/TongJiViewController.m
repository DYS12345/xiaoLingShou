//
//  TongJiViewController.m
//  Shop
//
//  Created by 董永胜 on 2018/4/27.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "TongJiViewController.h"
#import "NumericalSummariesTableViewCell.h"
#import "FBConfig.h"
#import "StatisticalChartsTableViewCell.h"
#import "StatisticalTableTableViewCell.h"

@interface TongJiViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TongJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NumericalSummariesTableViewCell" bundle:nil] forCellReuseIdentifier:@"NumericalSummariesTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatisticalChartsTableViewCell" bundle:nil] forCellReuseIdentifier:@"StatisticalChartsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatisticalTableTableViewCell" bundle:nil] forCellReuseIdentifier:@"StatisticalTableTableViewCell"];
}

#pragma mark ------------------ uitableviewdelegate  datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return (SCREEN_WIDTH-60-20-140)/3*0.46;
    } else if (indexPath.row == 1) {
        return (SCREEN_WIDTH-60-140)*0.375;
    } else if (indexPath.row == 2) {
        return 96/2+40*4+30;//这里以后要根据获取到的数据条数来设置
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        StatisticalChartsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalChartsTableViewCell"];
        return cell;
    } else if (indexPath.row == 2) {
        StatisticalTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableTableViewCell"];
        return cell;
    }
    NumericalSummariesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumericalSummariesTableViewCell"];
    return cell;
}

@end
