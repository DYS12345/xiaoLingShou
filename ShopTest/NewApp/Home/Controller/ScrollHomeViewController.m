//
//  ScrollHomeViewController.m
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "ScrollHomeViewController.h"
#import "GoodsCollectionViewCell.h"
#import "FBAPI.h"
#import "CategoryGoodsTableViewCell.h"
#import "MJRefresh.h"
#import "ProductModel.h"
#import "MJExtension.h"
#import "FBConfig.h"
#import "UIView+FSExtension.h"
#import "SelectGoodsInfoTableViewCell.h"
#import "ProductSkuModel.h"
#import "SVProgressHUD.h"
#import "SelectGoodsSkuViewController.h"
#import "POP.h"
#import "UIColor+Extension.h"
#import "NewGoodsCollectionViewCell.h"
#import "JiesuanTableViewCell.h"
#import "UserModel.h"
#import "SuccessViewController.h"

@interface ScrollHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; //商品collectionview
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;  //商品分类的tableview
@property (nonatomic, strong) NSMutableArray *categoryNameAry;  //商品分类的名字的数组
@property (nonatomic, strong) NSMutableArray *categoryPidAry;  //商品分类的ID的数组
@property (nonatomic, copy) NSString *selectCategoryPid;  //当前选择的商品分类的id
@property (nonatomic, copy) NSString *currentPage;  //当前页数
@property (nonatomic, strong) NSArray<ProductModel*> *modelAry;  //商品模型数组
@property (nonatomic, assign) NSInteger selectRow;  //选中的分类的row
@property (weak, nonatomic) IBOutlet UITableView *selelctGoodsTableview;  //已经选择的商品的清单tableview
@property (nonatomic, strong) NSMutableArray *selectGoodsInfoModelAry;  //选中的商品的结算信息的模型数组
@property (nonatomic, strong) NSMutableArray *goodsSkuInfoModelAry;  //现有商品的sku信息的模型数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewLeft; //付款页面的左边约束
@property (weak, nonatomic) IBOutlet UIView *payView; // 支付的视图
@property (nonatomic, strong) NSMutableArray *flagAry; // 分类cell背景色的标志数组
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView; //二维码的图片
@property (weak, nonatomic) IBOutlet UITableView *jiesuanTableView; //支付页面左侧的结算视图 tag=111
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel; //订单号label
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel; //所有已选商品的个数
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel; //所有已选商品的钱数
@property (weak, nonatomic) IBOutlet UILabel *preferentialLabel; //优惠的总金额
@property (weak, nonatomic) IBOutlet UILabel *paiedMoneyLabel; //应该支付的金额
@property (weak, nonatomic) IBOutlet UIButton *jieSuanBtn;// 去结算按钮
@property (weak, nonatomic) IBOutlet UILabel *countlabel;//商品总数
@property (weak, nonatomic) IBOutlet UILabel *hejiPrice;//商品合计价格
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;//应付款的
@property (weak, nonatomic) IBOutlet UIImageView *wexinBgImageView; //微信视图的背景图
@property (weak, nonatomic) IBOutlet UIImageView *weixinlogoImageView; //微信的logo
@property (weak, nonatomic) IBOutlet UILabel *wechatText;//微信支付的文字
@property (weak, nonatomic) IBOutlet UILabel *fuKuanLabel;
@property (nonatomic, assign) NSInteger num;
@property (weak, nonatomic) IBOutlet UIImageView *cashBgImagView; //现金支付选项的背景图片
@property (weak, nonatomic) IBOutlet UIImageView *cashLogoImageView; //现金支付的logo图片
@property (weak, nonatomic) IBOutlet UILabel *cashlabel;//现金label
@property (weak, nonatomic) IBOutlet UIView *qrImageShowView;//二维码展示的底部View
@property (weak, nonatomic) IBOutlet UIButton *tradeBtn;//二维码展示时候的交易关闭按钮
@property (nonatomic, strong) NSMutableArray *numAry;//存放计算器点击的数字的数组
@property (weak, nonatomic) IBOutlet UITextField *shishouJineTF;//计算器上实收金额对应的tf
@property (weak, nonatomic) IBOutlet UITextField *zhaolingTF;//计算器上找零的那个tf
@property (weak, nonatomic) IBOutlet UIButton *closeTradeCash; //现金交易里的关闭交易按钮
@property (weak, nonatomic) IBOutlet UIButton *querenfuKuanCash;//现金交易里的确认付款按钮
@property (weak, nonatomic) IBOutlet UIView *jisuanqiView;//计算器的背景View
@property (nonatomic, copy) NSString *dingdanBianhao;//生成订单后的订单编号
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTableViewWidth;//menutableview的宽度
@property (nonatomic, copy) NSString *currentPageSearch;//搜索页面的那个当前页的页数
@property (nonatomic ,copy) NSString *searchQk;//传过来的搜索的文字
@property (nonatomic, strong) NSArray *modelArySearch;//搜索页的商品模型数组
@property (nonatomic, assign) BOOL collectionCellSizeFlag;//首页和搜索页商品cell大小转换的标志
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsCollectionViewTop;//商品collectionview上面的约束
@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;//搜索结果展示的label
@property (weak, nonatomic) IBOutlet UIView *gouwuCheBgView;//购物车没有商品时候的背景图片
@property (weak, nonatomic) IBOutlet UIButton *selectGoodsClearBtn;//购物车右上角的那个清空的按钮

@end

