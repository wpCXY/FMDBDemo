//
//  WPDBBase.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPDBBase.h"
#import <FMDB.h>
#import "WPTableModelBase.h"

@interface WPDBBase ()

@property (nonatomic, strong) NSConditionLock *lock;

@property (nonatomic, strong) FMDatabase *dataBase;

@end

@implementation WPDBBase

#pragma mark - Life Cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [[NSConditionLock alloc] init];
    }
    return self;
}
+ (instancetype)shareDefault {
    return nil;
}
+ (void)destory {
    
}


#pragma mark - Publick

/**
 数据库操作
 
 @param operationType 操作类型
 @param params 插入更新操作时的参数
 @return 查询操作时返回结果为NSArray 其他类型操作为 NSNumble BOOL Value
 */
- (id)dataBaseOperationType:(WPDBOperationType)operationType andParams:(NSDictionary *)params {
    // 根据对应的数据表模型获取sql语句
    id tableModel = [[_TableModelClass alloc] initWithDictionary:params];
    NSString *sql = [tableModel getSqlWithQueryType:operationType];
    switch (operationType) {
        case WPDBOperationTypeCreate:
        {
           return [NSNumber numberWithBool:[self creatTableWithSqlString:sql]];
        }
            break;
        case WPDBOperationTypeQuery:
        {
            [self queryWithSql:sql params:params];
        }
            break;
        case WPDBOperationTypeInsert:
        {
            return [NSNumber numberWithBool:[self insertWithSql:sql params:params]];
        }
            break;
        case WPDBOperationTypeDelete:
        {
           return [NSNumber numberWithBool:[self deleteWitlSql:sql params:params]];
        }
            break;
        case WPDBOperationTypeUpdate:
        {
            return [NSNumber numberWithBool:[self executeUpdate:sql withParameterDictionary:params]];
        }
            break;
        case WPDBOperationTypeDrop:
        {
            return [NSNumber numberWithBool:[self executeUpdate:sql]];
        }
            break;
        default:
            break;
    }

        return nil;
}
#pragma mark - SQL操作

/**
 执行查询操作，根据sql基础语句和参数拼接slq语句。

 @param sql sql基础语句
 @param params 参数
 @return 查询结果数组
 */
- (NSMutableArray *)queryWithSql:(NSString *)sql params:(NSDictionary *)params {
    if (params.allKeys.count > 0) {
        sql = [sql stringByAppendingString:@" where "];
        for (int i = 0; i < params.allKeys.count; i++) {
            NSString *key = params.allKeys[i];
            if (i != [params allKeys].count - 1) {
                //冒号加 key 的方式“ : key ”，表示这个字段从后面的 dictionary 中取 value
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@ and ",key,key]];
            }else{
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@;",key,key]];
            }
        }
    }
    
    /*
     栗子：
     sql: SELECT * FROM t_person where userId = :userId;
     params:
     {
     userId = 461660873;
     }
     */
    return [self executeQuery:sql withParameterDictionary:params];

}

/**
 执行查询操作

 @param sql 基础sql语句
 @param params 参数
 @return 执行结果
 */
