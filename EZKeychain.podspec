#
# Be sure to run `pod lib lint EZKeychain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EZKeychain'
  s.version          = '0.2.0'
  s.summary          = 'Lightweight Keychain API wrapper'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Lightweight Keychain API wrapper. Yes this just another one :)
  You may wanna check this cool Keychain wrapper https://github.com/evgenyneu/keychain-swift'

  s.homepage         = 'https://github.com/PattoMotto/EZKeychain'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'PattoMotto'
  s.source           = { :git => 'https://github.com/PattoMotto/EZKeychain.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/PattoMotto'

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.source_files = 'EZKeychain/Classes/**/*'

  # s.resource_bundles = {
  #   'EZKeychain' => ['EZKeychain/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