@implementation ScrollHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    选中的数字默认为0
    self.selectRow = 0;
    //collectionview的基础设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewGoodsCollectionViewCell"];
    //商品分类的tableview的基础设置
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    [self.categoryTableView registerNib:[UINib nibWithNibName:@"CategoryGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryGoodsTableViewCell"];
    //请求商品的分类的方法
    FBRequest *request = [FBAPI getWithUrlString:@"/categories" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"sdashdahsh  %@", result);
        if ([result[@"success"] integerValue] == 1) {
            NSArray *ary = result[@"data"][@"categories"];
            for (int i = 0; i<ary.count; i++) {
                [self.categoryNameAry addObject:ary[i][@"name"]];
                [self.categoryPidAry addObject:ary[i][@"id"]];
                [self.flagAry addObject:@"0"];
            }
            //这里再添加一个全部分类
            [self.categoryNameAry insertObject:@"全部" atIndex:0];
            [self.categoryPidAry insertObject:@"0" atIndex:0];
            [self.flagAry insertObject:@"0" atIndex:0];
            self.flagAry[0] = @"1";
            self.selectCategoryPid = self.categoryPidAry[0];
            [self setupRefresh];
            //如果没有分类，这时候应该给用户一个提示的
            [self.categoryTableView reloadData];
        }
    } failure:^(FBRequest *request, NSError *error) {
    }];
    //selelctGoodsTableview注册cell
    [self.selelctGoodsTableview registerNib:[UINib nibWithNibName:@"SelectGoodsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectGoodsInfoTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti3:) name:@"selectGoods" object:nil];
    //点击购物清单的清空按钮，右边视图的数据源清理掉，然后刷新界面
    [self.jiesuanTableView registerNib:[UINib nibWithNibName:@"JiesuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"JiesuanTableViewCell"];
    
    self.jieSuanBtn.layer.masksToBounds = YES;
    self.jieSuanBtn.layer.cornerRadius = 5;
    
    [self wechat];
    self.num = 0;
    //监听支付成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome) name:@"backHome" object:nil];
    //选择现金支付的按钮后，微信支付的按钮变成常态，现金支付的按钮变成被选中状态，二维码展示的View消失，交易关闭的按钮也消失，现金结算的View出现
    //点击数字按钮，在数组里存入对应的数字，根据数组的元素个数来进行拼接金额，每点击一次就拼一次刷新一次，然后就在找零的地方再更新一次
    self.closeTradeCash.layer.masksToBounds = YES;
    self.closeTradeCash.layer.cornerRadius = 3;
    self.querenfuKuanCash.layer.masksToBounds = YES;
    self.querenfuKuanCash.layer.cornerRadius = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMenuTableViewWidth) name:@"gaibianmenutableviewdekuandu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRefreshType:) name:@"scrollHomeViewRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshBack) name:@"scrolleviewRefreshBack" object:nil];
    
    self.collectionCellSizeFlag = YES;
}

#pragma mark 从搜索页再恢复到首页的状态
-(void)setupRefreshBack{
    self.collectionCellSizeFlag = YES;
    self.menuTableViewWidth.constant = 130;
    self.goodsCollectionViewTop.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //头部关联
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
        //开始刷新
        self.collectionView.mj_header.automaticallyChangeAlpha = YES;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.collectionView.mj_header beginRefreshing];
        //尾部关联
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        //尾部隐藏
        self.collectionView.mj_footer.hidden = YES;
        self.searchResultLabel.hidden = YES;
    }];
}

#pragma mark 改变视图的数据来源，就是改变刷新和加载
-(void)changeRefreshType:(NSNotification*)noti{
    self.collectionCellSizeFlag = NO;
    NSString *qk = [noti object];
    self.searchQk = qk;
    //头部关联
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSearch)];
    //开始刷新
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView.mj_header beginRefreshing];
    //尾部关联
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSearch)];
    //尾部隐藏
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark 搜索时候的下拉刷新
-(void)loadNewSearch{
    [self.collectionView.mj_footer endRefreshing];
    //用选择的分类ID进行网络请求获得数据，页数始终为1
    self.currentPageSearch = @"1";
    UserModel *userModel = [[UserModel findAll] lastObject];
    NSDictionary *param = @{
                            @"page" : self.currentPageSearch,
                            @"per_page" : @(15),
                            @"qk" : self.searchQk,
                            @"store_rid" : userModel.store_rid
                            };
    FBRequest *request = [FBAPI postWithUrlString:@"/search/products" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.collectionView.mj_header endRefreshing];
        NSLog(@"ohfnd %@", result);
        //获得数据之后保存
        //用保存的数据配置collectionview，然后刷新collectionview
        self.modelArySearch = [ProductModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"products"]];
        [self.collectionView reloadData];
        //遍历Model数组，来得到每一个Model对应的sku数组，再将这些sku数组存放到一个数组中进行备用
        [self.goodsSkuInfoModelAry removeAllObjects];
        NSString *ridStr = @"";
        NSMutableArray *temRidAry = [NSMutableArray array];
        for (int i = 0; i<self.modelArySearch.count; i++) {
            ProductModel *model = self.modelArySearch[i];
            [temRidAry addObject:model.rid];
        }
        ridStr = [temRidAry componentsJoinedByString:@","];
        NSDictionary *paramSkuList = @{@"rid" : ridStr, @"store_rid" : userModel.store_rid};
        FBRequest *request2 = [FBAPI getWithUrlString:@"/products/skus" requestDictionary:paramSkuList delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"sdsaddssfgdfgfgfdg  %@", result);
            NSDictionary *dict = result[@"data"];
            for (int i = 0; i<self.modelArySearch.count; i++) {
                ProductModel *m = self.modelArySearch[i];
                NSDictionary *ridDict = dict[m.rid];
                NSArray *ary = [ProductSkuModel mj_objectArrayWithKeyValuesArray:ridDict[@"items"]];
                [self.goodsSkuInfoModelAry addObject:ary];
            }
        } failure:^(FBRequest *request, NSError *error) {

        }];
        NSLog(@"sdasdsadsa %@", result);
        self.searchResultLabel.text = [NSString stringWithFormat:@"关于\"%@\"，共搜索到%d个结果", self.searchQk, [result[@"data"][@"count"] intValue]];
        //得到总共n个商品，如果n<16,那么p=1，否则判断n%16==0，那页数p=n/16,不然p=n/16+n%16
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<15) {
            p=1;
        } else{
            if (n%15==0) {
                p = n/15;
            } else {
                p = n/15+1;
            }
        }
        //页数p>1，尾部不隐藏，p<=1尾部隐藏
        if (p>1) {
            self.collectionView.mj_footer.hidden = NO;
        } else {
            self.collectionView.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {

    }];
}

