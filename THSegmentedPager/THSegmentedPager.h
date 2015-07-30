//
//  THSegmentedPager.h
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface THSegmentedPager : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (strong, nonatomic)NSMutableArray *pages;
@property (assign, nonatomic, getter=isShouldBounce)BOOL shouldBounce;
/*! Instead of setting the pages manually you can give to the controller an array of identifiers which will be loaded from the storyboard at runtime
 * \param identifiers Array of identifiers to load
 */
- (void)setupPagesFromStoryboardWithIdentifiers:(NSArray *)identifiers;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;


/*! Get the selected viewcontroller
 * \returns The actual selected viewcontroller
 */
- (UIViewController *)selectedController;

/*! The control will ask from every viewcontroller an updated title string
 */
- (void)updateTitleLabels;

@end
