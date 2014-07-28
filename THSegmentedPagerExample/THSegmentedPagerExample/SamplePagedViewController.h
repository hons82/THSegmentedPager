//
//  SamplePagedViewController.h
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THSegmentedPageViewControllerDelegate.h"

@interface SamplePagedViewController : UIViewController<THSegmentedPageViewControllerDelegate>

@property(nonatomic,strong)NSString *viewTitle;

@end
