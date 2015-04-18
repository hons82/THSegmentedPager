desc 'Run tests'
task :test do
  system "xcodebuild \
    -workspace THSegmentedPagerExample/THSegmentedPagerExample.xcworkspace \
    -scheme THSegmentedPagerExample \
    -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
    test"
end

task :default => :test
