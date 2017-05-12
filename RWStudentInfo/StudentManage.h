//
//  StudentManage.h
//  RWStudentInfo
//
//  Created by 邹前立 on 2017/5/13.
//  Copyright © 2017年 邹前立. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentManage : NSObject
+ (BOOL) openDB;
+ (BOOL) createTable;
+ (BOOL) insertData:(NSString *)name age:(NSString *)age gender:(NSString *)gender score:(NSString *)score;
+ (BOOL) insertData;

+ (void) testStrcat ;
@end
