//
//  SelectGoodsSkuViewController.m
//  Shop
//
//  Created by 董永胜 on 2018/4/12.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "SelectGoodsSkuViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductSkuModel.h"
#import "SkuCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "UIColor+Extension.h"
#import "UIView+FSExtension.h"

@interface SelectGoodsSkuViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *showView; // 中间那一块展示的View
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView; //商品的图片
@property (weak, nonatomic) IBOutlet UILabel *goodsName; // 商品的名称
@property (weak, nonatomic) IBOutlet UILabel *goodsSalePrice;//商品的现在销售价格
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;//商品已经被放弃的价格
@property (weak, nonatomic) IBOutlet UILabel *guigelabel;//规格label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeCollectionViewH; // 规格选择视图的高度
@property (nonatomic, strong) NSMutableArray *sModelAry;//存放规格的数组
@property (nonatomic, strong) NSMutableArray *sColorAry;//存放颜色的数组
@property (nonatomic, strong) NSMutableArray *sColorFlagAry;//存放颜色被选择的数组
@property (nonatomic, strong) NSMutableArray *sModelFlagAry;//存放规格被选择的数组
@property (weak, nonatomic) IBOutlet UICollectionView *guigeCollectionView; //规格选择视图
@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView; // 颜色选择的视图
@property (nonatomic, strong) NSMutableArray *sColorEnabelFlagAry; // 颜色是否能被选择的标志的数组
@property (nonatomic, strong) NSMutableArray *sModelEnabelFlagAry; // 规格是否能被选择的标志的数组
@property (nonatomic, copy) NSString *selectColor; // 选择的颜色
@property (nonatomic, copy) NSString *selectModel; //选择的规格
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;//取消按钮
@property (weak, nonatomic) IBOutlet UILabel *stcokCountLabel;//库存数量label
@property (weak, nonatomic) IBOutlet UILabel *yanseLabel;//显示颜色文字的label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorCollectionH;//颜色collectionview的高度

@end

