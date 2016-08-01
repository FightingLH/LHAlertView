//
//  ThinTableViewDataSource.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/28.
//  Copyright © 2016年 lh. All rights reserved.
//

#import "ThinTableViewDataSource.h"
#import "ThinTableViewCell.h"
#import "ThinModel.h"

@interface ThinTableViewDataSource()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) cellBlock cellSelectBlock;
@property (nonatomic,copy) NSString *identifierString;
@end
@implementation ThinTableViewDataSource
-(instancetype)initWithIdentifier:(NSString *)identifier withItems:(NSArray *)dataArray withBlock:(cellBlock)blcok{
    if (self == [super init]) {
        _dealArray = dataArray;
        _cellSelectBlock = blcok;
        _identifierString = identifier;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dealArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifierString];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ThinTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifierString];
        cell.backgroundColor = [UIColor whiteColor];
    }
    ThinModel *model = _dealArray[[indexPath row]];
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThinModel *model = _dealArray[[indexPath row]];
    self.cellSelectBlock(model.title);
}
@end
