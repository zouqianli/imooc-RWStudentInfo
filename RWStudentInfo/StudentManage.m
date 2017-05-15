//
//  StudentManage.m
//  RWStudentInfo
//
//  Created by 邹前立 on 2017/5/13.
//  Copyright © 2017年 邹前立. All rights reserved.
//

#import "StudentManage.h"
#import "Student.h"
#import <sqlite3.h>
#include <string.h>
#import <stdio.h>
@implementation StudentManage
// sqlite3结构体数据库 指针对象 全局变量，其他函数可以调用
sqlite3 *students;
NSString *dbFilePath;
/**
 返回数据库路径

 @param DBName 数据库文件名字
 @return 返回数据库路径
 */
+ (NSString *) studentManageDatabasePath:(NSString *)DBName {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *DBPath = [documents stringByAppendingPathComponent:DBName];
    return DBPath;
}

+ (BOOL) openDB {
    // 获取数据库路径
    dbFilePath = [self studentManageDatabasePath:@"stu.DB"];
    // 将路径转换为 C语言字符串
    const char *dbfilepath = [dbFilePath UTF8String];
//    // sqlite3结构体数据库 指针对象
//    sqlite3 *student;
    // 打开db路径下的student数据库
    if(sqlite3_open(dbfilepath, &students) == SQLITE_OK) {
        NSLog(@"dbFilePath:%@",dbFilePath);
        NSLog(@"打开/创建数据库成功");
        // 创建数据表...
        // 查询，修改，删除，添加。。。
        
        return TRUE;
    }else {
        NSLog(@"打开/创建数据库失败");
        return FALSE;
    }
}

/**
 创建表students

 @return TRUE 成功 FALSE 失败
 */
+ (BOOL) createTable {
    if ([self openDB]) { // 打开数据库成功
        // 创建数据表
        char *sql = "CREATE TABLE IF NOT EXISTS students (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, AGE INTEGER, GENDER INTEGER, SCORE DOUBLE);";
        // 执行sql语句
        if(sqlite3_exec(students, sql, NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"创建数据表students成功");
            // 插入数据...
            sqlite3_close(students);
        }else {
            NSLog(@"创建数据表students失败");
            sqlite3_close(students);
        }

    }
    return FALSE;
}
/**
 插入一条数据 动态
 
 @return TRUE 成功 FALSE 失败
 */
+ (Student *) insertData:(NSString *)name age:(NSString *)age gender:(NSString *)gender score:(NSString *)score {
    if ([self openDB]) { // 打开数据库成功
        // 输入过滤
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (name.length <= 0) {
            return nil;// 没有数据
        }
        const char *stuName   = [name UTF8String];
        const char *stuAge    = [age UTF8String];
        const char *stuGender = [gender UTF8String];
        const char *stuScore  = [score UTF8String];
        // sql语句
//        char *sql = "INSERT INTO students VALUES(null, stuName, stuAge, 0, 92.3);";
        // *** 将 变量 拼成字符串 ***
        char head[100] = "INSERT INTO students VALUES(null,\"";
        char tail[10] = "\");";
        char sql[1024];
        char *tmpsql; // 拼的很累
        tmpsql = strcat(head, stuName); // strcat(s1,s2);
        tmpsql = strcat(tmpsql, "\",\"");
        tmpsql = strcat(tmpsql, stuAge);
        tmpsql = strcat(tmpsql, "\",\"");
        tmpsql = strcat(tmpsql, stuGender);
        tmpsql = strcat(tmpsql, "\",\"");
        tmpsql = strcat(tmpsql, stuScore);
        tmpsql = strcat(tmpsql, tail);
        strcpy(sql, tmpsql);  // strcpy(s3,s4);
        
        // 插入数据
        char *err;
        if(sqlite3_exec(students, sql, NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"插入数据成功");
            NSLog(@"dbFilePath:%@",dbFilePath);
            gender = (0==gender.intValue?@"男":(1==gender.intValue?@"女":@"未知"));
            double doubleScore = [score doubleValue];
            NSLog(@"学生姓名 %@，年龄 %@，性别 %@，成绩%.2f",name,age,gender,doubleScore);
            sqlite3_close(students);
            Student *stu = [[Student alloc] init];
            stu.name = name;
            stu.age = age.intValue;
            stu.gender = gender.intValue;
            stu.score = score.doubleValue;
            return stu;
        }else {
            NSLog(@"插入数据失败");
            fprintf(stderr, "SQL error: %s\n", err);
            sqlite3_close(students);
            return nil;
        }
    }else {
        return false;
    }
}
/**
 插入一条数据 固定

 @return TRUE 成功 FALSE 失败
 */
+ (BOOL) insertData {
    if ([self openDB]) { // 打开数据库成功
        // sql语句
        char *sql = "INSERT INTO students VALUES(null, \"zz\", 18, 0, 92.3);";
        
        // 插入数据
        if(sqlite3_exec(students, sql, NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"插入数据成功");
            sqlite3_close(students);
            return TRUE;
        }else {
            NSLog(@"插入数据失败");
            sqlite3_close(students);
            return FALSE;
        }
    }else {
        return FALSE;
    }
}
+ (void) testStrcat {
//    #include <string.h>
//    char *strcat( char *str1, const char *str2 );
    
//     char *str1 = "hello";
//     const char *str2 = " world";
//     char *str3 = strcat(str1,str2);
//    printf("str3=%s",str3);
    
    char name[10] = "name";
    char age[10] = " 10";
    char title[200];
//    printf( "Enter your name: " );
//    scanf( "%s", name );
//    title = strcat( name, " the Great" );
    printf( "Hello, %s\n", strcpy(title, strcat(name, age)) );
}