@implementation SelectGoodsSkuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImageView.image = self.bgImg;
    [self circle:self.showView];
    
    [self fuzhi:self.model];
    //如果有一个模型的s_model都是空的话，那么规格label和collectionview都隐藏，否则，就以模型为数据源
    ProductSkuModel *model = self.modelAry[0];
    if (model.s_model.length == 0) {
        self.guigelabel.hidden = YES;
        self.guigeCollectionViewH.constant = 0;
        [self.view layoutIfNeeded];
    } else {
        //找到一共有多少个规格
        //遍历sku数组，取出每一个模型的规格存到数组里，如果下一个模型的规格在数组里就略过，否则就添加进去
        for (int i = 0; i<self.modelAry.count; i++) {
            ProductSkuModel *temModel = self.modelAry[i];
            if (self.sModelAry.count == 0 || ![self ary:self.sModelAry andstr:temModel.s_model]) {
                [self.sModelAry addObject:temModel.s_model];
                [self.sModelFlagAry addObject:@"0"];
            }
        }
    }
    
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *temModel = self.modelAry[i];
        if ((self.sColorAry.count == 0 || ![self ary:self.sColorAry andstr:temModel.s_color]) && temModel.s_color.length != 0) {
            [self.sColorAry addObject:temModel.s_color];
            [self.sColorFlagAry addObject:@"0"];
        }
    }
    if (self.sColorAry.count == 0) {
        self.yanseLabel.hidden = YES;
    }
    
    //初始的时候都是可以点的
    [self.sColorEnabelFlagAry removeAllObjects];
    for (int i = 0; i<self.sColorAry.count; i++) {
        [self.sColorEnabelFlagAry addObject:@"1"];
        NSString *c = self.sColorAry[i];
        //遍历sku数组，如果色值相等看看库存有没有，如果有的话就为1不然就为0
        for (int j = 0; j<self.modelAry.count; j++) {
            ProductSkuModel *m = self.modelAry[j];
            if ([c isEqualToString:m.s_color]) {
                if ([m.stock_count intValue] <= 0) {
                    self.sColorEnabelFlagAry[i] = @"0";
                }
            }
        }
    }
    
    [self.sModelEnabelFlagAry removeAllObjects];
    for (int i = 0; i<self.sModelAry.count; i++) {
        [self.sModelEnabelFlagAry addObject:@"1"];
        NSString *c = self.sModelAry[i];
        //遍历sku数组，如果色值相等看看库存有没有，如果有的话就为1不然就为0
        for (int j = 0; j<self.modelAry.count; j++) {
            ProductSkuModel *m = self.modelAry[j];
            if ([c isEqualToString:m.s_model]) {
                if ([m.stock_count intValue] <= 0) {
                    self.sModelEnabelFlagAry[i] = @"0";
                }
            }
        }
    }
    
    [self.guigeCollectionView registerNib:[UINib nibWithNibName:@"SkuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SkuCollectionViewCell"];
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"SkuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SkuCollectionViewCell"];
    [self.guigeCollectionView reloadData];
    [self.colorCollectionView reloadData];
    
    self.selectModel = @"";
    self.selectColor = @"";
    
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    
    //遍历可以选择的第一个颜色和规格，在可以选择的第一项改为1
    for (int i = 0; i<self.sModelEnabelFlagAry.count; i++) {
        if ([self.sModelEnabelFlagAry[i] integerValue] == 1) {
            SkuCollectionViewCell *cell = [self.guigeCollectionView dequeueReusableCellWithReuseIdentifier:@"SkuCollectionViewCell" forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.btn.tag = i;
            [self selectModel:cell.btn];
            break;
        }
    }
    for (int i = 0; i<self.sColorEnabelFlagAry.count; i++) {
        if (self.sColorAry.count <= 1) {
            
        } else {
            if ([self.sColorEnabelFlagAry[i] integerValue] == 1) {
                SkuCollectionViewCell *cell = [self.colorCollectionView dequeueReusableCellWithReuseIdentifier:@"SkuCollectionViewCell" forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.btn.tag = i;
                [self selectColor:cell.btn];
                break;
            }
        }
    }
}

#pragma mark 规格是否能被选择的标志的数组
-(NSMutableArray *)sModelEnabelFlagAry{
    if (!_sModelEnabelFlagAry) {
        _sModelEnabelFlagAry = [NSMutableArray array];
    }
    return _sModelEnabelFlagAry;
}

#pragma mark 颜色是否能被选择的标志的数组
-(NSMutableArray *)sColorEnabelFlagAry{
    if (!_sColorEnabelFlagAry) {
        _sColorEnabelFlagAry = [NSMutableArray array];
    }
    return _sColorEnabelFlagAry;
}

#pragma mark 存放颜色被选择的数组
-(NSMutableArray *)sColorFlagAry{
    if (!_sColorFlagAry) {
        _sColorFlagAry = [NSMutableArray array];
    }
    return _sColorFlagAry;
}

#pragma mark 存放规格被选择的数组
-(NSMutableArray *)sModelFlagAry{
    if (!_sModelFlagAry) {
        _sModelFlagAry = [NSMutableArray array];
    }
    return _sModelFlagAry;
}

#pragma mark 判断数组中是否存在传入的字符串
-(BOOL)ary:(NSMutableArray*)ary andstr:(NSString *)str{
    BOOL flag = NO;
    for (int i = 0; i<ary.count; i++) {
        NSString *s = ary[i];
        if ([s isEqualToString:str]) {
            flag = YES;
        }
    }
    return flag;
}

#pragma mark 存放颜色的数组
-(NSMutableArray *)sColorAry{
    if (!_sColorAry) {
        _sColorAry = [NSMutableArray array];
    }
    return _sColorAry;
}

#pragma mark 存放规格的数组
-(NSMutableArray *)sModelAry{
    if (!_sModelAry) {
        _sModelAry = [NSMutableArray array];
    }
    return _sModelAry;
}

#pragma mark ------------collectionview方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 10) {
        return self.sModelAry.count; //规格的下面是颜色的
    }
    return self.sColorAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 10) {
        SkuCollectionViewCell *cell = [self.guigeCollectionView dequeueReusableCellWithReuseIdentifier:@"SkuCollectionViewCell" forIndexPath:indexPath];
        NSString *smodel = self.sModelAry[indexPath.row];
        cell.str = smodel;
        cell.selectedStr = self.sModelFlagAry[indexPath.row];
        cell.btn.tag = indexPath.row;
        if (self.sModelEnabelFlagAry.count != 0) {
            NSString *enableStr = self.sModelEnabelFlagAry[indexPath.row];
            if ([enableStr integerValue] == 1) {
                cell.btn.enabled = YES;
            } else {
                cell.btn.enabled = NO;
            }
        }
        [cell.btn addTarget:self action:@selector(selectModel:) forControlEvents:UIControlEventTouchUpInside];
        return cell; //规格的下面是颜色的
    }
    SkuCollectionViewCell *cell = [self.colorCollectionView dequeueReusableCellWithReuseIdentifier:@"SkuCollectionViewCell" forIndexPath:indexPath];
    NSString *smodel = self.sColorAry[indexPath.row];
    cell.str = smodel;
    cell.selectedStr = self.sColorFlagAry[indexPath.row];
    cell.btn.tag = indexPath.row;
    if (self.sColorEnabelFlagAry.count != 0) {
        NSString *enableStr = self.sColorEnabelFlagAry[indexPath.row];
        if ([enableStr integerValue] == 1) {
            cell.btn.enabled = YES;
        } else {
            cell.btn.enabled = NO;
        }
    }
    [cell.btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark 选择规格的方法
-(void)selectModel:(UIButton*)sender{
    //如果点击的和上次选择的是同样的规格的话就不走下面了，否则所有的都重置
    
    [self.sModelFlagAry removeAllObjects];
    for (int i = 0; i<self.sModelAry.count; i++) {
        [self.sModelFlagAry addObject:@"0"];
    }
    [self.sModelFlagAry replaceObjectAtIndex:sender.tag withObject:@"1"];
    [self.guigeCollectionView reloadData];
    //选好规格之后，遍历sku数组，如果模型的规格和选好的规格相同，如果她的库存不为0，那么就将这个颜色值存放到数组中
    NSString *sModel = self.sModelAry[sender.tag];
    NSMutableArray *sColorEnableAry = [NSMutableArray array];
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *model = self.modelAry[i];
        if ([sModel isEqualToString: model.s_model]) {
            if ([model.stock_count integerValue] != 0) {
                [sColorEnableAry addObject:model.s_color];
            }
        }
    }
    //遍历这个颜色数组和最初的颜色数组，找到相同的就在另一个数组中添加1，不然就添加0
    [self.sColorEnabelFlagAry removeAllObjects];
    for (int i = 0; i<self.sColorAry.count; i++) {
        [self.sColorEnabelFlagAry addObject:@"0"];
    }
    for (int i = 0; i<sColorEnableAry.count; i++) {
        for (int j = 0; j<self.sColorAry.count; j++) {
            if ([sColorEnableAry[i] isEqualToString:self.sColorAry[j]]) {
                [self.sColorEnabelFlagAry replaceObjectAtIndex:j withObject:@"1"];
            } else {
                [self.sColorEnabelFlagAry replaceObjectAtIndex:j withObject:@"0"];
            }
        }
    }
    [self.colorCollectionView reloadData];
    self.selectModel = self.sModelAry[sender.tag];
    //利用这个新的数组去控制颜色cell的是否能够被选中
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *m = self.modelAry[i];
        if ([m.s_model isEqualToString:self.selectModel]) {
            if ([m.sale_price integerValue] == 0) {
                self.goodsSalePrice.text = [NSString stringWithFormat:@"￥%@", m.price];
            } else {
                self.goodsSalePrice.text = [NSString stringWithFormat:@"￥%@", m.sale_price];
            }
            self.stcokCountLabel.text = [NSString stringWithFormat:@"库存数：%@", m.stock_count];
        }
    }
}

