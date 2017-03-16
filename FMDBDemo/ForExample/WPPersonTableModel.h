//
//  WPPersonTableModel.h
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/13.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTableModelBase.h"
@interface WPPersonTableModel : WPTableModelBase

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *personID;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *aNewCloum;

@end
