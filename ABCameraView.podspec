#
# Be sure to run `pod lib lint ABCameraView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ABCameraView'
  s.version          = '0.1.0'
  s.summary          = 'Simple and customizeable camera view for capturing a photo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This is a fullscreen camera view controller that allows you to customize what buttons you want to include and the location of them.'

  s.homepage         = 'https://github.com/MobileDevelopersOfBerkeley/ABCameraView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christine Munar' => 'chrismunar@berkeley.edu' }
  s.source           = { :git => 'https://github.com/MobileDevelopersOfBerkeley/ABCameraView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ABCameraView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ABCameraView' => ['ABCameraView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
