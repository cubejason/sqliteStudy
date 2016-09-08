//
//  BaceData.m
//  iHome
//
//  Created by mac-mini2 on 16/7/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

//数据库(Database): 存放数据的仓库, 存放的是一张的表, 特别像Excel, Numbers, 都以表格的形式存放数据, 可以创建多张表
//常见的数据库: sqlite, MySQL, SQLServer, Oracle, Access
//为什么要用数据库 1 文件读写和归档读取数据需要一次把数据全部读出来, 占用内存开销大 2 数据库数据效率高, 体现在增删改查
//SQL Structured Query Language 用于对数据库的操作语句 (增删改查)
//SQL 语句不区分大小写, 字符串需要加""或''
//主键: 是一条数据的唯一标示符, 一张表只能有一个主键, 主键不能够重复, 一般把主键名设为"id", 不需要赋值, 会自增
//*代表所有的字段
//where是条件
//创建表: creat table 表名 (字段名 字段数据类型 是否为主键, 字段名 字段数据类型, 字段名 字段数据类型...)
//查: select 字段名 (或者*) from 表名 where 字段名 = 值
//增: insert into 表名 (字段1, 字段2...) values (值1, 值2...)
//改: update 表名 set 字段 = 值 where 字段 = 值
//删: delete from 表名 where 字段 = 值
#import "DataBace.h"

#define FILE_NAME       @"Database.sqlite"
static sqlite3 *db = nil;

@implementation DataBace

+ (int)createDBWithTableName:(NSString *)name{

    //1 获取document文件夹的路径
    //参数1: 文件夹的名字 参数2: 查找域 参数3: 是否使用绝对路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取数据库文件的路径
    NSString *dbPath = [docPath stringByAppendingPathComponent:FILE_NAME];
//    NSLog(@"dbPath:%@",dbPath);
//    //iOS 中管理文件的类, 负责复制文件, 删除文件, 移动文件
//    NSFileManager *fm = [NSFileManager defaultManager];
//    //判断document中是否有sqlite文件
//    if ([fm fileExistsAtPath:dbPath]) {
//
//        NSLog(@"存在这个数据库");
//        const char *path = [dbPath UTF8String];
//        //打开数据库 参数1: 文件路径(UTF8String可以将OC的NSString转为C中的char) 参数2: 接受数据库的指针
//        //本函数是sqlite提供的api，打开一个数据库文件，并与一个sqlite3句柄关联。如果该文件不存在则创建它。返回值如果是SQLITE_OK则打开成功。
//        if (sqlite3_open(path, &db)==SQLITE_OK) {
//
//            NSLog(@"打开数据库成功");
//            int result = [DataBace createTableWithTableName:name];
//            return result;
//        }else {
//            NSLog(@"打开数据库失败");
//            return -1;
//        }
//    }else{
//        NSLog(@"不存在这个数据库");
        const char *path = [dbPath UTF8String];
        if (sqlite3_open(path, &db)==SQLITE_OK) {

            NSLog(@"创建数据库成功");
            //创建表
            int result = [DataBace createTableWithTableName:name];
            return result;
        }else {
            NSLog(@"创建数据库失败");
            return -1;
        }
//    }
    return -1;
}


//创建数据库
+ (int)createTableWithTableName:(NSString *)name{

    char *error;
    //NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY, name TEXT, age INTEGER, address TEXT)";
    //PERSONINFO:表名
    //ID INTEGER PRIMARY KEY，【ID：主键】  【INTEGER：类型】 【PRIMARY KEY：主键的声明】
    //name TEXT,【name：列名】【TEXT：类型】

//    const char *createSQL = "create table if not exists ccffc(id text primary key,totalQuantity integer,heightQuantity integer,lowQuantity integer,miniteNum integer)";
//    int tableResult = sqlite3_exec(db,createSQL, NULL, NULL, &error);
    NSString *createSQL = [NSString stringWithFormat:@"create table if not exists %@ (id text primary key,totalQuantity integer,heightQuantity integer,lowQuantity integer,miniteNum integer)",name];
    int tableResult = sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &error);
    NSLog(@"createSQL:%@",createSQL);

    if (tableResult != SQLITE_OK) {
        NSLog(@"创建表失败:%s  ?Result Codes:%d",error,tableResult);
        return -1;
    }else{
        NSLog(@"创建表成功");
        return tableResult;
    }
    return -1;
}
//打开数据库
+ (sqlite3 *)openDBWithTableName:(NSString *)name{

    if (!db) {

        int result = [DataBace createDBWithTableName:name];
        if (result<0) {
            return nil;
        }
    }else{
        NSLog(@"--------------");
    }
    return db;
}

//关闭数据库
+ (void)closeDB{

    sqlite3_close(db);
    db = nil;
}

