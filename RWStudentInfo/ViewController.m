//
//  ViewController.m
//  RWStudentInfo
//
//  Created by 邹前立 on 2017/5/13.
//  Copyright © 2017年 邹前立. All rights reserved.
//

/**
 打开模拟器，若点击创建数据库，在navicat工具中操作的时候要重新连接数据库：编辑连接-确认路径，测试连接。控制台无影响
 */

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
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *selectByName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *deleteByName;
@property (weak, nonatomic) IBOutlet UILabel *namesLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *namesScrollView;

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
    Student *stu = [[Student alloc] init];
        stu = [StudentManage getOneStuWithName:_selectByName.text];
    if (!stu) {
        return;
    }
    _name.text = [NSString stringWithString:stu.name];
    _age.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:stu.age]];
    _gender.text = [NSString stringWithFormat:@"%@",stu.gender==0?@"男":(stu.gender==1?@"女":@"未知")];
    _score.text = [NSString stringWithFormat:@"%.2f",stu.score];
}
- (IBAction)createDB:(UIButton *)sender {
    [StudentManage openDB];
}
- (IBAction)createTable:(UIButton *)sender {
    [StudentManage createTable];
}
- (IBAction)deleteOneData:(UIButton *)sender {
    [StudentManage deleteOneData:_deleteByName.text];
}
- (IBAction)deleteAllData:(id)sender {
    [StudentManage deleteAllData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)getAllStudentsName:(UIButton *)sender {
    NSArray *studentsName = [NSArray array];
    studentsName = [StudentManage getAllStuName];
    NSMutableString *names = [[NSMutableString alloc] init];
    for (NSString *name in studentsName) {
        [names appendString:@"学生姓名:"];
        [names appendString:name];
        [names appendString:@" \n"];
        NSLog(@"stu name:%@",name);
    }
    NSLog(@"stu names:%@",names);
//    _namesLabel.text = names;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30*studentsName.count)];
    _namesScrollView.contentSize = CGSizeMake(300, 30*studentsName.count);
    _namesScrollView.showsVerticalScrollIndicator = YES;
    _namesScrollView.backgroundColor = [UIColor whiteColor];
    
    label.text = names;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor greenColor];
    [_namesScrollView addSubview:label];
    
}

@end
