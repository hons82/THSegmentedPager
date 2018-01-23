//
//  THSegmentedPager.m
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THSegmentedPager.h"
#import "THSegmentedPageViewControllerDelegate.h"
#import <objc/runtime.h>

@interface THSegmentedPager () <UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat lastPosition;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,assign) NSUInteger nextIndex;
@property (nonatomic,assign) BOOL userDraggingStartedTransitionInProgress;

@property (strong, nonatomic) HMSegmentedControl *pri_segmentControl;
@property (strong, nonatomic) UIPageViewController *pri_pageViewController;
@property (strong, nonatomic) UIView *pri_contentContainer;
@property (strong, nonatomic) NSMutableArray *pri_pages;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation THSegmentedPager

@synthesize pri_pages = _pri_pages;

- (instancetype)initWithContentEdgeInsets:(UIEdgeInsets)edgeInsets {
    if (self = [super init]) {
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.pri_pageViewController];
    [self.pri_contentContainer addSubview:self.pri_pageViewController.view];
    [self.view addSubview:self.pri_contentContainer];

    [self.view addSubview:self.pri_segmentControl];
    
    // Obtain the ScrollViewDelegate
    self.shouldBounce = YES;
    
    // 遍历获取navigation的侧滑手势
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;
    
    if (self.navigationController && self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    for (UIView *view in self.pri_pageViewController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            if (screenEdgePanGestureRecognizer) {
                // 当时侧滑返回的时候，禁掉scrollview的滑动响应
                [((UIScrollView *)view).panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.pri_pages count]>0) {
        [self setSelectedPageIndex:[self.pri_segmentControl selectedSegmentIndex] animated:animated];
    }
    [self updateTitleLabels];
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupPagesFromStoryboardWithPageIdentifiers:(NSArray *)pageIdentifiers {
    [self setupPagesFromStoryboard:self.storyboard pageIdentifiers:pageIdentifiers];
}

- (void)setupPagesFromStoryboardWithIdentifier:(NSString *)storybardIdentifier pageIdentifiers:(NSArray *)pageIdentifiers {
    if (storybardIdentifier) {
        [self setupPagesFromStoryboard:[UIStoryboard storyboardWithName:storybardIdentifier bundle:nil] pageIdentifiers:pageIdentifiers];
    }
}

- (void)setupPagesFromStoryboard:(UIStoryboard *)storyboard pageIdentifiers:(NSArray *)pageIdentifiers {
    if (storyboard) {
        for (NSString *identifier in pageIdentifiers) {
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
            if (viewController) {
                viewController.segmentedPager = self;
                [self.pri_pages addObject:viewController];
            }
        }
    }
}

- (void)updateTitleLabels {
    [self.pri_segmentControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels {
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pri_pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated {
    
    NSTimeInterval duration = (animated ? 0.25f : 0.0f);
    
    if (hidden && !self.pri_segmentControl.hidden) {
        [UIView animateWithDuration:duration animations:^{
            self.pri_segmentControl.alpha = 0.0f;
            self.pri_contentContainer.frame = CGRectUnion(self.pri_contentContainer.frame, self.pri_segmentControl.frame);
        } completion:^(BOOL finished) {
            self.pri_segmentControl.hidden = YES;
        }];
    } else if (!hidden && self.pri_segmentControl.hidden) {
        self.pri_segmentControl.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            CGRect remainder, slice;
            CGRectDivide(self.pri_contentContainer.frame, &slice, &remainder, CGRectGetHeight(self.pri_segmentControl.frame), CGRectMinYEdge);
            self.pri_contentContainer.frame = remainder;
            self.pri_segmentControl.alpha = 1.0f;
        }];
    }
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pri_pages count]) {
        [self.pri_segmentControl setSelectedSegmentIndex:index animated:YES];
        [self.pri_pageViewController setViewControllers:@[self.pri_pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pri_pages indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    return self.pri_pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pri_pages indexOfObject:viewController];
    if ((index == NSNotFound)||(index+1 >= [self.pri_pages count])) {
        return nil;
    }
    return self.pri_pages[++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    self.nextIndex = [self.pri_pages indexOfObject:[pendingViewControllers firstObject]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        // DIRTY FIX
        if (self.nextIndex != [self.pri_pages indexOfObject:[previousViewControllers firstObject]]) {
            self.currentIndex = [self.pri_pages indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
            [self.pri_segmentControl setSelectedSegmentIndex:self.currentIndex animated:YES];
        }
    }
    self.nextIndex = self.currentIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isTracking || scrollView.isDecelerating) {
        self.userDraggingStartedTransitionInProgress = YES;
    }
    /* The iOS page view controller API is broken.  It lies to us and tells us that the currently presented view hasn't changed, but under the hood, it starts giving the contentOffset relative to the next view.  The only way to detect this brain damage is to notice that the content offset is discontinuous, and pretend that the page changed.
     */
    if (self.nextIndex > self.currentIndex) {
        /* Scrolling forwards */
        if (scrollView.contentOffset.x < (self.lastPosition - (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pri_segmentControl setSelectedSegmentIndex:self.currentIndex];
        }
    } else {
        /* Scrolling backwards */
        if (scrollView.contentOffset.x > (self.lastPosition + (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pri_segmentControl setSelectedSegmentIndex:self.currentIndex];
        }
    }
    
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.pri_pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
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
    CGFloat maxXOffset = (([self.pri_pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        if (scrollView.contentOffset.x <= minXOffset) {
            *targetContentOffset = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            *targetContentOffset = CGPointMake(maxXOffset, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.userDraggingStartedTransitionInProgress = NO;
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender {
    
    // when user dragging initiated transition is still in progress, prevent pageControl from starting simultaneous transitions to avoid assertion failure and crash
    
    // failure type 1: Assertion failure in -[UIPageViewController queuingScrollView:didEndManualScroll:toRevealView:direction:animated:didFinish:didComplete:], /SourceCache/UIKit_Sim/UIKit-2935.137/UIPageViewController.m:1866
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'No view controller managing visible view
    
    // failure type 2: Assertion failure in -[_UIQueuingScrollView _enqueueCompletionState:], /SourceCache/UIKit_Sim/UIKit-2935.137/_UIQueuingScrollView.m:499
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Duplicate states in queue'
    
    if (!self.userDraggingStartedTransitionInProgress) {
        
        // Update NextIndex
        self.nextIndex = [self.pri_segmentControl selectedSegmentIndex];
        UIPageViewControllerNavigationDirection direction = self.nextIndex > [self.pri_pages indexOfObject:[self.pri_pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        if (!self.needPagerAnimateWhenSegmentSelectionChanged && self.pri_segmentControl.selectedSegmentIndex < self.pri_pages.count) {
            self.currentIndex = [self.pri_segmentControl selectedSegmentIndex];
        }
        
        __weak THSegmentedPager *blocksafeSelf = self;
        void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
            // ref: http://stackoverflow.com/questions/12939280/uipageviewcontroller-navigates-to-wrong-page-with-scroll-transition-style
            // workaround for UIPageViewController's bug to avoid transition to wrong page
            // (ex: after switching from p1 to p3 using pageControl, you can only swipe back from p3 to p1 instead of p2)
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pri_pageViewController setViewControllers:@[[blocksafeSelf selectedController]] direction:direction animated:NO completion:nil];
            });
        };
        
        [self.pri_pageViewController setViewControllers:@[[self selectedController]] direction:direction
                                           animated:self.needPagerAnimateWhenSegmentSelectionChanged completion:completionBlock];
    } else {
        [self.pri_segmentControl setSelectedSegmentIndex:self.currentIndex animated:NO];
        
        if (self.nextIndex == self.currentIndex) {
            self.userDraggingStartedTransitionInProgress = NO;
            [self setSelectedPageIndex:self.currentIndex animated:NO];
        }
    }
}

#pragma mark - getter

- (UIView *)pri_contentContainer
{
    if (!_pri_contentContainer) {
        _pri_contentContainer = [[UIView alloc] initWithFrame:CGRectMake(self.edgeInsets.left, CGRectGetMaxY(self.pri_segmentControl.frame), CGRectGetWidth(self.view.frame) - self.edgeInsets.left - self.edgeInsets.right, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.pri_segmentControl.frame) - self.edgeInsets.bottom)];
        _pri_contentContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pri_contentContainer.backgroundColor = [UIColor clearColor];
    }
    
    return _pri_contentContainer;
}

- (UIPageViewController *)pri_pageViewController
{
    if (!_pri_pageViewController) {
        _pri_pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pri_pageViewController.view.frame = self.pri_contentContainer.bounds;
        [_pri_pageViewController setDataSource:self];
        [_pri_pageViewController setDelegate:self];
        [_pri_pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    
    return _pri_pageViewController;
}

- (HMSegmentedControl *)pri_segmentControl
{
    if (!_pri_segmentControl) {
        _pri_segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(self.edgeInsets.left, self.edgeInsets.top, CGRectGetWidth(self.view.bounds) - self.edgeInsets.left - self.edgeInsets.right, 40)];
        _pri_segmentControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pri_segmentControl.backgroundColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1];
        _pri_segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]};
        _pri_segmentControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1];
        _pri_segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _pri_segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        _pri_segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _pri_segmentControl.verticalDividerEnabled = YES;
        _pri_segmentControl.verticalDividerColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        
        [_pri_segmentControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pri_segmentControl;
}

- (HMSegmentedControl *)pageControl
{
    return self.pri_segmentControl;
}

- (UIPageViewController *)pageViewController
{
    return self.pri_pageViewController;
}

- (UIView *)contentContainer
{
    return self.pri_contentContainer;
}

- (NSMutableArray *)pri_pages
{
    if (!_pri_pages) {
        _pri_pages = [[NSMutableArray alloc] init];
    }
    return _pri_pages;
}

- (NSArray *)pages
{
    return self.pri_pages;
}

- (void)setPages:(NSArray<UIViewController *> *)pages
{
    if (pages) {
        self.pri_pages = [pages mutableCopy];
        for (UIViewController *viewController in pages) {
            viewController.segmentedPager = self;
        }
    }
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight
{
    [self setPageControlHeight:pageControlHeight animated:NO];
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight animated:(BOOL)animated
{
    if (pageControlHeight > 0) {
        if (self.pageControl.hidden) {
            self.pageControl.frame = (CGRect){self.pageControl.frame.origin, (CGSize){self.pageControl.frame.size.width, pageControlHeight}};
        } else {
            NSTimeInterval duration = animated ? 0.25f : 0.0f;
            [UIView animateWithDuration:duration animations:^{
                
                CGRect pageControlFrame = self.pageControl.frame;
                CGRect contentContainerFrame = self.contentContainer.frame;
                
                CGFloat increaseHeight = pageControlHeight - CGRectGetHeight(pageControlFrame);
                
                pageControlFrame.size.height = pageControlHeight;
                
                contentContainerFrame.origin.y = CGRectGetMaxY(pageControlFrame);
                contentContainerFrame.size.height -= increaseHeight;
                
                self.pageControl.frame = pageControlFrame;
                self.contentContainer.frame = contentContainerFrame;
            }];
        }
    }
}

- (UIViewController *)selectedController {
    return self.pri_pages[[self.pri_segmentControl selectedSegmentIndex]];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    [self pageViewController:self changeToSelectedIndex:currentIndex];
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    _scrollEnable = scrollEnable;
    
    for (UIView *view in self.pri_pageViewController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).scrollEnabled = scrollEnable;
        }
    }
}

- (void)pageViewController:(THSegmentedPager *)controller changeToSelectedIndex:(NSUInteger)index {}

@end









@interface _THWeakContainer : NSObject

@property (weak, nonatomic) THSegmentedPager *segmentedPager;

@end

@implementation _THWeakContainer

@end

@interface UIViewController (_THSegmentedPager)

@property (retain, nonatomic) _THWeakContainer *weakContainer;

@end

@implementation UIViewController (THSegmentedPager)

- (void)setSegmentedPager:(THSegmentedPager *)segmentedPager {
    if ([segmentedPager isKindOfClass:[THSegmentedPager class]]) {
        self.weakContainer.segmentedPager = segmentedPager;
    }
}

- (THSegmentedPager *)segmentedPager {
    return self.weakContainer.segmentedPager;
}

- (void)setWeakContainer:(_THWeakContainer *)weakContainer {
    objc_setAssociatedObject(self, @selector(weakContainer), weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_THWeakContainer *)weakContainer {
    _THWeakContainer *weakContainer = objc_getAssociatedObject(self, @selector(weakContainer));
    if (!weakContainer) {
        weakContainer = [[_THWeakContainer alloc] init];
        self.weakContainer = weakContainer;
    }
    return weakContainer;
}

@end


