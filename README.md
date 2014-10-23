THSegmentedPager  
===

[![Pod Version](http://img.shields.io/cocoapods/v/THSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/THSegmentedPager/)
[![Pod Platform](http://img.shields.io/cocoapods/p/THSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/THSegmentedPager/)
[![Pod License](http://img.shields.io/cocoapods/l/THSegmentedPager.svg?style=flat)](http://opensource.org/licenses/MIT)

This control combines the great [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedContro) with a UIPageviewController that takes care of showing the right page when clicking on the HMSegmentedControl and updating the selection when the UIPageviewController scrolls.

# Screenshots

![iPhone Portrait](/Screenshots/Screenshot1.png?raw=true)
![iPhone Landscape](/Screenshots/Screenshot2.png?raw=true)

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
platform :ios, '6.1'
pod 'THSegmentedPager', '~> 0.0.4'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

Or copy the `THSegmentedPager/` directory from this repo into your project.

# Features

### V0.1.X

- If it is used in a UINavigationController it will show the same Viewcontroller when it comes back
- [Pull Request](https://github.com/hons82/THSegmentedPager/pull/3)

### V0.0.4

- The control is now able to allocate viewcontrollers from the actual storyboard by just knowing a list of identifiers

# Usage

This is a sample initialization taken from the ExampleProject.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    THSegmentedPager *pager = (THSegmentedPager *)self.window.rootViewController;
    NSMutableArray *pages = [NSMutableArray new];
    for (int i = 1; i < 4; i++) {
        // Create a new view controller and pass suitable data.
        SamplePagedViewController *pagedViewController = [pager.storyboard instantiateViewControllerWithIdentifier:@"SamplePagedViewController"];
        [pagedViewController setViewTitle:[NSString stringWithFormat:@"Page %d",i]];
        [pagedViewController.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:pagedViewController];
    }
    [pager setPages:pages];
    return YES;
}
```

#Contributions

...are really welcome. If you have an idea just fork the library change it and if its useful for others and not affecting the functionality of the library for other users I'll insert it

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).


