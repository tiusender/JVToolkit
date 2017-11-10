#
# Be sure to run `pod lib lint JVToolkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JVToolkit'
  s.version          = '0.1.1'
  s.summary          = 'A short description of JVToolkit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tiusender/JVToolkit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tiusender' => 'jorge@tiusender.es' }
  s.source           = { :git => 'https://github.com/tiusender/JVToolkit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JVToolkit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JVToolkit' => ['JVToolkit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

    s.dependency 'SwiftyUserDefaults'
    s.dependency 'ReachabilitySwift'
    s.dependency 'AlamofireImage'
    s.dependency 'SwiftyJSON'
    s.dependency 'AEXML'
    s.dependency 'LGRefreshView'
    s.dependency 'PKHUD'

end
