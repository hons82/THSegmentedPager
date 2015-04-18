//
//  AppDelegate.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "AppDelegate.h"
#import "THSegmentedPager.h"
#import "SamplePagedViewController.h"

//#define LOAD_WITH_IDENTIFIERS = 0;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    THSegmentedPager *pager = (THSegmentedPager *)((UINavigationController *)self.window.rootViewController).topViewController;
#ifndef LOAD_WITH_IDENTIFIERS
    NSMutableArray *pages = [NSMutableArray new];
    for (int i = 1; i < 4; i++) {
        // Create a new view controller and pass suitable data.
        SamplePagedViewController *pagedViewController = [pager.storyboard instantiateViewControllerWithIdentifier:@"SamplePagedViewController"];
        [pagedViewController setViewTitle:[NSString stringWithFormat:@"Page %d",i]];
        [pagedViewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:pagedViewController];
    }
    [pager setPages:pages];
#else
    [pager setupPagesFromStoryboardWithIdentifiers:@[@"SamplePagedViewController",@"SamplePagedViewController",@"SamplePagedViewController"]];
#endif
    return YES;
}

@end
