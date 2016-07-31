//
//  ThinTableViewDataSource.h
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/28.
//  Copyright © 2016年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThinTableViewCell.h"

typedef void(^cellBlock)(id x);
@interface ThinTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
-(instancetype)initWithIdentifier:(NSString *)identifier withItems:(NSArray *)dataArray withBlock:(cellBlock)blcok;
@property (nonatomic,strong) NSArray *dealArray;//需要的数组
@end
