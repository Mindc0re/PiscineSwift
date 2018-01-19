#
# Be sure to run `pod lib lint sgaudin2018.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sgaudin2018'
  s.version          = '1.0.0'
  s.summary          = 'Pod for the Swift Pool at 42 School'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod will be used in day08 and day09 of the Swift Pool at 42 School
                       DESC

  s.homepage         = 'https://github.com/mindc0re/sgaudin2018'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mindc0re' => 'sgaudin@student.42.fr' }
  s.source           = { :git => 'https://github.com/mindc0re/sgaudin2018.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'sgaudin2018/Classes/**/*'
  
  # s.resource_bundles = {
  #   'sgaudin2018' => ['sgaudin2018/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
