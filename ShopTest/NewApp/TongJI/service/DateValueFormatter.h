//
//  DateValueFormatter.h
//  Shop
//
//  Created by 董永胜 on 2018/5/10.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsSwift.h"

@interface DateValueFormatter : NSObject <IChartAxisValueFormatter>

@property (nonatomic, strong) NSArray *arr;
-(id)initWithArr:(NSArray *)arr;

@end
