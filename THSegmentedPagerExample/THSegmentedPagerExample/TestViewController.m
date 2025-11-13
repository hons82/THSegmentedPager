//
//  TestViewController.m
//  ThSegmentedPagerExample
//
//  Created by 胡金友 on 2017/8/24.
//  Copyright © 2017年 胡金友. All rights reserved.
//

#import "TestViewController.h"
#import "PagerViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.pageControl.backgroundColor = [UIColor blackColor];
    
    PagerViewController *p1 = [[PagerViewController alloc] init];
    p1.title = @"P1";
    PagerViewController *p2 = [[PagerViewController alloc] initWithContentEdgeInsets:UIEdgeInsetsMake(20, 30, 40, 50)];
    p2.view.backgroundColor = [UIColor redColor];
    p2.title = @"P2";
    PagerViewController *p3 = [[PagerViewController alloc] init];
    p3.title = @"P3";
    PagerViewController *p4 = [[PagerViewController alloc] init];
    p4.title = @"P4";
    
    [self setPages:@[p1, p2, p3, p4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
