//
//  HomeViewController.m
//  ShopStore
//
//  Created by 董永胜 on 2018/4/11.
//  Copyright © 2018年 dong. All rights reserved.
//

#import "HomeViewController.h"
#import "ScrollHomeViewController.h"
#import "ScrollOlderViewController.h"
#import "POP.h"
#import "UIView+FSExtension.h"
#import "FBConfig.h"
#import "UIColor+Extension.h"
#import "ScrollViewMyViewController.h"
#import "SearchViewController.h"
#import "SearchHistoryModel.h"
#import "SVProgressHUD.h"
#import "SearchResultListViewController.h"
#import "QRCodeScanViewController.h"
#import "FBAPI.h"
#import "TongJiViewController.h"

@interface HomeViewController () <UIScrollViewDelegate, UITextFieldDelegate, SearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) ScrollHomeViewController *homeVC;
@property (nonatomic, strong) ScrollOlderViewController *olderVC;
@property (nonatomic, strong) ScrollViewMyViewController *myVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewWidth; //menuview的宽度的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewLeft; //menuview的左边约束
@property (weak, nonatomic) IBOutlet UIView *menuView; //左侧的菜单视图
@property (nonatomic, assign) BOOL flag; //控制menu视图回去回来的布尔值
@property (weak, nonatomic) IBOutlet UIView *homeView; //home的背景视图
@property (weak, nonatomic) IBOutlet UIView *olderView; //older的背景视图
@property (weak, nonatomic) IBOutlet UIView *tongjiView; //统计的背景视图
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *myView;//侧边栏的我的背景视图
@property (weak, nonatomic) IBOutlet UILabel *tfLabel;//搜索tf的占位文字
@property (nonatomic, strong) SearchViewController *searchVC;//搜索的历史记录列表
@property (weak, nonatomic) IBOutlet UIView *searchView;//搜索的那个背景视图
@property (weak, nonatomic) IBOutlet UITextField *searchTF;//搜索的tf
@property (nonatomic, assign) BOOL homeFlag;//首页和搜索页面的切换标志
@property (nonatomic, strong) TongJiViewController *tongjiVC;//统计的控制器
@property (weak, nonatomic) IBOutlet UIView *tongjiBgView;//统计的背景视图

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollview.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollview.height = SCREEN_HEIGHT - 45;
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, (self.scrollview.height-65)*4);
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    [self addChildViewController:homeNav];
    [self addChildViewController:self.olderVC];
    self.homeVC.view.frame = CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.height);
    self.olderVC.view.frame = CGRectMake(0, self.scrollview.height+45, self.scrollview.frame.size.width, self.scrollview.height);
    self.myVC.view.frame = CGRectMake(0, 3 * (self.scrollview.height+45), self.scrollview.width, self.scrollview.height);
    self.tongjiVC.view.frame = CGRectMake(0, 2 * (self.scrollview.height+45), self.scrollview.width, self.scrollview.height);
    [self.scrollview addSubview:_homeVC.view];
    [self.scrollview addSubview:_olderVC.view];
    [self.scrollview addSubview:_myVC.view];
    [self.scrollview addSubview:_tongjiVC.view];
    //控制menu视图回去回来的布尔值，初始为yes
    self.flag = YES;
    //将导航栏隐藏掉
    self.navigationController.navigationBarHidden = YES;
    //设置状态栏的背景色为黑色，文字为白色
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //第一次进来的时候，首页的那个选项是深颜色的
    self.homeView.backgroundColor = [UIColor colorWithHexString:@"#008D4C"];
    //检测tf中是否有文字，如果没有就把label隐藏，如果没有文字了就把label显示出来
    
    self.homeFlag = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTFLabel:) name:@"hiddenTFBgLabel" object:nil];
}

#pragma mark 统计的控制器
-(TongJiViewController *)tongjiVC{
    if (!_tongjiVC) {
        _tongjiVC = [TongJiViewController new];
    }
    return _tongjiVC;
}

#pragma mark 隐藏掉搜索栏的那个背景label
-(void)hiddenTFLabel:(NSNotification*)noti{
    NSString *str = [noti object];
    self.tfLabel.hidden = YES;
    self.homeFlag = NO;
    self.homeView.backgroundColor = [UIColor clearColor];
    self.searchTF.text = str;
}

#pragma mark 搜索的历史纪录列表
-(SearchViewController *)searchVC{
    if (!_searchVC) {
        _searchVC = [SearchViewController new];
        self.searchVC.preferredContentSize = CGSizeMake(350/2+30, 100);
        _searchVC.delegate = self;
    }
    return _searchVC;
}

#pragma mark 点击了历史列表里的选项后跳转之前的一些小操作
-(void)pushNot{
    [self.searchTF resignFirstResponder];
}

