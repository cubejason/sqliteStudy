//
//  animal.h
//  sqlite3Demo
//
//  Created by mac-mini2 on 16/9/7.
//  Copyright © 2016年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface animal : NSObject

@property(copy,nonatomic)NSString *animalID;
@property(copy,nonatomic)NSString *name;
@property(assign,nonatomic)int price;
@property(copy,nonatomic)NSString *type;
@property(copy,nonatomic)NSString *color;

@end
