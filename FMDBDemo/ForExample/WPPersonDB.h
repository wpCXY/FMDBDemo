//
//  WPPersonDB.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDBBase.h"
#import "WPPersonTableModel.h"

@interface WPPersonDB : WPDBBase

//建库
- (BOOL)createDatabase;

//建表
- (BOOL)createPersonTable;

//插数据
- (BOOL)insertPerson:(WPPersonTableModel *)person;

//更新数据
- (BOOL)updatePerson:(WPPersonTableModel *)person;
#pragma mark - 查数据操作
- (NSArray *)queryPersonWithParams:(NSDictionary *)params;
- (NSArray *)queryPersonWithName:(NSString *)personName;
- (NSArray *)queryPersonWithPersonID:(NSString *)personID;
- (NSArray *)queryPersonWithAge:(NSString *)age;

@end
