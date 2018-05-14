//
//  THNUnitPriceValueFormatter.m
//  banmen
//
//  Created by dong on 2017/8/21.
//  Copyright © 2017年 banmen. All rights reserved.
//

#import "THNUnitPriceValueFormatter.h"

@implementation THNUnitPriceValueFormatter

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    return [NSString stringWithFormat:@"%.0f%%", value];
}

@end
