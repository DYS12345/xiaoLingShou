//
//  StatisticalChartsTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/5/9.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartsSwift.h"

@interface StatisticalChartsTableViewCell : UITableViewCell <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *xiaoshouEBtn;//销售额的那个按钮
@property (weak, nonatomic) IBOutlet UIButton *ordersBtn;//订单数的那个按钮
@property (nonatomic, assign) BOOL changeFlag;//销售额和订单切换的标志
@property (strong,nonatomic) LineChartView *lineChartView;

@end
