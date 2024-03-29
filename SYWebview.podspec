#
# Be sure to run `pod lib lint SYWebview.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SYWebview'
  s.version          = '0.1.5'
  s.summary          = '基于wkwebview的h5和native交互组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  基于wkwebview的h5和native交互组件,可以很方便的处理各种回调事件
                       DESC

  s.homepage         = 'https://github.com/yxf0103/SYWebview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yxf0103' => 'yxfeng0103@hotmail.com' }
  s.source           = { :git => 'https://github.com/yxf0103/SYWebview.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SYWebview/Classes/**/*'
  
   s.resource_bundles = {
     'SYWebview' => ['SYWebview/Assets/**/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
