//
//  WPModel.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPModel : NSObject
- initWithDictionary:(NSDictionary *)dict;
- (NSMutableDictionary *)toDictionary;
@end