#pragma mark 选择颜色的方法
-(void)selectColor:(UIButton*)sender{
    
    [self.sColorFlagAry removeAllObjects];
    for (int i = 0; i<self.sColorAry.count; i++) {
        [self.sColorFlagAry addObject:@"0"];
    }
    [self.sColorFlagAry replaceObjectAtIndex:sender.tag withObject:@"1"];
    [self.colorCollectionView reloadData];
    //选好颜色之后，遍历sku数组，如果模型的颜色和选好的颜色相同，如果她的库存不为0，那么就将这个规格值存放到数组中
    NSString *sColor = self.sColorAry[sender.tag];
    NSMutableArray *sModelEnableAry = [NSMutableArray array];
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *model = self.modelAry[i];
        if ([sColor isEqualToString: model.s_color]) {
            if ([model.stock_count integerValue] != 0) {
                [sModelEnableAry addObject:model.s_model];
            }
        }
    }
    //遍历这个规格数组和最初的规格数组，找到相同的就在另一个数组中添加1，不然就添加0
    [self.sModelEnabelFlagAry removeAllObjects];
    for (int i = 0; i<self.sModelAry.count; i++) {
        [self.sModelEnabelFlagAry addObject:@"0"];
    }
    for (int i = 0; i<sModelEnableAry.count; i++) {
        for (int j = 0; j<self.sModelAry.count; j++) {
            if ([sModelEnableAry[i] isEqualToString:self.sModelAry[j]]) {
                [self.sModelEnabelFlagAry replaceObjectAtIndex:j withObject:@"1"];
            } else {
                [self.sModelEnabelFlagAry replaceObjectAtIndex:j withObject:@"0"];
            }
        }
    }
    [self.guigeCollectionView reloadData];
    //选择的颜色
    self.selectColor = self.sColorAry[sender.tag];
    //遍历sku数组，如果颜色相同那么就把价格改成模型的价格
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *m = self.modelAry[i];
        if ([m.s_color isEqualToString:self.selectColor]) {
            if ([m.sale_price integerValue] == 0) {
                self.goodsSalePrice.text = [NSString stringWithFormat:@"￥%@", m.price];
            } else {
                self.goodsSalePrice.text = [NSString stringWithFormat:@"￥%@", m.sale_price];
            }
            self.stcokCountLabel.text = [NSString stringWithFormat:@"库存数：%@", m.stock_count];
        }
    }
}

