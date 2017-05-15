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
    NSMutableString *names;
    NSMutableArray *studentsName;
    UILabel *namesLabel;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *score;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *selectByName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *deleteByName;
@property (weak, nonatomic) IBOutlet UIScrollView *namesScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    studentsName = [NSMutableArray array];
    names = [[NSMutableString alloc] init];
    [StudentManage testStrcat];
    return;
    
}
/**
 写入数据到数据库
 
 @param stu 学生
 */
- (IBAction) writeToDB:(Student *) stu {
    // 获取界面数据
    NSString *name   = _name.text;
    NSString *age    = _age.text;
    NSString *gender = _gender.text;
    NSString *score  = _score.text;
    // 打开数据库，插入数据
    if ([StudentManage openDB]) {
        [namesLabel removeFromSuperview];
        NSRange range = NSMakeRange(0, names.length);
        [names replaceCharactersInRange:range withString:@""]; // 清空names
        stu = [StudentManage insertData:name age:age gender:gender score:score];
        if (stu == nil) {
            NSLog(@"stu is nil.");
            UIAlertController *tip = [UIAlertController alertControllerWithTitle:@"注意" message:@"stu is nil" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消按钮");
            }];
            [tip addAction:cancel];
            [self presentViewController:tip animated:YES completion:nil];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [studentsName addObject:stu.name]; // 添加数据
            for (NSString *name in studentsName) {
                NSLog(@"%@",name);
                [names appendString:@"学生姓名:"];
                [names appendString:name];
                [names appendString:@"\n"];
            }
            UIFont *font = [UIFont systemFontOfSize:10];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
            CGSize namesWH = [names sizeWithAttributes:dict];
            namesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, namesWH.height*1.7)];
            _namesScrollView.contentSize = CGSizeMake(300, namesWH.height*1.7+20);
            _namesScrollView.showsVerticalScrollIndicator = YES;
            _namesScrollView.backgroundColor = [UIColor whiteColor];
            
            namesLabel.text = names;
            namesLabel.numberOfLines = 0;
            namesLabel.backgroundColor = [UIColor greenColor];
            [_namesScrollView addSubview:namesLabel];

        });
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
    [namesLabel removeFromSuperview];
    [StudentManage deleteOneData:_deleteByName.text];
    dispatch_async(dispatch_get_main_queue(), ^{
        [studentsName removeObject:_deleteByName.text];
        for (NSString *name in studentsName) {
            [names appendString:@"学生姓名:"];
            [names appendString:name];
            [names appendString:@"\n"];
        }
        namesLabel.text = names;
        [_namesScrollView addSubview:namesLabel];
    });
}
- (IBAction)deleteAllData:(id)sender {
    NSRange range = NSMakeRange(0, names.length);
    [names replaceCharactersInRange:range withString:@""]; // 清空names
    namesLabel.text = names;
    [studentsName removeAllObjects]; // 清空数据
    [StudentManage deleteAllData]; // 清空数据库
    dispatch_async(dispatch_get_main_queue(), ^{
        [namesLabel removeFromSuperview]; // 清除控件
    });
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)getAllStudentsName:(UIButton *)sender {
    NSRange range = NSMakeRange(0, names.length);
    [names replaceCharactersInRange:range withString:@""]; // 清空names
    [namesLabel removeFromSuperview];
    studentsName = [StudentManage getAllStuName];
    if (studentsName.count <= 0) {
        NSLog(@"请先写入数据");
        UIAlertController *tip = [UIAlertController alertControllerWithTitle:@"注意" message:@"请先在数据库中写入数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消按钮");
        }];
        [tip addAction:cancel];
        [self presentViewController:tip animated:YES completion:nil];
        return;
    }
    int i=0;
    for (NSString *name in studentsName) {
        NSString *str = [NSString stringWithFormat:@"学生姓名%d:",i++];
        [names appendString:str];
        [names appendString:name];
        [names appendString:@"\n"];
    }
    NSLog(@"stu names:%@",names);
    
    UIFont *font = [UIFont systemFontOfSize:10];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize namesWH = [names sizeWithAttributes:dict];
    namesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, namesWH.height*1.7)];
    _namesScrollView.contentSize = CGSizeMake(300, namesWH.height*1.7+20);
    _namesScrollView.showsVerticalScrollIndicator = YES;
    _namesScrollView.backgroundColor = [UIColor whiteColor];
    
    namesLabel.text = names;
    namesLabel.numberOfLines = 0;
    namesLabel.backgroundColor = [UIColor greenColor];
    [_namesScrollView addSubview:namesLabel];
    
}

@end
