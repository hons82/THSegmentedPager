//
//  PagerViewController.m
//  ThSegmentedPagerExample
//
//  Created by 胡金友 on 2017/8/24.
//  Copyright © 2017年 胡金友. All rights reserved.
//

#import "PagerViewController.h"
#import "BaseTableViewController.h"

@interface PagerViewController ()

@end

@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.shouldBounce = NO;
    
    BaseTableViewController *b1 = [[BaseTableViewController alloc] initWithTitle:@"B1"];
    BaseTableViewController *b2 = [[BaseTableViewController alloc] initWithTitle:@"B2"];
    BaseTableViewController *b3 = [[BaseTableViewController alloc] initWithTitle:@"B3"];
    BaseTableViewController *b4 = [[BaseTableViewController alloc] initWithTitle:@"B4"];
    
    [self setPages:@[b1, b2, b3, b4]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPageControlHidden:YES animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setPageControlHidden:NO animated:YES];
        });
    });
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