#pragma mark ----------------collectionview的布局方法
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 10) {
        NSString *smodel = self.sModelAry[indexPath.row];
        CGFloat w = [self calculateRowWidth:smodel]+20;
        return CGSizeMake(w, 50/2);
    }
    NSString *smodel = self.sColorAry[indexPath.row];
    CGFloat w = [self calculateRowWidth:smodel]+20;
    if (w < 60) {
        w = 60;
    }
    return CGSizeMake(w, 50/2);
}

#pragma mark 得到字符串的长度
- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 50/2)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

#pragma mark 传递过来的商品基本信息模型的方法，进行赋值
-(void)fuzhi:(ProductModel *)model{
    self.model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.goodsName.text = model.name;
    if ([model.sale_price integerValue] == 0) {
        self.goodsSalePrice.text = [NSString stringWithFormat:@"¥%@", model.price];
        self.goodsPrice.hidden = YES;
    } else {
        self.goodsSalePrice.text = [NSString stringWithFormat:@"¥%@", model.sale_price];
        self.goodsPrice.hidden = NO;
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", model.price] attributes:attribtDic];
    self.goodsPrice.attributedText = attribtStr;
}

#pragma mark 左下角的取消按钮
- (IBAction)cancelLeft:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 右下角的确认按钮
- (IBAction)queRen:(UIButton*)sender {
    //发送通知，并把序号传过去
    //将sku列表的数组传递进来，以颜色为基础来查找，找完后后再以规格为基础进行查找
    NSString *rid = @"";
    NSString *stockCount = @"";
    NSString *salePrice = @"";
    for (int i = 0; i<self.modelAry.count; i++) {
        ProductSkuModel *skuModel = self.modelAry[i];
        if ([self.selectColor isEqualToString:skuModel.s_color]) {
            if ([self.selectModel isEqualToString:skuModel.s_model]) {
                rid = skuModel.rid;
                stockCount = skuModel.stock_count;
                if ([skuModel.sale_price integerValue] == 0) {
                    salePrice = skuModel.price;
                } else {
                    salePrice = skuModel.sale_price;
                }
            }
        }
    }
    if (rid.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择颜色和规格"];
        return;
    }
    if (stockCount == nil) {
        stockCount = @"0";
    }
    NSDictionary *dic = @{
                          @"color" : self.selectColor,
                          @"model" : self.selectModel,
                          @"data" : self.model,
                          @"rid" : rid,
                          @"stockCount" : stockCount,
                          @"salePrice" : salePrice
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGoods" object:nil userInfo:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 右上角的取消按钮
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 变圆
-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 10;
}

@end
