//
//  THSegmentedPager.h
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "THSegmentedPageViewControllerDelegate.h"

@interface THSegmentedPager : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate, THSegmentedPageViewControllerDelegate>

- (instancetype)initWithContentEdgeInsets:(UIEdgeInsets)edgeInsets;

@property (strong, nonatomic, readonly) HMSegmentedControl *pageControl;
@property (strong, nonatomic, readonly) UIPageViewController *pageViewController;
@property (strong, nonatomic, readonly) UIView *contentContainer;

@property (assign, nonatomic) BOOL needPagerAnimateWhenSegmentSelectionChanged; // default is no

@property (strong, nonatomic) NSArray <UIViewController *> *pages;
@property (assign, nonatomic) BOOL scrollEnable;
@property (assign, nonatomic) BOOL shouldBounce;

/*! Instead of setting the pages manually you can give to the controller an array of identifiers which will be loaded from the storyboard at runtime
 * \param pageIdentifiers Array of identifiers to load
 */
- (void)setupPagesFromStoryboardWithIdentifier:(NSString *)storybardIdentifier pageIdentifiers:(NSArray <NSString *> *)pageIdentifiers;
- (void)setupPagesFromStoryboard:(UIStoryboard *)storyboard pageIdentifiers:(NSArray <NSString *> *)pageIdentifiers;
- (void)setupPagesFromStoryboardWithPageIdentifiers:(NSArray <NSString *> *)pageIdentifiers;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)setPageControlHeight:(CGFloat)pageControlHeight;
- (void)setPageControlHeight:(CGFloat)pageControlHeight animated:(BOOL)animated;


/*! Get the selected viewcontroller
 * \returns The actual selected viewcontroller
 */
@property (strong, nonatomic, readonly) UIViewController *selectedController;

/*! The control will ask from every viewcontroller an updated title string
 */
- (void)updateTitleLabels;

@end

@interface UIViewController (THSegmentedPager)

@property (weak, nonatomic) THSegmentedPager *segmentedPager;

@end
