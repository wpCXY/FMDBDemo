//
//  WPPersonTableModel.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "WPPersonTableModel.h"

@implementation WPPersonTableModel
#pragma mark - Model
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.name     = [dict valueForKey:@"name"];
        self.age      = [dict valueForKey:@"age"];
        self.personID = [dict valueForKey:@"personID"];
        self.weight   = [dict valueForKey:@"weight"];
        self.height   = [dict valueForKey:@"height"];
        self.aNewCloum =[dict valueForKey:@"aNewCloum"];
    }
    return self;
}
- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [super toDictionary];
    [dic setValue:self.name     forKey:@"name"];
    [dic setValue:self.age      forKey:@"age"];
    [dic setValue:self.personID forKey:@"personID"];
    [dic setValue:self.height   forKey:@"height"];
    [dic setValue:self.weight   forKey:@"weight"];
    [dic setValue:self.aNewCloum forKey:@"aNewCloum"];
    return dic;
}
#pragma mark - DB
- (NSString *)getSqlWithQueryType:(WPDBOperationType)operationType {
    
    switch (operationType) {
        case WPDBOperationTypeCreate:
            return @"CREATE TABLE IF NOT EXISTS T_PersonTable (_id INTEGER PRIMARY KEY AUTOINCREMENT, personID varchar(40) NOT NULL ,name varchar(20),height varchar(20),weight varchar(20),age varchar(20));";
            break;
        case WPDBOperationTypeInsert:
            return @"INSERT OR REPLACE INTO T_PersonTable";
            break;
        case WPDBOperationTypeQuery:
            return @"SELECT * FROM T_PersonTable";
            break;
        case WPDBOperationTypeUpdate:
        {
            return [self sqlForUpdate];
        }break;
        case WPDBOperationTypeDelete:
            return @"DELETE FROM T_PersonTable";
            break;
        case WPDBOperationTypeDrop:
            return @"DROP TABLE T_PersonTable";
            break;
        default:
            break;
    }
    return nil;

}
- (NSString*)sqlForUpdate
{
    NSMutableDictionary *params = [self toDictionary];
    NSString *sql = @"UPDATE T_PersonTable SET %@ where name = :name and personID = :personID";
    
    NSString *setSql = @"";
    if (params.allKeys.count > 0) {
        for (int i = 0;i < [params allKeys].count;i++) {
            NSString *key = [[params allKeys] objectAtIndex:i];
            if (i != [params allKeys].count - 1) {
                setSql = [setSql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@,",key,key]];
            }else{
                setSql = [setSql stringByAppendingString:[NSString stringWithFormat:@"%@ = :%@",key,key]];
            }
        }
    }
    sql = [NSString stringWithFormat:sql,setSql];
    return sql;
    /*
     栗子：
     UPDATE t_book SET packageId = :packageId,downloadState = :downloadState,downloadProgress = :downloadProgress,resourcePath = :resourcePath,bookId = :bookId,userId = :userId,chapterName = :chapterName,resourceSize = :resourceSize,examBook = :examBook,chapterId = :chapterId,isFree = :isFree where resourceUrl = :resourceUrl and userId = :userId
     params:
     {
     bookId = "";
     chapterId = 1035803;
     chapterName = "\U7b2c1\U671f";
     downloadProgress = 0;
     downloadState = 2;
     examBook = 0;
     isFree = 0;
     packageId = 4803;
     resourcePath = "/epaper/packages/catalogue_4803_1035803";
     resourceSize = 6091265;
     userId = 543746865;
     }
     */
}
+ (id)getModelFromFMResultSet:(FMResultSet *)resultSet {
    
    if (resultSet) {
        WPPersonTableModel *personModel = [[WPPersonTableModel alloc] init];
        personModel.name     = [resultSet stringForColumn:@"name"];
        personModel.age      = [resultSet stringForColumn:@"age"];
        personModel.personID = [resultSet stringForColumn:@"personID"];
        personModel.weight   = [resultSet stringForColumn:@"weight"];
        personModel.height   = [resultSet stringForColumn:@"height"];
        personModel.aNewCloum = [resultSet stringForColumn:@"aNewCloum"];
        return personModel;
    }
    return nil;
}
- (NSDictionary *)getSqlArrayForAddColumns {
    return @{@"aNewCloum":@"ALTER TABLE T_PersonTable ADD COLUMN  aNewCloum varchar(32)"};
}


@end