#pragma mark 搜索页面的上拉加载更多方法
-(void)loadMoreSearch{
    //头部刷新结束
    [self.collectionView.mj_header endEditing:YES];
    //页数加一
    NSInteger n = [self.currentPageSearch integerValue];
    n ++;
    self.currentPageSearch = [NSString stringWithFormat:@"%ld", (long)n];
    //进行网络请求
    UserModel *usermodel = [[UserModel findAll] lastObject];
    NSDictionary *param = @{
                            @"page" : self.currentPageSearch,
                            @"per_page" : @(15),
                            @"qk" : self.searchQk,
                            @"store_rid" : usermodel.store_rid
                            };
    FBRequest *request = [FBAPI getWithUrlString:@"/search/products" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //保存数据，collectionView进行刷新
        NSArray *ary = [ProductModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"products"]];
        NSMutableArray *temAry = [NSMutableArray arrayWithArray:ary];
        [temAry addObjectsFromArray:self.modelArySearch];
        self.modelArySearch = [NSArray arrayWithArray:temAry];
        [self.collectionView reloadData];
        //遍历Model数组，得到每个商品的sku数组，将每个sku数组存进一个单独的数组中去
        [self.goodsSkuInfoModelAry removeAllObjects];
        NSString *ridStr = @"";
        NSMutableArray *temRidAry = [NSMutableArray array];
        for (int i = 0; i<self.modelArySearch.count; i++) {
            ProductModel *model = self.modelArySearch[i];
            [temRidAry addObject:model.rid];
        }
        ridStr = [temRidAry componentsJoinedByString:@","];
        NSDictionary *paramSkuList = @{@"rid" : ridStr, @"store_rid" : usermodel.store_rid};
        FBRequest *request2 = [FBAPI getWithUrlString:@"/products/skus" requestDictionary:paramSkuList delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"sdsaddssfgdfgfgfdg  %@", result);
            NSDictionary *dict = result[@"data"];
            for (int i = 0; i<self.modelArySearch.count; i++) {
                ProductModel *m = self.modelArySearch[i];
                NSDictionary *ridDict = dict[m.rid];
                NSArray *ary = [ProductSkuModel mj_objectArrayWithKeyValuesArray:ridDict[@"items"]];
                [self.goodsSkuInfoModelAry addObject:ary];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
        //得到总的页数
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<15) {
            p=1;
        } else{
            if (n%15==0) {
                p = n/15;
            } else {
                p = n/15+1;
            }
        }
        //用当前的页数和总的页数进行比较，如果当前的页数小于总的页数尾部不隐藏，否则尾部隐藏
        if ([self.currentPageSearch integerValue] < p) {
            self.collectionView.mj_footer.hidden = NO;
        } else {
            self.collectionView.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark 改变菜单栏的宽度的方法
-(void)changeMenuTableViewWidth{
    self.menuTableViewWidth.constant = 0;
    self.goodsCollectionViewTop.constant = 50;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.searchResultLabel.hidden = NO;
    }];
}

#pragma mark 现金交易里的关闭交易
- (IBAction)closeTradeCash:(id)sender {
    self.payViewLeft.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.num = 60000;
        [self.selectGoodsInfoModelAry removeAllObjects];
        [self.selelctGoodsTableview reloadData];
        if (self.selectGoodsInfoModelAry.count == 0) {
            self.gouwuCheBgView.hidden = NO;
            self.selectGoodsClearBtn.enabled = NO;
        } else {
            self.gouwuCheBgView.hidden = YES;
            self.selectGoodsClearBtn.enabled = YES;
        }
        int n = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            n = [model.count intValue] + n;
        }
        self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
        CGFloat money = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                money = money + [model.count intValue] * [model.price floatValue];
            } else {
                money = money + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
        //计算器里的东西都回复，选中是微信的状态
        self.shishouJineTF.text = @"";
        self.zhaolingTF.text = @"";
        [self wechat];
    }];
}

#pragma mark 在现金交易里的确认收款方法
- (IBAction)querenShouKuanCash:(id)sender {
    
}

#pragma mark 计算器上的清空按钮
- (IBAction)jisuanClear:(id)sender {
    //点击了清空按钮之后，数组清空，计算金额，然后更新到页面
    [self.numAry removeAllObjects];
    NSString *money = [self.numAry componentsJoinedByString:@""];
    self.shishouJineTF.text = money;
    CGFloat pay = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            pay = pay + [model.count intValue] * [model.price floatValue];
        } else {
            pay = pay + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    NSString *zhaoLing = [NSString stringWithFormat:@"%.2f", [money floatValue] - pay];
    self.zhaolingTF.text = zhaoLing;
}

