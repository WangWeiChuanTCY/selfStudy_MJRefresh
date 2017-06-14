//
//  ViewController.m
//  selfStudy_MJRefreshi
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"上拉刷新，下拉加载";
    
    dataArray = [NSMutableArray array];
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UITableView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    // 下拉刷新
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self MJ_Heater];
        
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self MJ_Footer];
        
    }];
    // 默认先隐藏footer
    [_tableView.mj_header beginRefreshing];

}

static const CGFloat MJDuration = 2.0;

//上拉刷新
- (void)MJ_Heater{
    
    for (int i =0; i<5; i++) {
        
        [dataArray insertObject:@"hahaha" atIndex:0];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        
        // 结束刷新
        [_tableView.mj_header endRefreshing];
    });
    
}

//下拉加载
- (void)MJ_Footer{
    
    // 增加5条假数据
    for (int i = 0; i<5; i++) {
        [dataArray addObject:@"hhh"];
    }
    
    // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        
        // 结束刷新
        [_tableView.mj_footer endRefreshing];
        
        NSLog(@"%lu",(unsigned long)[dataArray count]);
        
        if ([dataArray count]>3*5+5) {
            
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5+[dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    if (cell) {
        
        //        cell.backgroundColor = MJRandomColor;
        cell.backgroundColor = [UIColor greenColor];
        
    }
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
