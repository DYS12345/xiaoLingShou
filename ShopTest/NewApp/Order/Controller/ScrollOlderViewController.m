//
//  ScrollOlderViewController.m
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "ScrollOlderViewController.h"
#import "NewOrderTableViewCell.h"
#import "OrderOmitTableViewCell.h"
#import "FBAPI.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "NewOrderModel.h"
#import "MJExtension.h"
#import "UIColor+Extension.h"

@interface ScrollOlderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellFlagAry;//cell的标志的数组，0为矮的cell，1为高的cell
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) NSString *currentPage;
@property (nonatomic, strong) NSArray *modelAry;//模型数组，就是tableView的数据源

@end

@implementation ScrollOlderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(55);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(62-13);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-62+13);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-10);
    }];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"OrderOmitTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderOmitTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"NewOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewOrderTableViewCell"];
    //接受刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"orderRefresh" object:nil];
    
    //尾部关联
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //尾部隐藏
    self.tableview.mj_footer.hidden = YES;
}

#pragma mark 开始页面的刷新请求
-(void)noti1{
    if ([self.tableview.mj_header isRefreshing]) {
        [self.tableview.mj_header endRefreshing];
    }
    [self setupRefresh];
}

#pragma mark tableview初始化
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.showsHorizontalScrollIndicator = NO;
    }
    return _tableview;
}

#pragma mark 商品页面刷新的方法
-(void)setupRefresh{
    //头部关联
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    //开始刷新
    self.tableview.mj_header.automaticallyChangeAlpha = YES;
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark 加载更多的方法
-(void)loadMore{
    //头部刷新结束
    [self.tableview.mj_header endEditing:YES];
    //页数加一
    NSInteger n = [self.currentPage integerValue];
    n ++;
    self.currentPage = [NSString stringWithFormat:@"%ld", (long)n];
    //进行网络请求
    NSDictionary *param = @{
                            @"page" : self.currentPage,
                            @"per_page" : @(200)
                            };
    FBRequest *request = [FBAPI getWithUrlString:@"/orders" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //保存数据，collectionView进行刷新
        NSArray *ary = [NewOrderModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"orders"]];
        NSMutableArray *temAry = [NSMutableArray array];
        [temAry addObjectsFromArray:self.modelAry];
        [temAry addObjectsFromArray:ary];
        self.modelAry = [NSArray arrayWithArray:temAry];
        //将新添加的数据添加进去就好了，不用重新的置空
        for (int i = 0; i<ary.count; i++) {
            [self.cellFlagAry addObject:@"0"];
        }
        [self.tableview reloadData];
        //得到总的页数
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<200) {
            p=1;
        } else{
            if (n%200==0) {
                p = n/200;
            } else {
                p = n/200+1;
            }
        }
        //用当前的页数和总的页数进行比较，如果当前的页数小于总的页数尾部不隐藏，否则尾部隐藏
        if ([self.currentPage integerValue] < p) {
            self.tableview.mj_footer.hidden = NO;
        } else {
            self.tableview.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}


#pragma mark 刷新的方法
-(void)loadNew{
    [self.tableview.mj_footer endRefreshing];
    //用选择的分类ID进行网络请求获得数据，页数始终为1
    self.currentPage = @"1";
    NSDictionary *param = @{
                            @"page" : self.currentPage,
                            @"per_page" : @(200)
                            };
    FBRequest *request = [FBAPI getWithUrlString:@"/orders" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.tableview.mj_header endRefreshing];
        self.tableview.mj_header.hidden = YES;
        //获得数据之后保存
        NSLog(@"diasbnf %@", result);
        self.modelAry = [NewOrderModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"orders"]];
        //用保存的数据配置collectionview，然后刷新collectionview
        [self.cellFlagAry removeAllObjects];
        for (int i = 0; i<self.modelAry.count; i++) {
            [self.cellFlagAry addObject:@"0"];
        }
        [self.tableview reloadData];
        //得到总共n个商品，如果n<200,那么p=1，否则判断n%200==0，那页数p=n/200,不然p=n/200+n%200
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<200) {
            p=1;
        } else{
            if (n%200==0) {
                p = n/200;
            } else {
                p = n/200+1;
            }
        }
        //页数p>1，尾部不隐藏，p<=1尾部隐藏
        if (p>1) {
            self.tableview.mj_footer.hidden = NO;
        } else {
            self.tableview.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark cell的标志的数组，0为矮的cell，1为高的cell
-(NSMutableArray *)cellFlagAry{
    if (!_cellFlagAry) {
        _cellFlagAry = [NSMutableArray array];
    }
    return _cellFlagAry;
}

#pragma mark 查看详情的方法
-(void)detail:(UIButton*)sender{
    [self.cellFlagAry replaceObjectAtIndex:sender.tag withObject:@"1"];
    [self.tableview reloadData];
}

#pragma mark 收起详情的方法
-(void)shouqi:(UIButton*)sender{
    [self.cellFlagAry replaceObjectAtIndex:sender.tag withObject:@"0"];
    [self.tableview reloadData];
}

#pragma mark -----------------tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellFlagAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *flagStr = self.cellFlagAry[indexPath.row];
    NewOrderModel *model = self.modelAry[indexPath.row];
    if ([flagStr integerValue] == 0) {
        OrderOmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderOmitTableViewCell"];
        cell.detailBtn.tag = indexPath.row;
        [cell.detailBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
        [cell fuzhi:model];
        return cell;
    } else {
        NewOrderTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"NewOrderTableViewCell"];
        cell.shouBtn.tag = indexPath.row;
        [cell fuzhi:model];
        [cell fuzhiAry:model.items];
        [cell.shouBtn addTarget:self action:@selector(shouqi:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *flagStr = self.cellFlagAry[indexPath.row];
    NewOrderModel *model = self.modelAry[indexPath.row];
    if ([flagStr integerValue] == 0) {
        return 50;
    } else {
        if (model.items.count >= 2) {
            return 229 + (model.items.count-2) * 100 + 130;
        }
        return 229 + (model.items.count-1) * 130;
    }
}

@end