#pragma mark 计算器的数字按钮
- (IBAction)numClick:(UIButton*)sender {
    NSString *str = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    if (sender.tag == 10) {
        str = @"0";
    } else if (sender.tag == 100) {
        str = @"00";
    } else if (sender.tag == 111) {
        str = @".";
    }
    [self.numAry addObject:str];
    NSString *money = [self.numAry componentsJoinedByString:@""];
    self.shishouJineTF.text = money;
    CGFloat pay = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            pay = pay + [model.count intValue] * [model.price floatValue];
        } else {
            pay = pay + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    NSString *zhaoLing = [NSString stringWithFormat:@"%.2f", [money floatValue] - pay];
    self.zhaolingTF.text = zhaoLing;
}

#pragma mark 计算机上的删除按钮
- (IBAction)delet:(id)sender {
    //点击之后数组里如果还有元素就去掉最后一个元素，然后继续拼接刷新，如果没有的就不走了，
    if (self.numAry.count >= 1) {
        [self.numAry removeLastObject];
        NSString *money = [self.numAry componentsJoinedByString:@""];
        self.shishouJineTF.text = money;
        CGFloat pay = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                pay = pay + [model.count intValue] * [model.price floatValue];
            } else {
                pay = pay + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        NSString *zhaoLing = [NSString stringWithFormat:@"%.2f", [money floatValue] - pay];
        self.zhaolingTF.text = zhaoLing;
    }
}

#pragma mark 存放计算器点击的数字的数组
-(NSMutableArray *)numAry{
    if (!_numAry) {
        _numAry = [NSMutableArray array];
    }
    return _numAry;
}

#pragma mark 现金结算的方法
- (IBAction)cashPay:(id)sender {
    self.weixinlogoImageView.image = [UIImage imageNamed:@"wechat-pay-colour"];
    self.wexinBgImageView.image = [UIImage imageNamed:@"cellBg"];
    self.wechatText.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
    
    self.cashBgImagView.image = [UIImage imageNamed:@"greenBackground"];
    self.cashLogoImageView.image = [UIImage imageNamed:@"cash-click"];
    self.cashlabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.qrImageShowView.hidden = YES;
    self.tradeBtn.hidden = YES;
    self.jisuanqiView.hidden = NO;
}

#pragma mark 监听backhome的方法
-(void)backHome{
    self.payViewLeft.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setupRefresh];
        [self.selectGoodsInfoModelAry removeAllObjects];
        [self.selelctGoodsTableview reloadData];
        if (self.selectGoodsInfoModelAry.count == 0) {
            self.gouwuCheBgView.hidden = NO;
            self.selectGoodsClearBtn.enabled = NO;
        } else {
            self.gouwuCheBgView.hidden = YES;
            self.selectGoodsClearBtn.enabled = YES;
        }
        int n = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            n = [model.count intValue] + n;
        }
        self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
        CGFloat money = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                money = money + [model.count intValue] * [model.price floatValue];
            } else {
                money = money + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
    }];
}
#pragma mark 选择微信交易的方法 这个是按按钮的
- (IBAction)wechatClick:(id)sender {
    //微信按钮变换样式，现金按钮变回原来的样子，计算器隐藏，二维码View出现，交易关闭按钮出现
    self.weixinlogoImageView.image = [UIImage imageNamed:@"wechat-pay-colour-click"];
    self.wexinBgImageView.image = [UIImage imageNamed:@"greenBackground"];
    self.wechatText.textColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    self.cashBgImagView.image = [UIImage imageNamed:@"cellBg"];
    self.cashLogoImageView.image = [UIImage imageNamed:@"cash"];
    self.cashlabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    self.jisuanqiView.hidden = YES;
    self.qrImageShowView.hidden = NO;
    self.tradeBtn.hidden = NO;
}

#pragma mark 选择微信交易的方法 这个是不按按钮的
- (void)wechat{
    //微信按钮变换样式，现金按钮变回原来的样子，计算器隐藏，二维码View出现，交易关闭按钮出现
    self.weixinlogoImageView.image = [UIImage imageNamed:@"wechat-pay-colour-click"];
    self.wexinBgImageView.image = [UIImage imageNamed:@"greenBackground"];
    self.wechatText.textColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    self.cashBgImagView.image = [UIImage imageNamed:@"cellBg"];
    self.cashLogoImageView.image = [UIImage imageNamed:@"cash"];
    self.cashlabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    self.jisuanqiView.hidden = YES;
    self.qrImageShowView.hidden = NO;
    self.tradeBtn.hidden = NO;
}

#pragma mark 二维码的交易关闭
- (IBAction)tradingClosed:(id)sender {
    self.payViewLeft.constant = 0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.num = 60000;
        [self.selectGoodsInfoModelAry removeAllObjects];
        [self.selelctGoodsTableview reloadData];
        if (self.selectGoodsInfoModelAry.count == 0) {
            self.gouwuCheBgView.hidden = NO;
            self.selectGoodsClearBtn.enabled = NO;
        } else {
            self.gouwuCheBgView.hidden = YES;
            self.selectGoodsClearBtn.enabled = YES;
        }
        int n = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            n = [model.count intValue] + n;
        }
        self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
        CGFloat money = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                money = money + [model.count intValue] * [model.price floatValue];
            } else {
                money = money + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
    }];
}

#pragma mark 购物车清空按钮
- (IBAction)clear:(id)sender {
    [self.selectGoodsInfoModelAry removeAllObjects];
    [self.selelctGoodsTableview reloadData];
    if (self.selectGoodsInfoModelAry.count == 0) {
        self.gouwuCheBgView.hidden = NO;
        self.selectGoodsClearBtn.enabled = NO;
    } else {
        self.gouwuCheBgView.hidden = YES;
        self.selectGoodsClearBtn.enabled = YES;
    }

    int n = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        n = [model.count intValue] + n;
    }
    self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
    CGFloat money = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            money = money + [model.count intValue] * [model.price floatValue];
        } else {
            money = money + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
}

