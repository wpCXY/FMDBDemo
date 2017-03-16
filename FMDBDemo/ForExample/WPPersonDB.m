//
//  WPPersonDB.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPPersonDB.h"
@implementation WPPersonDB

static WPPersonDB *shareDefaul = nil;

#pragma mark - 单例方法
+ (instancetype)shareDefault {
    @synchronized (self) {
        if (shareDefaul == nil) {
            shareDefaul = [[WPPersonDB alloc] init];
            shareDefaul.tableName = @"T_PersonTable";
            shareDefaul.TableModelClass = [WPPersonTableModel class];
            [shareDefaul createDatabase];
            [shareDefaul createPersonTable];
        }
    }
    return shareDefaul;
}
+ (void)destory {
    shareDefaul = nil;
}
#pragma mark - 初始化调用方法
/**
 创建数据库对象

 @return YES 创建成功 NO 创建失败
 */
- (BOOL)createDatabase {
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/DB"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        BOOL result = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error || !result) {
            NSLog(@"create database occur error: %@",error);
            return NO;
        }
    }
    path = [path stringByAppendingString:@"/personDataBase"];
    return [self creatDataBaseWithPath:path];

}
/**
 创建表

 @return YES 创建成功 NO 创建失败
 */
- (BOOL)createPersonTable {
    return [self dataBaseOperationType:WPDBOperationTypeCreate andParams:nil];
}
#pragma mark - 数据操作
//插数据
- (BOOL)insertPerson:(WPPersonTableModel *)person {
    
    NSArray *res = [self queryPersonWithParams:@{@"name":person.name,@"personID":person.personID}];
    if (res.count) {
        //更新操作
       return [self dataBaseOperationType:WPDBOperationTypeUpdate andParams:[person toDictionary]];
    }
    
    return [self dataBaseOperationType:WPDBOperationTypeInsert andParams:[person toDictionary]];
}

//更新数据
- (BOOL)updatePerson:(WPPersonTableModel *)person {
    return [self dataBaseOperationType:WPDBOperationTypeUpdate andParams:[person toDictionary]];
}

- (NSArray *)queryPersonWithParams:(NSDictionary *)params {
    return [self dataBaseOperationType:WPDBOperationTypeQuery andParams:params];
}
- (NSArray *)queryPersonWithName:(NSString *)personName {
    return [self queryPersonWithParams:@{@"name":personName}];
}
- (NSArray *)queryPersonWithPersonID:(NSString *)personID {
    return [self queryPersonWithParams:@{@"personID":personID}];
}
- (NSArray *)queryPersonWithAge:(NSString *)age {
    return [self queryPersonWithParams:@{@"age":age}];
}

@end
