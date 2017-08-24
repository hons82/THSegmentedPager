//
//  BaseTableViewController.m
//  ThSegmentedPagerExample
//
//  Created by 胡金友 on 2017/8/24.
//  Copyright © 2017年 胡金友. All rights reserved.
//

#import "BaseTableViewController.h"
#import <THSegmentedPager/THSegmentedPager.h>

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.segmentedPager) {
        self.segmentedPager.title = self.title;
        if (self.segmentedPager.segmentedPager) {
            self.segmentedPager.segmentedPager.title = self.title;
        }
    }
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusefulIdentifier = @"reusefulIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusefulIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusefulIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] : [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    cell.textLabel.text = @[@"隐藏page control，需要动画",
                            @"显示page control，需要动画",
                            @"隐藏page control，不需要动画",
                            @"显示page control，不需要动画",
                            @"隐藏父pager的page control，需要动画",
                            @"显示父pager的page control，需要动画",
                            @"隐藏父pager的page control，不需要动画",
                            @"显示父pager的page control，不需要动画",
                            @"随机设置page control高度，需要动画",
                            @"随机设置page control高度，不需要动画",
                            @"随机设置父pager的page control高度，需要动画",
                            @"随机设置父pager的page control高度，不需要动画"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: [self hideSelfPageControl:YES animate:YES]; break;
        case 1: [self hideSelfPageControl:NO animate:YES];  break;
        case 2: [self hideSelfPageControl:YES animate:NO];  break;
        case 3: [self hideSelfPageControl:NO animate:NO];   break;
            
        case 4: [self hidePageControlOfSelfPageControl:YES animate:YES];    break;
        case 5: [self hidePageControlOfSelfPageControl:NO animate:YES];     break;
        case 6: [self hidePageControlOfSelfPageControl:YES animate:NO];     break;
        case 7: [self hidePageControlOfSelfPageControl:NO animate:NO];      break;
        
        case 8: [self randomPageControlHeightWithAnimated:YES];         break;
        case 9: [self randomPageControlHeightWithAnimated:NO];          break;
        case 10: [self randomSuperPageControlHeightWithAnimated:YES];   break;
        case 11: [self randomSuperPageControlHeightWithAnimated:NO];    break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)hideSelfPageControl:(BOOL)hide animate:(BOOL)animate
{
    if (self.segmentedPager) {
        [self.segmentedPager setPageControlHidden:hide animated:animate];
    }
}

- (void)hidePageControlOfSelfPageControl:(BOOL)hide animate:(BOOL)animate
{
    if (self.segmentedPager && self.segmentedPager.segmentedPager) {
        [self.segmentedPager.segmentedPager setPageControlHidden:hide animated:animate];
    }
}

- (void)randomPageControlHeightWithAnimated:(BOOL)animated
{
    if (self.segmentedPager) {
        [self.segmentedPager setPageControlHeight:arc4random_uniform(50) + 20 animated:animated];
    }
}

- (void)randomSuperPageControlHeightWithAnimated:(BOOL)animated
{
    if (self.segmentedPager && self.segmentedPager.segmentedPager) {
        [self.segmentedPager.segmentedPager setPageControlHeight:arc4random_uniform(50) + 20 animated:animated];
    }
}

@end
