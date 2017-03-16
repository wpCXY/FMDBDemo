//
//  WPDBBase.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WPDBDefine.h"


/**
 数据库操作基础类
 */
@interface WPDBBase : NSObject


/**
 表名称，子类在初始化的时候需要赋值
 */
@property (nonatomic, strong) NSString *tableName;

/**
 表对应的数据模型，子类在初始化的时候需要确定
 */
@property (nonatomic, strong) Class     TableModelClass;


/**
 单例创建方法，子类可重写该方法实现单例

 @return 对象
 */
+ (instancetype)shareDefault;

/**
 单例销毁方法，当数据库对象需要销毁重写创建时调用，子类重写方法具体是实现
 */
+ (void)destory;
/**
 创建数据库

 @param path 数据库文件路径
 @return 创建结果 YES 成功 NO 失败
 */
- (BOOL)creatDataBaseWithPath:(NSString *)path;

/**
 数据库操作

 @param operationType 操作类型
 @param params 插入更新操作时的参数
 @return 查询操作时返回结果为NSArray 其他类型操作为 NSNumble BOOL Value
 */
- (id)dataBaseOperationType:(WPDBOperationType)operationType andParams:(NSDictionary *)params;
@end
