//
//  ViewController.m
//  RWStudentInfo
//
//  Created by 邹前立 on 2017/5/13.
//  Copyright © 2017年 邹前立. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "StudentManage.h"

@interface ViewController () {
    StudentManage *studentManage;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *score;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [StudentManage testStrcat];
    return;
    
}


/**
 写入数据到数据库
 
 @param stu 学生
 */
- (IBAction) writeToDB:(Student *) stu {
    
    // 获取界面数据
//    NSString *name = _name.text;
//    int age = _age.text.intValue;
//    int gender = _gender.text.intValue;
//    double score = _gender.text.doubleValue;
    
    NSString *name   = _name.text;
    NSString *age    = _age.text;
    NSString *gender = _gender.text;
    NSString *score  = _score.text;
    // 打开数据库，插入数据
    if ([StudentManage openDB]) {
        [StudentManage insertData:name age:age gender:gender score:score];
//        [StudentManage insertData];
    }
}
- (IBAction)readFromDB:(UIButton *)sender {
}
- (IBAction)createDB:(UIButton *)sender {
    [StudentManage openDB];
}
- (IBAction)createTable:(UIButton *)sender {
    [StudentManage createTable];
}


@end
