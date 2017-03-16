//
//  WPModel.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPModel.h"

@implementation WPModel
- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",[self toDictionary]];
}
@end
