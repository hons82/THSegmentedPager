Pod::Spec.new do |s|
  s.name         	= "THSegmentedPager"
  s.version      	= "0.1.2"
  s.summary      	= "Simple plugin-sample using the HMSegmentedControl and a UIPageViewController to show Tabs"
  s.homepage     	= "https://github.com/hons82/THSegmentedPager"
  s.license      	= { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       	= { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       	= { :git => "https://github.com/hons82/THSegmentedPager.git", :tag => "v#{s.version}" }
  s.platform     	= :ios, '6.1'
  s.requires_arc 	= true
  s.source_files 	= 'THSegmentedPager/*.{h,m}'
  s.dependency 		'HMSegmentedControl@hons82', '~>1.4.2'
end