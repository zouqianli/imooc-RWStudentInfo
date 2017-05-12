//
//  Student.h
//  RWStudentInfo
//
//  Created by 邹前立 on 2017/5/13.
//  Copyright © 2017年 邹前立. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property (copy, nonatomic)  NSString *name; // 姓名
@property (assign, nonatomic)  int age; // 年龄
@property (assign, nonatomic)  int gender; // 性别 0 男 1 女
@property (assign, nonatomic)  double score; // 成绩
@end
