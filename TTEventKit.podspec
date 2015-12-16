Pod::Spec.new do |s|

  s.name         = "TTEventKit"
  s.version      = "0.0.2"
  s.summary      = "a very manageable EventKit library."

  s.homepage     = "https://github.com/tattn/TTEventKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Tatsuya Tanaka" => "tatsuyars@yahoo.co.jp" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tattn/TTEventKit.git", :tag => "v#{s.version}" }
  s.source_files  = "TTEventKit/TTEventKit/*.{swift,h}"
  s.exclude_files = "Classes/Exclude"
  s.public_header_files = "TTEventKit/TTEventKit/TTEventKit.h"

  s.frameworks   = 'UIKit', 'Foundation', 'QuartzCore'
  s.requires_arc = true
end
