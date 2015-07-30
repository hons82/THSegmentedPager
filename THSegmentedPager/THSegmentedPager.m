//
//  THSegmentedPager.m
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THSegmentedPager.h"
#import "THSegmentedPageViewControllerDelegate.h"

@interface THSegmentedPager () <UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat lastPosition;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,assign) NSUInteger nextIndex;
@end

@implementation THSegmentedPager

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize shouldBounce = _shouldBounce;

- (NSMutableArray *)pages {
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Init PageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    self.pageControl.backgroundColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1];
    self.pageControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]};
    self.pageControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1];
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.pageControl.verticalDividerEnabled = YES;
    self.pageControl.verticalDividerColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    
    // Obtain the ScrollViewDelegate
    self.shouldBounce = YES;
    for (UIView *view in self.pageViewController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.pages count]>0) {
        [self setSelectedPageIndex:[self.pageControl selectedSegmentIndex] animated:animated];
    }
    [self updateTitleLabels];
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupPagesFromStoryboardWithIdentifiers:(NSArray *)identifiers {
    if (self.storyboard) {
        for (NSString *identifier in identifiers) {
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            if (viewController) {
                [self.pages addObject:viewController];
            }
        }
    }
}

- (void)updateTitleLabels {
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels {
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        self.pageControl.alpha = hidden ? 0.0f : 1.0f;
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController {
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    self.nextIndex = [self.pages indexOfObject:[pendingViewControllers firstObject]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        // DIRTY FIX
        if (self.nextIndex != [self.pages indexOfObject:[previousViewControllers firstObject]]) {
            self.currentIndex = [self.pages indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
            [self.pageControl setSelectedSegmentIndex:self.currentIndex animated:YES];
        }
    }
    self.nextIndex = self.currentIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /* The iOS page view controller API is broken.  It lies to us and tells us that the currently presented view hasn't changed, but under the hood, it starts giving the contentOffset relative to the next view.  The only way to detect this brain damage is to notice that the content offset is discontinuous, and pretend that the page changed.
     */
    if (self.nextIndex > self.currentIndex) {
        /* Scrolling forwards */
        if (scrollView.contentOffset.x < (self.lastPosition - (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pageControl setSelectedSegmentIndex:self.currentIndex];
        }
    } else {
        /* Scrolling backwards */
        if (scrollView.contentOffset.x > (self.lastPosition + (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pageControl setSelectedSegmentIndex:self.currentIndex];
        }
    }
    
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        CGRect scrollBounds = scrollView.bounds;
        if (scrollView.contentOffset.x <= minXOffset) {
            scrollView.contentOffset = CGPointMake(minXOffset, 0);
            // scrollBounds.origin = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            scrollView.contentOffset = CGPointMake(maxXOffset, 0);
            // scrollBounds.origin = CGPointMake(maxXOffset, 0);
        }
        [scrollView setBounds:scrollBounds];
    }
    self.lastPosition = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        if (scrollView.contentOffset.x <= minXOffset) {
            *targetContentOffset = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            *targetContentOffset = CGPointMake(maxXOffset, 0);
        }
    }
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender {
    // Update NextIndex
    self.nextIndex = [self.pageControl selectedSegmentIndex];
    UIPageViewControllerNavigationDirection direction = self.nextIndex > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
}

@end
