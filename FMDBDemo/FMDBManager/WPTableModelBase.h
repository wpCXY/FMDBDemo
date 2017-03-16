//
//  WPTableModelBase.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDBDefine.h"
#import "WPModel.h"
#import <FMResultSet.h>

/**
 数据库表模型的父类
 主要声明表字段
 返回sql语句
 解析sql语句查询后的结果 FMResultSet转字典或模型
 */
@interface WPTableModelBase : WPModel
/**
  *  获取数据库操作语句
  *
  *  @param operationType 数据库操作类型
  *
  *  @return SQL 语句
  */
- (NSString *)getSqlWithQueryType:(WPDBOperationType)operationType;

/**
 *  获取数据库表添加列的语句
 *
 *  @return 字典。key为新增地段名称，value为新增字段sql语句
 */
- (NSDictionary *)getSqlArrayForAddColumns;

/**
 *  从 FMDB 结果转化为 model
 *
 *  @param resultSet FMDB 结果
 *
 *  @return model 对象
 */
+ (id)getModelFromFMResultSet:(FMResultSet *)resultSet;
@end