+ (Student *) getOneData:(Student *) stu withName:(NSString *) stuName {
    if ([self openDB]) {
        
        char head[100] = "SELECT name,age,gender,score FROM students WHERE name = \"";
        char tail[10] = "\";";
        char sql[1024];
        char *tmpsql = "";
        tmpsql = strcat(head, [stuName UTF8String]);
        tmpsql = strcat(tmpsql, "\",");
        tmpsql = strcat(tmpsql, tail);
        strcpy(sql, tmpsql);
        
        // 执行sql
        char *err;
        if(sqlite3_exec(students, sql, NULL, NULL, &err) == SQLITE_ROW) {
            NSLog(@"查询到数据");
            // ...
            
            sqlite3_close(students);
            return stu;
        }else {
            NSLog(@"没有查询到名称为：%@ 的数据",stuName);
            sqlite3_close(students);
            return nil;
        }
    }else {
        return nil;
    }
}
+ (Student *) getOneStuWithName:(NSString *) stuName {
    if ([self openDB]) {
        char sql_stmt[1024];
        sqlite3_stmt *statement;
        // 输入过滤
        stuName = [stuName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (stuName.length <= 0) {
            sqlite3_close(students);
            return nil;// 没有数据
        }
        // 查询数据
//        snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "SELECT name,age,gender,score FROM students WHERE name = \"nan\";"); // 固定stuName
        
        char head[100] = "SELECT name,age,gender,score FROM students WHERE name = \"";
        char tail[10] = "\";";
        char *tmpsql = "";
        tmpsql = strcat(head, [stuName UTF8String]);
        tmpsql = strcat(tmpsql, tail);
        snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", tmpsql); // 不固定stuName
        
        // 准备一个sql语句，用于执行
        sqlite3_prepare_v2(students, sql_stmt, -1, &statement, NULL);
        // 执行准备语句，找到返回SQLITE_ROW
        
        if(sqlite3_step(statement) == SQLITE_ROW) {
            Student *stu = [[Student alloc] init];
            NSLog(@"查询到名称为：'%@'的数据",stuName);
//            int id = sqlite3_column_int(statement, 0); // sql加上这个查询字段，下面字段序号改变（0，1，2，3，4）
            NSString *name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            int age = sqlite3_column_int(statement, 1);
            int gender = sqlite3_column_int(statement, 2);
            double score = sqlite3_column_double(statement, 3);
            
            // 赋值stu
            stu.name = name;
            stu.age = age;
            stu.gender = gender;
            stu.score = score;
            NSString *genderStr = (gender==0?@"男":(gender==1?@"女":@"unkown"));
            NSLog(@"学生姓名 %@, 年龄 %d, 性别 %@, score %.2f",name,age,genderStr,score);
            
            sqlite3_finalize(statement);
            sqlite3_close(students);
            return stu;
        }else {
            NSLog(@"没有查询到名称为：'%@'的数据",stuName);
            sqlite3_finalize(statement);
            sqlite3_close(students);
            return nil;
        }
    }else {
        return nil;
    }
}
+ (NSMutableArray *) getAllStuName {
    if ([self openDB]) {
        char sql_stmt[1024];
        sqlite3_stmt *statement;
        // 查询数据
        snprintf(sql_stmt, sizeof(sql_stmt)/sizeof(char), "%s", "SELECT name FROM students");
        
        // 准备一个sql语句，用于执行
        sqlite3_prepare_v2(students, sql_stmt, -1, &statement, NULL);
        // 执行准备语句，找到返回SQLITE_ROW
        NSMutableArray *stuName = [[NSMutableArray alloc] init];
        while(sqlite3_step(statement) == SQLITE_ROW) {
            Student *stu = [[Student alloc] init];
            
            NSString *name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            
            // 赋值stu
            stu.name = name;
            NSLog(@"查询到姓名:%@",stu.name);
            [stuName addObject:stu.name];
        }
        sqlite3_finalize(statement);
        sqlite3_close(students);
        return stuName;
    }
    return nil;
}
+ (BOOL) deleteOneData:(NSString *) stuName {
    if ([self openDB]) {
        // 输入过滤
        stuName = [stuName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (stuName.length <= 0) {
            sqlite3_close(students);
            return nil;// 没有数据
        }
        char head[100] = "DELETE FROM students WHERE name = \"";
        char tail[10] = "\";";
        char sql[1024];
        char *tmpsql = "";
//        tmpsql = strcat(tmpsql, head);
        tmpsql = strcat(head, [stuName UTF8String]);
        tmpsql = strcat(tmpsql, tail);
        strcpy(sql, tmpsql);
        
        // 执行sql
        char *err;
        if(sqlite3_exec(students, sql, NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"找到'%@'，删除成功",stuName);
            sqlite3_close(students);
            return TRUE;
            
        }else {
            NSLog(@"没有'%@'，删除失败",stuName);
            fprintf(stderr, "SQL error: %s\n", err);
            sqlite3_close(students);
            return FALSE;
        }
    }else {
        return FALSE;
    }
}
+ (BOOL) deleteAllData {
    if ([self openDB]) {
        
        char *sql = "DELETE FROM students";
        
        // 执行sql
        char *err;
        if(sqlite3_exec(students, sql, NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"清空数据表成功");
            sqlite3_close(students);
            return TRUE;
            
        }else {
            fprintf(stderr, "SQL error: %s\n", err);
            sqlite3_close(students);
            return FALSE;
        }
    }else {
        return FALSE;
    }
}




@end
