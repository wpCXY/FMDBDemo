//
//  ViewController.m
//  FMDBDemo
//
//  Created by 王鹏 on 2017/3/1.
//  Copyright © 2017年 王鹏. All rights reserved.
//

#import "ViewController.h"
#import "WPPersonDB.h"

@interface ViewController ()
@property (nonatomic, strong) WPPersonDB *personDB;


@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;
@property (weak, nonatomic) IBOutlet UITextField *personIDTF;
@property (weak, nonatomic) IBOutlet UITextField *queryNameTf;
@property (weak, nonatomic) IBOutlet UITextField *queryAgeTF;
@property (weak, nonatomic) IBOutlet UITextField *queryPersonIDTF;
@property (weak, nonatomic) IBOutlet UITextView *logInfoTV;
@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self personDB];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handler
- (IBAction)insertButtonDidClick:(id)sender {
    WPPersonTableModel *person = [[WPPersonTableModel alloc] init];
    person.name     = _nameTF.text;
    person.age      = _ageTF.text;
    person.personID = _personIDTF.text;
    person.weight   = _weightTF.text;
    person.height   = _heightTF.text;
    if ([self.personDB insertPerson:person]) {
        _nameTF.text     = @"";
        _ageTF.text      = @"";
        _personIDTF.text = @"";
        _weightTF.text   = @"";
        _heightTF.text   = @"";
        _logInfoTV.text = [NSString stringWithFormat:@"%@ \n  插入数据成功！！ \n ",_logInfoTV.text];

    }
}
- (IBAction)queryButtonDidClick:(id)sender {
    if (_queryAgeTF.text.length) {
        id res = [_personDB queryPersonWithAge:_queryAgeTF.text];
        [self logInfoWith:res queryType:@"QueryWithAge"];
    }
    if (_queryNameTf.text.length) {
        id res = [_personDB queryPersonWithName:_queryNameTf.text];
        [self logInfoWith:res queryType:@"QueryWithName"];

    }
    if (_queryPersonIDTF.text.length) {
        id res = [_personDB queryPersonWithPersonID:_queryPersonIDTF.text];
        [self logInfoWith:res queryType:@"QueryWithPersonID"];

    }
    _queryPersonIDTF.text = @"";
    _queryNameTf.text = @"";
    _queryAgeTF.text = @"";
    
}
- (void)logInfoWith:(id)logInfo queryType:(NSString *)queryType {
    NSString *text = _logInfoTV.text;
    NSString *newText = [NSString stringWithFormat:@"%@ \n  %@  \n %@  \n",text,queryType,logInfo];
    _logInfoTV.text = newText;
}
#pragma mark - Getter
- (WPPersonDB *)personDB {
    if (!_personDB) {
        _personDB = [WPPersonDB shareDefault];
    }
    return _personDB;
}


@end