#pragma mark sku选择好之后的确认
-(void)noti3:(NSNotification *)noti
{
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo]; //color data  model
    ProductModel *productModel = dic[@"data"];
    NSString *sColor = dic[@"color"];
    NSString *model = dic[@"model"];
    NSString *rid = dic[@"rid"];
    NSString *stockCount = dic[@"stockCount"];
    NSString *salePrice = dic[@"salePrice"];
    //在这里组合成一个新的Model，传给右边结算的视图，当做数据源
    ProductSkuModel *skuM = [[ProductSkuModel alloc] init];
    skuM.cover = productModel.cover;
    skuM.product_name = productModel.name;
    skuM.s_color = sColor;
    skuM.s_model = model;
    skuM.sale_price = productModel.sale_price;
    skuM.count = @"1";
    skuM.price = productModel.price;
    skuM.rid = rid;
    skuM.sale_price = salePrice;
    skuM.stock_count = stockCount;
    [self.selectGoodsInfoModelAry addObject:skuM];
    [self.selelctGoodsTableview reloadData];
    if (self.selectGoodsInfoModelAry.count == 0) {
        self.gouwuCheBgView.hidden = NO;
        self.selectGoodsClearBtn.enabled = NO;
    } else {
        self.gouwuCheBgView.hidden = YES;
        self.selectGoodsClearBtn.enabled = YES;
    }
    //在上面的结算的tableview视图每刷新一次，底部的label都要也相应的更新一次，更新的数据为，所有选中的商品的sku的综合信息，所以应该有一个数组，里面包含的内容为上面的结算清单的模型数组的，然后遍历数组得到总价、个数等信息
    int n = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        n = [model.count intValue] + n;
    }
    self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
    CGFloat money = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            money = money + [model.count intValue] * [model.price floatValue];
        } else {
            money = money + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
}


