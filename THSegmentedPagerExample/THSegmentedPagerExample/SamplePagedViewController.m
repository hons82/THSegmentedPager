//
//  SamplePagedViewController.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SamplePagedViewController.h"

@interface SamplePagedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sampleLabel;

@end

@implementation SamplePagedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.sampleLabel setText:self.viewControllerTitle];
}

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