- (BOOL)insertWithSql:(NSString *)sql params:(NSDictionary *)params {
    NSString *param = @" (";
    NSString *value = @" values(";
    NSMutableArray *paramsArray = [NSMutableArray arrayWithArray:[params allKeys]];
    
    //冒号加 key 的方式“ : key ”，表示这个字段从后面的 dictionary 中取 value
    for (int i = 0;i < paramsArray.count;i++) {
        NSString *key = [paramsArray objectAtIndex:i];
        if (i != paramsArray.count - 1){
            param = [param stringByAppendingString:[NSString stringWithFormat:@"%@,",key]];
            value = [value stringByAppendingString:[NSString stringWithFormat:@":%@,",key]];
        }else {
            param = [param stringByAppendingString:[NSString stringWithFormat:@"%@)",key]];
            value = [value stringByAppendingString:[NSString stringWithFormat:@":%@)",key]];
        }
    }
    
    sql = [sql stringByAppendingString:param];
    sql = [sql stringByAppendingString:value];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSString *key in [params allKeys]) {
        [result setValue:[params valueForKey:key] forKeyPath:key];
    }
    /*
     栗子：
     INSERT OR REPLACE INTO t_book (packageId,downloadState,bookId,userId,chapterName,resourceSize,chapterId) values(:packageId,:downloadState,:bookId,:userId,:chapterName,:resourceSize,:chapterId)
     params
     {
     bookId = "";
     chapterId = 1035803;
     chapterName = "\U7b2c1\U671f";
     downloadState = 2;
     packageId = 4803;
     resourceSize = 6092226;
     userId = 543746865;
     }
     */
    return [self executeUpdate:sql withParameterDictionary:result];

}
- (BOOL)deleteWitlSql:(NSString *)sql params:(NSDictionary *)params {
    if (params.allKeys.count > 0) {
        sql = [sql stringByAppendingString:@" where "];
        for (int i = 0;i < [params allKeys].count;i++) {
            NSString *key = params.allKeys[i];
            if (i != [params allKeys].count - 1) {
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@ and ",key, key]];
            }else{
                sql = [sql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@;",key, key]];
            }
        }
    }
    return [self executeUpdate:sql withParameterDictionary:params];
}
#pragma mark - 数据库的初始化操作
/**
 创建数据库对象
 
 @param path 数据库路径
 @return YES 创建成功 NO 创建失败
 */
- (BOOL)creatDataBaseWithPath:(NSString *)path {
    [_lock lock];
    if (!path.length) {
        [_lock unlock];
        return NO;
    }
    _dataBase = [FMDatabase databaseWithPath:path];
    if (![_dataBase open]) {
        NSLog(@"DataBase Creat Fail With Path:%@",path);
        [_lock unlock];
        return NO;
    };
    NSLog(@"DataBase Creat With Path:%@",path);
    [_dataBase close];
    [_lock unlock];
    return YES;
}
/**
 创建表

 @param sqlStr 创建表sql语句
 @return 创建结果 YES 创建成功 NO 创建失败
 */
- (BOOL)creatTableWithSqlString:(NSString *)sqlStr{
   
    if (sqlStr.length && _tableName.length) {
        // 先判断数据库中表是否存在
        BOOL tableIsExist = [self checkTableIsExistWithTableName:_tableName];
        
        if (!tableIsExist) {//不存在
            BOOL result = [self executeUpdate:sqlStr];
            if (!result) {
                return NO;
            }
        }
        // 检查表中是否有新增字段
        id tableModelClass = [[_TableModelClass alloc] init];
        NSDictionary *columnDic = [tableModelClass getSqlArrayForAddColumns];
        for (NSString *key in [columnDic allKeys]) {//新增字段失败怎么办
            [self addColumnWithSqlString:columnDic[key] columnName:key];
        }
        return YES;
    }
    return NO;
};

/**
 表新增字段

 @param sqlStr 新增字段sql语句
 @param cloumnName 新增字段名称
 */
- (void)addColumnWithSqlString:(NSString *)sqlStr columnName:(NSString *)cloumnName {
    //添加列，软件升级时，需要在旧数据库表加列，因为直接改表会出错
    if ([_dataBase open]) {// 打开数据库，在执行查询
        if (![_dataBase columnExists:cloumnName inTableWithName:_tableName]) {
            [self executeUpdate:sqlStr];
        }
    }
}

/**
 检查数据库中表是否存在

 @param tableName 表名
 @return YES 存在 NO 不存在
 */
- (BOOL)checkTableIsExistWithTableName:(NSString *)tableName{
   
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName];
    [_lock lock];
    BOOL tableIsExist = NO;
    if ([_dataBase open]) {
        FMResultSet *res = [_dataBase executeQuery:existsSql];
        if ([res next]) {
            NSInteger count = [res intForColumn:@"countNum"];
            if (count == 1) {
                NSLog(@"%@ table is existed.",tableName);
                tableIsExist = YES;
            }  else {
                NSLog(@"%@ is not existed.",tableName);
                tableIsExist = NO;
            }
        }
        [_dataBase close];
    }
    [_lock unlock];
  
    return tableIsExist;
};

#pragma mark - sql非查询语句执行
- (BOOL)executeUpdate:(NSString *)sql {
    [_lock lock];
    BOOL res = NO;
    if ([_dataBase open]) {
       res = [_dataBase executeUpdate:sql];
        [_dataBase close];
    }
    [_lock unlock];
    return res;
}
- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)parameter {
    [_lock lock];
    BOOL res = NO;
    if ([_dataBase open]) {
        res = [_dataBase executeUpdate:sql withParameterDictionary:parameter];
        [_dataBase close];
    }
    [_lock unlock];
    return res;
}
#pragma mark - sql查询语句执行
//- (FMResultSet *)executeQuery:(NSString *)sql {
//    [_lock lock];
//    FMResultSet *res = nil;
//    if ([_dataBase open]) {
//        res = [_dataBase executeQuery:sql];
//        [_dataBase close];
//    }
//    [_lock unlock];
//    return res;
//}

/**
 执行sql查询语句，在线程锁中执行，控制数据的打开和关闭

 @param sql sql
 @param arguments 参数
 @return 查询结果
 注： 查询的结果需要在数据库close之前处理完成。即不能将FMResultSet作为返回值返回
 */
- (NSMutableArray *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    [_lock lock];
    FMResultSet *res = nil;
    NSMutableArray *resultArray = [NSMutableArray array];
    if ([_dataBase open]) {
        res = [_dataBase executeQuery:sql withParameterDictionary:arguments];
        while ([res next]) {
            [resultArray addObject:[_TableModelClass getModelFromFMResultSet:res]];
        }
        [_dataBase close];
    }
    [_lock unlock];
    return resultArray;
}
@end
