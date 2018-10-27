#
# Be sure to run `pod lib lint EAN13BarcodeGenerator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EAN13BarcodeGenerator'
  s.version          = '0.1.0'
  s.summary          = 'The easiest way to generate and show EAN13 barcode'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple and performance solution to generate EAN13 barcode for iOS applications
                       DESC

  s.homepage         = 'https://github.com/astrokin/EAN13BarcodeGenerator'
  s.screenshots      = 'https://dl.dropboxusercontent.com/s/2jhzwpm8nlz9iyj/Screen.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexey Strokin' => 'alex.strok@gmail.com' }
  s.source           = { :git => 'https://github.com/astrokin/EAN13BarcodeGenerator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'EAN13BarcodeGenerator/Classes/**/*'
  s.frameworks = 'UIKit'
  
  # s.resource_bundles = {
  #   'EAN13BarcodeGenerator' => ['EAN13BarcodeGenerator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
