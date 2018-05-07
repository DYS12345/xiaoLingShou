//
//  NewOrderTableViewCell.h
//  Shop
//
//  Created by 董永胜 on 2018/4/19.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewOrderModel.h"

@interface NewOrderTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *shouBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ridLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *modelAry;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;//右边线的View
@property (weak, nonatomic) IBOutlet UIView *rightLineView;//右边线的View

-(void)fuzhi:(NewOrderModel*)model;
-(void)fuzhiAry:(NSArray *)modelAry;

@end