#pragma mark ------------------------------------------------------------ uitextfiled delegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.tfLabel.hidden = NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length != 0) {
        self.tfLabel.hidden = YES;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
        return YES;
    }
    [textField resignFirstResponder];
    [self.searchVC dismissViewControllerAnimated:YES completion:^{
        self.tfLabel.hidden = YES;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"gaibianmenutableviewdekuandu" object:nil];
        self.homeView.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollHomeViewRefresh" object:textField.text];
        self.homeFlag = NO;
        
        BOOL flag = YES;
        for (SearchHistoryModel *model in [SearchHistoryModel findAll]) {
            if ([textField.text isEqualToString:model.keyStr]) {
                flag = NO;
            }
        }
        if (flag == NO) {
            
        } else {
            if ([SearchHistoryModel findAll].count == 10) {
                SearchHistoryModel *model = [SearchHistoryModel findAll][0];
                [model deleteObject];
            }
            SearchHistoryModel *model = [SearchHistoryModel new];
            model.keyStr = textField.text;
            [model saveOrUpdate];
        }
    }];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.searchVC.flag = YES;
    UIView *sender = self.searchView;
    self.searchVC.navi = self.navigationController;
    self.searchVC.modalPresentationStyle = UIModalPresentationPopover;
    self.searchVC.popoverPresentationController.sourceView = self.view;
    self.searchVC.popoverPresentationController.sourceRect = CGRectMake(sender.x+100, sender.y+20, sender.width, sender.height);
    self.searchVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    NSArray *ary = [SearchHistoryModel findAll];
    NSMutableArray *mAry = [NSMutableArray array];
    for (SearchHistoryModel *model in ary) {
        [mAry addObject:model.keyStr];
    }
    self.searchVC.preferredContentSize = CGSizeMake(350/2+30, (ary.count+1)*45);
    self.searchVC.tagAry = mAry;
    
    [self presentViewController:self.searchVC animated:YES completion:nil];
}

#pragma mark 我的页面
-(ScrollViewMyViewController *)myVC{
    if (!_myVC) {
        _myVC = [[ScrollViewMyViewController alloc] init];
    }
    return _myVC;
}

-(ScrollHomeViewController *)homeVC{
    if (!_homeVC) {
        _homeVC = [[ScrollHomeViewController alloc] init];
    }
    return _homeVC;
}

#pragma mark 点击menu菜单按钮的方法
- (IBAction)menu:(UIButton*)sender {
    sender.selected = !sender.selected;
    //如果flag是yes，参数n为1，否则为-1
    int n = 0;
    if (self.flag) {
        n = 1;
    } else {
        n = -1;
    }
    //使用pop来做动画效果，menuview的左边距发生变化，然后商品页面的宽度也发生变化。
    self.menuViewLeft.constant -= 60*n;
    self.scrollview.width += 60*n;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    //第一次和第二次相应的数是相反的
    self.flag = !self.flag;
}

-(ScrollOlderViewController *)olderVC{
    if (!_olderVC) {
        _olderVC = [[ScrollOlderViewController alloc] init];
    }
    return _olderVC;
}

- (IBAction)home:(UIButton*)sender {
    //点击首页按钮，首页的那个View的背景色变深，别的View的背景色变成原先的颜色
    self.homeView.backgroundColor = [UIColor colorWithHexString:@"#008D4C"];
    self.olderView.backgroundColor = [UIColor clearColor];
    self.myView.backgroundColor = [UIColor clearColor];
    self.tongjiBgView.backgroundColor = [UIColor clearColor];
    [self.scrollview setContentOffset:CGPointMake(0, sender.tag * [UIScreen mainScreen].bounds.size.height) animated:YES];
    if (self.homeFlag == NO) {
        //发送通知，再把原先的给改变回来
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrolleviewRefreshBack" object:nil];
        //menu那个视图再回来
        //搜索框里的文字要改成原先的了
        self.searchTF.text = @"";
        self.tfLabel.hidden = NO;
    }
    self.searchTF.userInteractionEnabled = YES;
}

- (IBAction)dingDan:(UIButton*)sender {
    self.searchTF.userInteractionEnabled = NO;
    self.olderView.backgroundColor = [UIColor colorWithHexString:@"#008D4C"];
    self.homeView.backgroundColor = [UIColor clearColor];
    self.myView.backgroundColor = [UIColor clearColor];
    self.tongjiBgView.backgroundColor = [UIColor clearColor];
    [self.scrollview setContentOffset:CGPointMake(0, sender.tag * [UIScreen mainScreen].bounds.size.height) animated:YES];
    //发送通知，让订单页面进行刷新
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(action) userInfo:nil repeats:NO];
}

#pragma mark  点击统计的方法
- (IBAction)tongji:(id)sender {
    self.searchTF.userInteractionEnabled = NO;
    //点击了我的按钮，我的View视图颜色加深，首页和订单视图的颜色变浅
    self.tongjiBgView.backgroundColor = [UIColor colorWithHexString:@"#008d4c"];
    self.homeView.backgroundColor = [UIColor clearColor];
    self.olderView.backgroundColor = [UIColor clearColor];
    self.myView.backgroundColor = [UIColor clearColor];
    [self.scrollview setContentOffset:CGPointMake(0, 2 * [UIScreen mainScreen].bounds.size.height) animated:YES];
}

#pragma mark 我的按钮方法
- (IBAction)my:(UIButton*)sender {
    self.searchTF.userInteractionEnabled = NO;
    //点击了我的按钮，我的View视图颜色加深，首页和订单视图的颜色变浅
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#008d4c"];
    self.homeView.backgroundColor = [UIColor clearColor];
    self.olderView.backgroundColor = [UIColor clearColor];
    self.tongjiBgView.backgroundColor = [UIColor clearColor];
    [self.scrollview setContentOffset:CGPointMake(0, 3 * [UIScreen mainScreen].bounds.size.height) animated:YES];
}

#pragma mark 扫一扫方法
- (IBAction)scanBtn:(id)sender {
    QRCodeScanViewController *vc = [QRCodeScanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 间隔执行发送通知
-(void)action{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderRefresh" object:nil];
    [self.timer invalidate];
}



@end
