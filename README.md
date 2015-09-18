THSegmentedPager  
===

[![Build Status](https://travis-ci.org/hons82/THSegmentedPager.png)](https://travis-ci.org/hons82/THSegmentedPager)
[![Pod Version](http://img.shields.io/cocoapods/v/THSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/THSegmentedPager/)
[![Pod Platform](http://img.shields.io/cocoapods/p/THSegmentedPager.svg?style=flat)](http://cocoadocs.org/docsets/THSegmentedPager/)
[![Pod License](http://img.shields.io/cocoapods/l/THSegmentedPager.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Coverage Status](https://coveralls.io/repos/hons82/THSegmentedPager/badge.svg)](https://coveralls.io/r/hons82/THSegmentedPager)

This control combines the great [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl) with a UIPageviewController that takes care of showing the right page when clicking on the HMSegmentedControl and updating the selection when the UIPageviewController scrolls.

# Screenshots

![iPhone Portrait](/Screenshots/Screenshot1.png?raw=true)
![iPhone Landscape](/Screenshots/Screenshot2.png?raw=true)

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
platform :ios, '7.0'
pod 'THSegmentedPager', '~> 1.1.3'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

Or copy the `THSegmentedPager/` directory from this repo into your project.

#### Dependencies

If you prefer the manual approach be aware that you'll need to import the dependencies which in this case are

- [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl)

This will cause some errors with imports not found correctly which you'll need to solve manually too

# Features

### V1.1.X

- [Pull Request](https://github.com/hons82/THSegmentedPager/pull/19) thx to [JaxGit](https://github.com/JaxGit)
- Fixed issue [#12](https://github.com/hons82/THSegmentedPager/issues/12)
- With this version we switch back to the original [HMSegmentedControl](https://github.com/HeshamMegid/HMSegmentedControl) and as he's dropping support for iOS6 we'll need to follow

### V1.0.X

- If it is used in a UINavigationController it will show the same Viewcontroller when it comes back
- [Pull Request](https://github.com/hons82/THSegmentedPager/pull/3) thx to [noelrocha](https://github.com/noelrocha)
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

###Contributors

[Victor Ilyukevich](https://github.com/yas375)
- Added automated Tests
- Added Travis CI and Coverall.io support

[JaxGit](https://github.com/JaxGit)

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).