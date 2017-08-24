//
//  BaseTableViewController.m
//  ThSegmentedPagerExample
//
//  Created by 胡金友 on 2017/8/24.
//  Copyright © 2017年 胡金友. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = title;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arc4random_uniform(10) + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arc4random_uniform(20) + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusefulIdentifier = @"reusefulIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusefulIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusefulIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld - %ld", indexPath.section, indexPath.row];
    
    return cell;
}


@end