#pragma mark 移除观察的监听
-(void)dealloc
{
    
    //移除观察者，Observer不能为nil
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark 分类cell背景色的标志数组
-(NSMutableArray *)flagAry{
    if (!_flagAry) {
        _flagAry = [NSMutableArray array];
    }
    return _flagAry;
}

#pragma mark 点击menu按钮的方法
- (IBAction)clickMenu:(id)sender {
    //发送通知，home页面接受通知，更改menuview的宽度，home页面移除通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
}

#pragma mark 现有商品的sku信息的模型数组
-(NSMutableArray *)goodsSkuInfoModelAry{
    if (!_goodsSkuInfoModelAry) {
        _goodsSkuInfoModelAry = [NSMutableArray array];
    }
    return _goodsSkuInfoModelAry;
}

#pragma mark 商品的结算信息的模型数组
-(NSMutableArray *)selectGoodsInfoModelAry{
    if (!_selectGoodsInfoModelAry) {
        _selectGoodsInfoModelAry = [NSMutableArray array];
    }
    return _selectGoodsInfoModelAry;
}

#pragma mark 商品页面刷新的方法
-(void)setupRefresh{
    //头部关联
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    //开始刷新
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView.mj_header beginRefreshing];
    //尾部关联
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //尾部隐藏
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark 刷新的方法
-(void)loadNew{
    [self.collectionView.mj_footer endRefreshing];
    //用选择的分类ID进行网络请求获得数据，页数始终为1
    self.currentPage = @"1";
    UserModel *userModel = [[UserModel findAll] lastObject];
    NSDictionary *param = @{
                            @"page" : self.currentPage,
                            @"per_page" : @(15),
                            @"cid" : self.selectCategoryPid,
                            @"rid" : userModel.store_rid
                            };
    FBRequest *request = [FBAPI getWithUrlString:@"/products/by_store" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.collectionView.mj_header endRefreshing];
        //获得数据之后保存
        //用保存的数据配置collectionview，然后刷新collectionview
        self.modelAry = [ProductModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"products"]];
        [self.collectionView reloadData];
        //遍历Model数组，来得到每一个Model对应的sku数组，再将这些sku数组存放到一个数组中进行备用
        [self.goodsSkuInfoModelAry removeAllObjects];
        NSString *ridStr = @"";
        NSMutableArray *temRidAry = [NSMutableArray array];
        for (int i = 0; i<self.modelAry.count; i++) {
            ProductModel *model = self.modelAry[i];
            [temRidAry addObject:model.rid];
        }
        ridStr = [temRidAry componentsJoinedByString:@","];
        NSDictionary *paramSkuList = @{@"rid" : ridStr, @"store_rid" : userModel.store_rid};
        FBRequest *request2 = [FBAPI getWithUrlString:@"/products/skus" requestDictionary:paramSkuList delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"sdsaddssfgdfgfgfdg  %@", result);
            NSDictionary *dict = result[@"data"];
            for (int i = 0; i<self.modelAry.count; i++) {
                ProductModel *m = self.modelAry[i];
                NSDictionary *ridDict = dict[m.rid];
                NSArray *ary = [ProductSkuModel mj_objectArrayWithKeyValuesArray:ridDict[@"items"]];
                if (ary == nil) {
                    
                } else {
                    [self.goodsSkuInfoModelAry addObject:ary];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
        NSLog(@"sdasdsadsa %@", result);
        //得到总共n个商品，如果n<16,那么p=1，否则判断n%16==0，那页数p=n/16,不然p=n/16+n%16
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<15) {
            p=1;
        } else{
            if (n%15==0) {
                p = n/15;
            } else {
                p = n/15+1;
            }
        }
        //页数p>1，尾部不隐藏，p<=1尾部隐藏
        if (p>1) {
            self.collectionView.mj_footer.hidden = NO;
        } else {
            self.collectionView.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark 支付方法
- (IBAction)zhiFu:(id)sender {
    //遍历现在选择的sku数组，以每一个模型为参考来进行数据的传递
    NSMutableArray *ary = [NSMutableArray array];
    CGFloat money = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *skuM = self.selectGoodsInfoModelAry[i];
        if ([skuM.sale_price integerValue] == 0) {
            money = [skuM.count intValue] * [skuM.price floatValue];
        } else {
            money = [skuM.count intValue] * [skuM.sale_price floatValue];
        }
        NSDictionary *dict = @{@"rid" : skuM.rid,
                               @"quantity" : skuM.count,
                               @"deal_price" : [NSString stringWithFormat:@"%.2f", money]
                               };
        [ary addObject:dict];
    }
    if (ary.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择商品"];
        return;
    }
    NSDictionary *param = @{@"ship_mode" : @"2",
                            @"items" : ary,
                            @"sync_pay" : @"1",
                            @"from_client" : @"6"
                            };
    FBRequest *request = [FBAPI postWithUrlString:@"/orders/create" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"obrj  %@", result);
        if ([result[@"success"] integerValue] == 1) {
            NSString *codeUrl = result[@"data"][@"pay_params"][@"code_url"];
            NSString *rid = result[@"data"][@"order"][@"rid"];
            //点击确认付款后将选择的商品的sku的数组为数据源来展示结算页左侧的页面
            
            //二维码图片生成
            self.qrImageView.image = [self qrImageForString:codeUrl imageSize:200 logoImageSize:50];
            self.num = 0;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                while (self.num <= 3000) {
                    [NSThread sleepForTimeInterval:2];
                    [self checkOrderInfoForPayStatusWithPaymentWay:@""];
                };
            });
            
            self.payViewLeft.constant = -self.view.width;
            [UIView animateWithDuration:0.4 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.dingdanBianhao = rid;
                self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", rid];
                //总件数就是把每一个模型的count数相加的总和
                int n = 0;
                for (int i =0; i<self.selectGoodsInfoModelAry.count; i++) {
                    ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
                    n = n + [model.count intValue];
                }
                self.totalCountLabel.text = [NSString stringWithFormat:@"总数：%d件", n];
                //遍历，每一个模型的count乘该模型的sale_price，然后相加就是总得金额了
                CGFloat totalMoney = 0;
                for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
                    ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
                    if ([model.sale_price integerValue] == 0) {
                        totalMoney = totalMoney + [model.count intValue] * [model.price floatValue];
                    } else {
                        totalMoney = totalMoney + [model.count intValue] * [model.sale_price floatValue];
                    }
                }
                self.totalMoneyLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", totalMoney];
                self.paiedMoneyLabel.text = [NSString stringWithFormat:@"应支付：￥%.2f", totalMoney];
                self.fuKuanLabel.text = [NSString stringWithFormat:@"应支付：￥%.2f", totalMoney];
                [self.jiesuanTableView reloadData];
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", result[@"data"][@"status"][@"message"]]];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark 请求订单状态以核实支付是否完成
- (void)checkOrderInfoForPayStatusWithPaymentWay:(NSString *)paymentWay
{
    self.num ++;
    FBRequest * request = [FBAPI postWithUrlString:@"/orders/check_order_paid" requestDictionary:@{@"rid": self.dingdanBianhao} delegate:self];
    //延迟2秒执行以保证服务端已获取支付通知
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"roidsfn %@", result);
            //如果请求成功了再去查找对应的交易数据
            if ([result[@"success"] integerValue] == 1) {
                if ([result[@"data"][@"paid"] integerValue] == 1) {
                    self.num = 5000;
                    //弹出成功的页面
                    SuccessViewController *vc = [SuccessViewController new];
                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    vc.imag = [self fullScreenshots];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
        }];
    });
}


#pragma mark 生成二维码的方法
- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}

#pragma mark 在二维码图片上添加水印图片
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"logoFillet"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

