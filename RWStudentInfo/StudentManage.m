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
sqlite3 *student;
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
    if(sqlite3_open(dbfilepath, &student) == SQLITE_OK) {
//        NSLog(@"dbFilePath:%@",dbFilePath);
        NSLog(@"打开/创建数据库成功");
        // 创建数据表...
        
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
        if(sqlite3_exec(student, sql, NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"创建数据表students成功");
            // 插入数据...
            
        }else {
            NSLog(@"创建数据表students失败");
        }

    }
    return FALSE;
}
/**
 插入一条数据 动态
 
 @return TRUE 成功 FALSE 失败
 */
+ (BOOL) insertData:(NSString *)name age:(NSString *)age gender:(NSString *)gender score:(NSString *)score {
    if ([self openDB]) { // 打开数据库成功
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
        if(sqlite3_exec(student, sql, NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"插入数据成功");
            NSLog(@"dbFilePath:%@",dbFilePath);
            gender = (0==gender.intValue?@"男":(1==gender.intValue?@"女":@"未知"));
            double doubleScore = [score doubleValue];
            NSLog(@"学生姓名 %@，年龄 %@，性别 %@，成绩%.2f",name,age,gender,doubleScore);
            sqlite3_close(student);
            return TRUE;
        }else {
            NSLog(@"插入数据失败");
            fprintf(stderr, "SQL error: %s\n", err);
            sqlite3_close(student);
            return FALSE;
        }
    }else {
        return FALSE;
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
        if(sqlite3_exec(student, sql, NULL, NULL, NULL) == SQLITE_OK) {
            NSLog(@"插入数据成功");
            sqlite3_close(student);
            return TRUE;
        }else {
            NSLog(@"插入数据失败");
            sqlite3_close(student);
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
        
        char head[100] = "SELECT name,age,gender,score FROM students WHERE name = ";
        char tail[10] = "\");";
        char sql[1024];
        char *tmpsql = "";
        tmpsql = strcat(tmpsql, head);
        tmpsql = strcat(tmpsql, "\",");
        tmpsql = strcat(tmpsql, tail);
        strcpy(sql, tmpsql);
        
        // 执行sql
        char *err;
        if(sqlite3_exec(student, sql, NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"查询到数据");
            
        }
        
        
        return stu;
    }else {
        return nil;
    }
}





@end
