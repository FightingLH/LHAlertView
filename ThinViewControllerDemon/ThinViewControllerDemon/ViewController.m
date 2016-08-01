//
//  ViewController.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/25.
//  Copyright © 2016年 lh. All rights reserved.
//
/**
 *添加了一个听云服务做测试使用
 */
#import "ViewController.h"
#import "ThinHttpManager.h"
#import "ThinModel.h"
#import "ThinTableViewDataSource.h"

@interface ViewController ()<UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) ThinTableViewDataSource *tableViewDatasource;
@end

@implementation ViewController
//处理的数据，我们应该放在model层
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    
    [self createTableView];
    
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"ThinTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchResultCell"];
    [self.view addSubview:self.tableView];
    self.tableViewDatasource = [[ThinTableViewDataSource alloc]initWithIdentifier:@"SearchResultCell" withItems:self.dataArray withBlock:^(NSString *tips) {
        NSLog(@"%@",tips);
    }];
    
}

#pragma mark -请求数据
-(void)requestData{
    
    NSDictionary *parameter = @{@"limit":@"20",@"offset":@"20"};
    ThinHttpManager *manager = [ThinHttpManager shareManager];
    manager.requestType = ThinRequestGet;
    [manager httpManagerRequestparameters:parameter finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            
            id detailData = data;
            if ([detailData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *detail = detailData[@"data"];
                NSArray *collection = detail[@"collections"];
                for (NSDictionary *dic in collection) {
                    ThinModel *model = [[ThinModel alloc]init];
                    model.bannerImage = dic[@"banner_image_url"];
                    model.subtitle = dic[@"subtitle"];
                    model.title = dic[@"title"];
                    [self.dataArray addObject:model];
                }
                
            }
            self.tableView.delegate = self.tableViewDatasource;
            self.tableView.dataSource = self.tableViewDatasource;
            self.tableViewDatasource.dealArray = self.dataArray;
            [self.tableView reloadData];
            
        }else{
            NSLog(@"下载出错");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