#pragma mark 加载更多的方法
-(void)loadMore{
    //头部刷新结束
    [self.collectionView.mj_header endEditing:YES];
    //页数加一
    NSInteger n = [self.currentPage integerValue];
    n ++;
    self.currentPage = [NSString stringWithFormat:@"%ld", (long)n];
    //进行网络请求
    UserModel *usermodel = [[UserModel findAll] lastObject];
    NSDictionary *param = @{
                            @"page" : self.currentPage,
                            @"per_page" : @(15),
                            @"cid" : self.selectCategoryPid,
                            @"store_rid" : usermodel.store_rid
                            };
    FBRequest *request = [FBAPI getWithUrlString:@"/products" requestDictionary:param delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //保存数据，collectionView进行刷新
        NSArray *ary = [ProductModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"products"]];
        NSMutableArray *temAry = [NSMutableArray arrayWithArray:ary];
        [temAry addObjectsFromArray:self.modelAry];
        self.modelAry = [NSArray arrayWithArray:temAry];
        [self.collectionView reloadData];
        //遍历Model数组，得到每个商品的sku数组，将每个sku数组存进一个单独的数组中去
        [self.goodsSkuInfoModelAry removeAllObjects];
        NSString *ridStr = @"";
        NSMutableArray *temRidAry = [NSMutableArray array];
        for (int i = 0; i<self.modelAry.count; i++) {
            ProductModel *model = self.modelAry[i];
            [temRidAry addObject:model.rid];
        }
        ridStr = [temRidAry componentsJoinedByString:@","];
        NSDictionary *paramSkuList = @{@"rid" : ridStr, @"store_rid" : usermodel.store_rid};
        FBRequest *request2 = [FBAPI getWithUrlString:@"/products/skus" requestDictionary:paramSkuList delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            NSLog(@"sdsaddssfgdfgfgfdg  %@", result);
            NSDictionary *dict = result[@"data"];
            for (int i = 0; i<self.modelAry.count; i++) {
                ProductModel *m = self.modelAry[i];
                NSDictionary *ridDict = dict[m.rid];
                NSArray *ary = [ProductSkuModel mj_objectArrayWithKeyValuesArray:ridDict[@"items"]];
                [self.goodsSkuInfoModelAry addObject:ary];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
        //得到总的页数
        NSInteger n = [result[@"data"][@"count"] integerValue];
        NSInteger p = 0;
        if (n<15) {
            p=1;
        } else{
            if (n%15==0) {
                p = n/15;
            } else {
                p = n/15+1;
            }
        }
        //用当前的页数和总的页数进行比较，如果当前的页数小于总的页数尾部不隐藏，否则尾部隐藏
        if ([self.currentPage integerValue] < p) {
            self.collectionView.mj_footer.hidden = NO;
        } else {
            self.collectionView.mj_footer.hidden = YES;
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark 分类id的数组
-(NSMutableArray *)categoryPidAry{
    if (!_categoryPidAry) {
        _categoryPidAry = [NSMutableArray array];
    }
    return _categoryPidAry;
}

#pragma mark 分类的名字数组
-(NSMutableArray *)categoryNameAry{
    if (!_categoryNameAry) {
        _categoryNameAry = [NSMutableArray array];
    }
    return _categoryNameAry;
}

#pragma mark cell的点击方法
-(void)cellClick:(UIButton *)sender{
    //弄一个数组，里面1说明这个cell背景色为深色，0说明背景色为浅色, 只需要刷新tableview就可以了
    //数组里所有的元素置为0，这个置为1，然后刷新
    for (int i = 0; i<self.flagAry.count; i++) {
        self.flagAry[i] = @"0";
    }
    self.flagAry[sender.tag] = @"1";
    [self.categoryTableView reloadData];
    //根据tag值来进行相应的操作
    //如果上次选中的数字和row的数字相同，就不走下面的步骤
    if (self.selectRow != sender.tag) {
        //点击后当前选中的分类ID就变成对应的分类ID，并记录下选中的row
        self.selectCategoryPid = self.categoryPidAry[sender.tag];
        self.selectRow = sender.tag;
        //重新进行网络请求，商品collectionview进行刷新
        [self setupRefresh];
    }
}

#pragma mark 点击取消结算清单里的商品
-(void)popSelectGoodsModel:(UIButton*)sender{
    [self.selectGoodsInfoModelAry removeObjectAtIndex:sender.tag];
    [self.selelctGoodsTableview reloadData];
    if (self.selectGoodsInfoModelAry.count == 0) {
        self.gouwuCheBgView.hidden = NO;
        self.selectGoodsClearBtn.enabled = NO;
    } else {
        self.gouwuCheBgView.hidden = YES;
        self.selectGoodsClearBtn.enabled = YES;
    }
    int n = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        n = [model.count intValue] + n;
    }
    self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
    CGFloat money = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            money = money + [model.count intValue] * [model.price floatValue];
        } else {
            money = money + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
}

#pragma mark ------------------------tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return self.categoryNameAry.count;
    } else if (tableView.tag == 111) {
        return self.selectGoodsInfoModelAry.count;
    }
    else {
        return self.selectGoodsInfoModelAry.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        CategoryGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryGoodsTableViewCell"];
        NSString *str = self.flagAry[indexPath.row];
        if ([str isEqualToString:@"1"]) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#fbfbfb"];
            cell.tLabel.textColor = [UIColor colorWithHexString:@"#02A65A"];
        } else {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            cell.tLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        }
        cell.tLabel.text = self.categoryNameAry[indexPath.row];
        //cell btn都链接到同一个方法中
        [cell.btn addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        //cell btn的tag值设定为row的值
        cell.btn.tag = indexPath.row;
        return cell;
    } else if (tableView.tag == 111) {
        JiesuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiesuanTableViewCell"];
        ProductSkuModel *model = self.selectGoodsInfoModelAry[indexPath.row];
        cell.model = model;
        return cell;
    }
    else {
        SelectGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectGoodsInfoTableViewCell"];
        ProductSkuModel *model = self.selectGoodsInfoModelAry[indexPath.row];
        [cell skuInfo:model];
        //点击减的按钮，如果数量为1那么就把这个模型剔除出数组中，否则就减1，模型数据更改然后刷新页面，
        cell.jian.tag = indexPath.row;
        [cell.jian addTarget:self action:@selector(jian:) forControlEvents:UIControlEventTouchUpInside];
        //点击加的按钮，如果数量为库存的数量了，那么提示无法继续增加了，否则就加1，模型数据更改然后刷新页面
        cell.add.tag = indexPath.row;
        [cell.add addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark 右边商品结算清单cell里的加方法
-(void)add:(UIButton*)sender{
    ProductSkuModel *model = self.selectGoodsInfoModelAry[sender.tag];
    if ([model.stock_count integerValue] == [model.count integerValue]) {
        [SVProgressHUD showInfoWithStatus:@"已到购买的最大数量"];
    } else {
        model.count = [NSString stringWithFormat:@"%d", [model.count intValue] + 1];
        [self.selelctGoodsTableview reloadData];
        if (self.selectGoodsInfoModelAry.count == 0) {
            self.gouwuCheBgView.hidden = NO;
            self.selectGoodsClearBtn.enabled = NO;
        } else {
            self.gouwuCheBgView.hidden = YES;
            self.selectGoodsClearBtn.enabled = YES;
        }
//#warning 在这里更新总结信息
        int n = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            n = [model.count intValue] + n;
        }
        self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
        CGFloat money = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                money = money + [model.count intValue] * [model.price floatValue];
            } else {
                money = money + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
    }
}

#pragma mark 右边商品结算清单cell里的减方法
-(void)jian:(UIButton*)sender{
    ProductSkuModel *model = self.selectGoodsInfoModelAry[sender.tag];
    if ([model.count integerValue] == 1) {
        [self.selectGoodsInfoModelAry removeObjectAtIndex:sender.tag];
    } else {
        model.count = [NSString stringWithFormat:@"%d", [model.count intValue] - 1];
    }
    [self.selelctGoodsTableview reloadData];
    if (self.selectGoodsInfoModelAry.count == 0) {
        self.gouwuCheBgView.hidden = NO;
        self.selectGoodsClearBtn.enabled = NO;
    } else {
        self.gouwuCheBgView.hidden = YES;
        self.selectGoodsClearBtn.enabled = YES;
    }
//#warning 在这里更新总结的信息
    int n = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        n = [model.count intValue] + n;
    }
    self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
    CGFloat money = 0;
    for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
        ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
        if ([model.sale_price integerValue] == 0) {
            money = money + [model.count intValue] * [model.price floatValue];
        } else {
            money = money + [model.count intValue] * [model.sale_price floatValue];
        }
    }
    self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
}

#pragma mark ----------------------collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectionCellSizeFlag) {
        return self.modelAry.count;
    } else {
        return self.modelArySearch.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewGoodsCollectionViewCell" forIndexPath:indexPath];
    if (self.collectionCellSizeFlag == YES) {
        cell.productModel = self.modelAry[indexPath.row];
    } else {
        cell.productModel = self.modelArySearch[indexPath.row];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //在代理方法里添加进以结算数组为数据源的新代码
    //每一次点击商品cell，从数组中拿出对应的sku数组，如果sku数组的个数为1，那么直接显示，如果个数大于1，那么就弹出一个表格供人们进行选择
    if (self.goodsSkuInfoModelAry.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"商品sku信息不全，无法选择"];
        return;
    }
    NSArray *skuAry = self.goodsSkuInfoModelAry[indexPath.row];
    if (skuAry.count == 1) {
        //点击cell后，结算这边的数组添加进一个Model，然后刷新
        ProductSkuModel *model = skuAry[0];
        model.count = @"1";
        [self.selectGoodsInfoModelAry addObject:model];
        [self.selelctGoodsTableview reloadData];
        if (self.selectGoodsInfoModelAry.count == 0) {
            self.gouwuCheBgView.hidden = NO;
            self.selectGoodsClearBtn.enabled = NO;
        } else {
            self.gouwuCheBgView.hidden = YES;
            self.selectGoodsClearBtn.enabled = YES;
        }
        //在上面的结算的tableview视图每刷新一次，底部的label都要也相应的更新一次，更新的数据为，所有选中的商品的sku的综合信息，所以应该有一个数组，里面包含的内容为上面的结算清单的模型数组的，然后遍历数组得到总价、个数等信息
        int n = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            n = [model.count intValue] + n;
        }
        self.countlabel.text = [NSString stringWithFormat:@"总数：%d件", n];
        CGFloat money = 0;
        for (int i = 0; i<self.selectGoodsInfoModelAry.count; i++) {
            ProductSkuModel *model = self.selectGoodsInfoModelAry[i];
            if ([model.sale_price integerValue] == 0) {
                money = money + [model.count intValue] * [model.price floatValue];
            } else {
                money = money + [model.count intValue] * [model.sale_price floatValue];
            }
        }
        self.hejiPrice.text = [NSString stringWithFormat:@"合计：￥%.2f", money];
        self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", money];
    } else if (skuAry.count > 1) {
        //弹出表格
        //点击商品，截图，传给下一个页面，下一个页面弹出来
        UIImage *image = [self fullScreenshots];
        SelectGoodsSkuViewController *selectGoodsSku = [[SelectGoodsSkuViewController alloc] init];
        selectGoodsSku.bgImg = image;
        //将这个商品的sku数组传过去，以这个数组为数据源，刷新界面
        NSArray *skuAry = self.goodsSkuInfoModelAry[indexPath.row];
        selectGoodsSku.modelAry = skuAry;
        if (self.collectionCellSizeFlag) {
            selectGoodsSku.model = self.modelAry[indexPath.row];
        } else {
            selectGoodsSku.model = self.modelArySearch[indexPath.row];
        }
        selectGoodsSku.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:selectGoodsSku animated:YES completion:nil];
    }
}

#pragma mark 屏幕截图的方法
-(UIImage*)fullScreenshots{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark --------------------------------------商品collectionview的布局相关的方法
#pragma mark 每个cell的宽高
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionCellSizeFlag == YES) {
        return CGSizeMake(((self.view.width-130-250)-4*20)/3, ((self.view.width-130-250)-4*20)/3*0.378);
    } else {
        return CGSizeMake(((self.view.width-250)-4*20)/3, ((self.view.width-250)-4*20)/3*0.378);
    }
}

#pragma mark 每个cell和周边的边距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20.0f, 20, 20);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

@end
