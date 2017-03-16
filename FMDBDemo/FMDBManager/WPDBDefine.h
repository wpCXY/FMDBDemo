//
//  WPDBDefine.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#ifndef WPDBDefine_h
#define WPDBDefine_h



/**
 数据库操作类型

 - WPDBOperationTypeCreate: 创建表操作
 - WPDBOperationTypeQuery:  查询操作
 - WPDBOperationTypeInsert: 插入数据操作
 - WPDBOperationTypeDelete: 删除数据操作
 - WPDBOperationTypeUpdate: 更新数据操作
 - WPDBOperationTypeDrop:   删除表操作
 */
typedef NS_ENUM( NSInteger, WPDBOperationType) {
    WPDBOperationTypeCreate,
    WPDBOperationTypeQuery,
    WPDBOperationTypeInsert,
    WPDBOperationTypeDelete,
    WPDBOperationTypeUpdate,
    WPDBOperationTypeDrop
};
#endif /* WPDBDefine_h */
