//
//  BaceData.h
//  iHome
//
//  Created by mac-mini2 on 16/7/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "QuantityModel.h"

@interface DataBace : NSObject

//查询所有天的电量
+ (NSMutableArray *)getAllElectricalQuantityInTable:(NSString *)name;
//查询任意一天的数据
+ (QuantityModel *)getQuantityModelWithID:(NSString *)aID FromTable:(NSString *)name;
//添加新的一天数据
+ (BOOL)insertQuantityModel:(QuantityModel *)aModel ToTable:(NSString *)name;
//删除任意天
+ (BOOL)deleteQuantityModelWithID:(NSString *)aID ToTable:(NSString *)name;

@end
