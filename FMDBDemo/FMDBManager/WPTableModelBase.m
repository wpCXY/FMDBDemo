//
//  WPTableModelBase.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPTableModelBase.h"

@implementation WPTableModelBase

/**
 *  获取数据库操作语句
 *
 *  @param queryType 数据库操作类型
 *
 *  @return SQL 语句
 */
- (NSString *)getSqlWithQueryType:(WPDBOperationType)operationType {
    switch (operationType) {
        case WPDBOperationTypeCreate:
            return @"CREATE TABLE IF NOT EXISTS t_book (_id INTEGER PRIMARY KEY AUTOINCREMENT, bookId varchar(40) NOT NULL ,userId varchar(20),bookName varchar(100),bookCoverPath varchar(300),chapterId varchar(40) NOT NULL,chapterName varchar(100),resourceUrl varchar(300),resourcePath varchar(300),resourceSize REAL,downloadProgress REAL,downloadState INTEGER,packageId var(40),localZipPath var(300));";
            break;
        case WPDBOperationTypeInsert:
            return @"INSERT OR REPLACE INTO t_book";
            break;
        case WPDBOperationTypeQuery:
            return @"SELECT * FROM t_book";
            break;
        case WPDBOperationTypeUpdate:
        {
            return @"UPDATE t_book SET";
        }break;
        case WPDBOperationTypeDelete:
            return @"DELETE FROM t_book";
            break;
        case WPDBOperationTypeDrop:
            return @"DROP TABLE t_book";
            break;
        default:
            break;
    }
    return nil;
}
/**
 *  获取数据库表添加列的语句
 *
 *  @return 数组中为字典。key为新增地段名称，value为新增字段sql语句
 */
- (NSArray *)getSqlArrayForAddColumns {
    return nil;
}
/**
 *  从 FMDB 结果转化为 model
 *
 *  @param resultSet FMDB 结果
 *
 *  @return model 对象
 */
+ (id)getModelFromFMResultSet:(FMResultSet *)resultSet {
    return nil;
}

@end
