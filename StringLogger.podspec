#
# Be sure to run `pod lib lint StringLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StringLogger'
  s.version          = '0.7.0'
  s.summary          = 'Provides Logging with extensions for String'
  s.swift_versions   = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Developer can logs message with String Extension
option: date, file, line, function
level: fatal, critical, error, warning, notice, debug, trace
DESC

  s.homepage         = 'https://github.com/2sem/StringLogger'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '2sem' => 'kofggm@gmail.com' }
  s.source           = { :git => 'https://github.com/2sem/StringLogger.git', :tag => s.version.to_s }
#  s.social_media_url = 'https://linkedin.com/in/gamehelper'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/Extensions/*.swift'
  
  # s.resource_bundles = {
  #   'StringLogger' => ['StringLogger/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
