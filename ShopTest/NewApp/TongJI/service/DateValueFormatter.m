//
//  DateValueFormatter.m
//  Shop
//
//  Created by 董永胜 on 2018/5/10.
//  Copyright © 2018年 董永胜. All rights reserved.
//

#import "DateValueFormatter.h"

@implementation DateValueFormatter

-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}
-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _arr[(NSInteger)value];
}


@end
