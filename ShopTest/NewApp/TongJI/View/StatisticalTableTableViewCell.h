//
//  StatisticalTableTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/5/9.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalTableTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
