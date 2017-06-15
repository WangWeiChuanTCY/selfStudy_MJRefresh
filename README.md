# selfStudy_MJRefresh
// 下拉刷新
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self MJ_Heater];
        
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    // 上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self MJ_Footer];
        
    }];
    // 默认先隐藏footer
    [_tableView.mj_header beginRefreshing];


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
