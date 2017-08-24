//
//  ViewController.m
//  ThSegmentedPagerExample
//
//  Created by 胡金友 on 2017/8/24.
//  Copyright © 2017年 胡金友. All rights reserved.
//

#import "ViewController.h"
#import "PagerViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)example01:(id)sender {
    [self.navigationController pushViewController:[[PagerViewController alloc] init] animated:YES];
}
- (IBAction)example02:(id)sender {
    [self.navigationController pushViewController:[[TestViewController alloc] init] animated:YES];
}
- (IBAction)example03:(id)sender {
    THSegmentedPager *pager = [[THSegmentedPager alloc] init];
    pager.needPagerAnimateWhenSegmentSelectionChanged = YES;
    [pager setupPagesFromStoryboardWithIdentifier:@"Main" pageIdentifiers:@[@"T01", @"T02", @"T03"]];
    [self.navigationController pushViewController:pager animated:YES];
    
    pager.navigationController.navigationBar.translucent = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[[TestViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
