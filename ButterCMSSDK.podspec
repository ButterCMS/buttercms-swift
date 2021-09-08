Pod::Spec.new do |s|
  s.name             = 'ButterCMSSDK'
  s.version          = '1.0.3'
  s.summary          = 'Swift client for ButterCMS'

  s.homepage         = 'https://buttercms.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Martin Srb' => 'martin.srb@applifting.cz' }
  s.source           = { :git => 'https://git.applifting.cz/martin.srb/buttercms-swift.git', :tag => '1.0.3' }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/ButterCMSSDK/**/*'
end