//查询所有天的电量
+ (NSMutableArray *)getAllElectricalQuantityInTable:(NSString *)name{
    
    //打开数据库
    sqlite3 *db = [DataBace openDBWithTableName:name];
    if (!db) {
        return nil;
    }
    //数据库操作指针 stmt:statement
    sqlite3_stmt *stmt = nil;
    //验证SQL的正确性 参数1: 数据库指针, 参数2: SQL语句, 参数3: SQL语句的长度 -1代表无限长(会自动匹配长度), 参数4: 返回数据库操作指针, 参数5: 为未来做准备的, 预留参数, 一般写成NULL
//    int result = sqlite3_prepare_v2(db, "select * from quantityModel", -1, &stmt, NULL);
    NSString *selectedAll = [NSString stringWithFormat:@"select * from %@",name];
    int result = sqlite3_prepare_v2(db,[selectedAll UTF8String], -1, &stmt, NULL);
    NSMutableArray *modelArr = [NSMutableArray array];
    //判断SQL执行的结果
    if (result == SQLITE_OK) {
        NSLog(@"----- 查询成功");
        //循环
        while (sqlite3_step(stmt) == SQLITE_ROW) {//存在一行数据
            //列数从0开始
            const unsigned char * ID = sqlite3_column_text(stmt, 0);
            int totalQuantity = sqlite3_column_int(stmt, 1);
            int heightQuantity = sqlite3_column_int(stmt, 2);
            int lowQuantity = sqlite3_column_int(stmt, 3);
            int miniteNum = sqlite3_column_int(stmt, 4);

            //封装QuantityModel模型
            QuantityModel *model = [[QuantityModel alloc] init];
            model.ID = [NSString stringWithUTF8String:(const char *)ID];
            model.totalQuantity = totalQuantity;
            model.heightQuantity = heightQuantity;
            model.lowQuantity = lowQuantity;
            model.duration = miniteNum;
            //添加到数组
            [modelArr addObject:model];
        }

        sqlite3_finalize(stmt);
        [DataBace closeDB];
        return modelArr;
    }else{
        NSLog(@"查询失败,Result Codes:%d",result);
    }
    //释放stmt指针
    sqlite3_finalize(stmt);
    //关闭数据库
    [DataBace closeDB];
    return nil;
}

//查询任意一天的数据
+ (QuantityModel *)getQuantityModelWithID:(NSString *)aID FromTable:(NSString *)name{

    sqlite3 *db = [DataBace openDBWithTableName:name];
    if (!db) {
        return nil;
    }
    sqlite3_stmt *stmt = nil;
    //根据具体的id查询
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where id = '%@'", name,aID];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
    QuantityModel *model = nil;
    if (result == SQLITE_OK) {

        NSLog(@"查询任意一个成功");
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            NSLog(@"取出数据成功");
            //取出数据
            const unsigned char *ID = sqlite3_column_text(stmt, 0);
            int totalQuantity = sqlite3_column_int(stmt, 1);
            int heightQuantity = sqlite3_column_int(stmt, 2);
            int lowQuantity = sqlite3_column_int(stmt, 3);
            int miniteNum = sqlite3_column_int(stmt, 4);

            //封装QuantityModel模型
            model = [[QuantityModel alloc] init];
            model.ID = [NSString stringWithUTF8String:(const char *)ID];
            model.totalQuantity = totalQuantity;
            model.heightQuantity = heightQuantity;
            model.lowQuantity = lowQuantity;
            model.duration = miniteNum;

            sqlite3_finalize(stmt);
            [DataBace closeDB];
            return model;
        }else{
            NSLog(@"取出数据失败");
        }
    }else{
        NSLog(@"查询任意一个失败,Result Codes:%d",result);
    }
    sqlite3_finalize(stmt);
    [DataBace closeDB];
    return nil;
}
//添加新的一天数据
+ (BOOL)insertQuantityModel:(QuantityModel *)aModel ToTable:(NSString *)name{

    sqlite3 *db = [DataBace openDBWithTableName:name];
    if (!db) {
        return NO;
    }
//    NSLog(@"----- 插入数据库");
    sqlite3_stmt *stmt = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (id,totalQuantity,heightQuantity,lowQuantity,miniteNum) values ('%@','%d','%d','%d','%d');",name,aModel.ID, aModel.totalQuantity, aModel.heightQuantity,aModel.lowQuantity,aModel.duration];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {

        //判断语句执行完成没有
        if (sqlite3_step(stmt) == SQLITE_DONE) {

            NSLog(@"---- 插入成功");
        }else{
            NSLog(@"--插入成功 --插入语句没有执行完");
        }
        sqlite3_finalize(stmt);
        [DataBace closeDB];
        return YES;
    }else{
        NSLog(@"插入失败,Result Codes:%d",result);
    }
    sqlite3_finalize(stmt);
    [DataBace closeDB];
    return NO;
}
////修改任意一天的总电量
//+ (BOOL)updateQuantityModelTotal:(int)aTotal byID:(NSString *)aID ToTable:(NSString *)name{
//
//    sqlite3 *db = [DataBace openDB];
//    sqlite3_stmt *stmt = nil;
//    NSString *sqlStr = [NSString stringWithFormat:@"update quantityModel set totalQuantity = '%d' where id = '%@'", aTotal, aID];
//    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
//    if (result == SQLITE_OK) {
//        if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
//            if (sqlite3_step(stmt) == SQLITE_DONE) {
//                sqlite3_finalize(stmt);
//                [DataBace closeDB];
//                return YES;
//            }
//        }
//    }
//    sqlite3_finalize(stmt);
//    [DataBace closeDB];
//    return NO;
//}
//删除任意天
+ (BOOL)deleteQuantityModelWithID:(NSString *)aID ToTable:(NSString *)name{

    sqlite3 *db = [DataBace openDBWithTableName:name];
    if (!db) {
        return nil;
    }
    sqlite3_stmt *stmt = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where id = '%@'", name,aID];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        
        NSLog(@"删除任意一行成功");
        if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则删除
            if (sqlite3_step(stmt) == SQLITE_DONE) {

            }
        }
        sqlite3_finalize(stmt);
        [DataBace closeDB];
        return YES;
    }else{
        NSLog(@"删除任意一行失败,Result Codes:%d",result);
    }
    sqlite3_finalize(stmt);
    [DataBace closeDB];
    return NO;
}

@end
