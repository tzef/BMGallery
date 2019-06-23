#
# Be sure to run `pod lib lint BMGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BMGallery'
  s.version          = '0.1.0'
  s.summary          = 'a transition animation helper for album layout'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Supply a way to simply use, create a transition animation like TikTok, apply to a situation that a UICollectionCell push into a detail UIViewController.
                       DESC

  s.homepage         = 'https://github.com/tzef/BMGallery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LEE ZHE YU' => 'tzef8220@gmail.com' }
  s.source           = { :git => 'https://github.com/tzef/BMGallery/blob/master/demo.gif', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/yuzhe/'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BMGallery/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BMGallery' => ['BMGallery/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
