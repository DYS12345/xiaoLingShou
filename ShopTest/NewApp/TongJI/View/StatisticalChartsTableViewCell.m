//
//  StatisticalChartsTableViewCell.m
//  Shop
//
//  Created by 董永胜 on 2018/5/9.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "StatisticalChartsTableViewCell.h"
#import "UIView+FSExtension.h"
#import "Masonry.h"
#import "UIColor+Extension.h"
#import "THNUnitPriceValueFormatter.h"
#import "DateValueFormatter.h"

@implementation StatisticalChartsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //点击订单数按钮后，订单数按钮被选中，销售额按钮不被选中，订单数按钮可以被点击，销售额按钮不可以被点击，点击销售额按钮被选中，订单数按钮不被选中，再次点击没有反应
    [self.contentView addSubview:self.lineChartView];
    [_lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.ordersBtn.mas_bottom).mas_offset(30);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-15);
    }];
    
    [self setLineChartData];
}


#pragma mark 折线图
-(LineChartView *)lineChartView{
    if (!_lineChartView) {
        _lineChartView = [[LineChartView alloc] init];
        _lineChartView.noDataText = @"暂无数据";
        _lineChartView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f9"];
        _lineChartView.delegate = self;
        _lineChartView.chartDescription.enabled = NO;
        _lineChartView.dragEnabled = YES;
        [_lineChartView setScaleEnabled:YES];
        _lineChartView.pinchZoomEnabled = YES;
        _lineChartView.drawGridBackgroundEnabled = YES;
        _lineChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        _lineChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显 
        
        [_lineChartView setExtraOffsetsWithLeft:0 top:0 right:0 bottom:10];
        
        _lineChartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
        _lineChartView.xAxis.drawGridLinesEnabled = YES;
        _lineChartView.xAxis.gridLineDashPhase = 0.f;
        _lineChartView.xAxis.labelPosition = XAxisLabelPositionBottom;
        _lineChartView.maxVisibleCount = 6;//设置能够显示的数据数量
        _lineChartView.xAxis.labelFont = [UIFont systemFontOfSize:7];
        _lineChartView.xAxis.gridColor = [UIColor colorWithHexString:@"#E7E7E7"];
        
        ChartYAxis *leftAxis = _lineChartView.leftAxis;
        [leftAxis removeAllLimitLines];
        leftAxis.gridLineDashLengths = @[@1.f, @1.f];
        leftAxis.gridColor = [UIColor colorWithHexString:@"#E7E7E7"];
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.drawLimitLinesBehindDataEnabled = YES;
        leftAxis.axisLineDashLengths = @[@0.f, @0.0f];
        leftAxis.spaceTop = 0.0;
        leftAxis.valueFormatter = [[THNUnitPriceValueFormatter alloc] init];
        
        
        _lineChartView.rightAxis.enabled = NO;
        
        _lineChartView.legend.enabled = NO;
        
        ChartMarkerView *marker = [[ChartMarkerView alloc] init];
        marker.backgroundColor = [UIColor blackColor];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spot"]];
        image.frame = CGRectMake(0, 0, 10, 10);
        image.center = marker.center;
        [marker addSubview:image];
        //创建一个黑色的View，将这个View添加在maker上
        UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(-50, -65, 100, 60)];
        showView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        imageView.image = [UIImage imageNamed:@"promptBox"];
        [showView addSubview:imageView];
        [marker addSubview:showView];
        _lineChartView.marker = marker;
        
        [_lineChartView animateWithXAxisDuration:1.5];
        
    }
    return _lineChartView;
}

#pragma mark 为折线图设置数据源
-(void)setLineChartData{
    NSInteger xVals_count = 50;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        if (i<30) {
            [xVals addObject: [NSString stringWithFormat:@"02-%d",i]];
        }else{
            [xVals addObject: [NSString stringWithFormat:@"03-%d",i-29]];
        }
    }
    self.lineChartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:xVals];
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        int a = arc4random() % 100;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
        [yVals addObject:entry];
    }

    LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
    set1.drawIconsEnabled = NO;
    set1.drawValuesEnabled = NO;
    
    
    set1.mode = LineChartModeHorizontalBezier;
    
    set1.lineDashLengths = @[@100.f, @0.f];
    //下面是关于点击时候的十字线的设置
    set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    set1.highlightColor = [UIColor colorWithHexString:@"#02A65A"];//点击选中拐点的十字线的颜色
    
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = YES;
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.drawFilledEnabled = YES;//是否填充颜色
    set1.fillColor = [UIColor colorWithHexString:@"#38D6B8"];
    set1.valueFont = [UIFont systemFontOfSize:9.f];
//    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;
    [set1 setColor:[UIColor colorWithHexString:@"#28AA5A"]];//折线颜色
    
//    NSArray *gradientColors = @[
//                                (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
//                                (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
//                                ];
//    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
//
//    set1.fillAlpha = 1.f;
//    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
//
//    CGGradientRelease(gradient);
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
    
    self.lineChartView.data = data;
    
}

#pragma mark 点击折线时的代理方法
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {

//    _markY.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];//改变选中的数据时候，label的值跟着变化
    //将点击的数据滑动到中间
    [self.lineChartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[self.lineChartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];

}

#pragma mark 点击销售额的方法
- (IBAction)xiaoshouE:(UIButton*)sender {
    self.xiaoshouEBtn.selected = YES;
    self.ordersBtn.selected = NO;
    self.ordersBtn.userInteractionEnabled = YES;
    self.xiaoshouEBtn.userInteractionEnabled = NO;
}

#pragma mark 点击订单数的方法
- (IBAction)orders:(UIButton*)sender {
    self.ordersBtn.selected = YES;
    self.xiaoshouEBtn.selected = NO;
    self.ordersBtn.userInteractionEnabled = NO;
    self.xiaoshouEBtn.userInteractionEnabled = YES;
}

@end
