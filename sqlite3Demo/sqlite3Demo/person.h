//
//  person.h
//  sqlite3Demo
//
//  Created by mac-mini2 on 16/9/7.
//  Copyright © 2016年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface person : NSObject

@property(assign,nonatomic)int price;
@property(copy,nonatomic)NSString *animal;
@property(copy,nonatomic)NSString *characteristic;

@end