//
//  THSegmentedPageViewControllerDelegate.h
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THSegmentedPager;

@protocol THSegmentedPageViewControllerDelegate <NSObject>

@optional


/**
 当前类需要实现的方法，用于返回当前选择的页面索引
 
 @param controller self
 @param index 页面索引
 */
- (void)pageViewController:(THSegmentedPager *)controller changeToSelectedIndex:(NSUInteger)index;

- (NSString *)viewControllerTitle;

@end
