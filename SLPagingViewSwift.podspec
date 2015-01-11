Pod::Spec.new do |s|
  s.name         = "SLPagingViewSwift"
  s.version      = "0.0.1"
  s.summary      = "Navigation bar system allowing to do a Tinder like or Twitter like. SLPagingViewSwift is a Swift port of the Objective-C of SLPagingView"
  s.homepage     = "https://github.com/StefanLage/SLPagingViewSwift"
  s.license      = "MIT"
  s.author       = { "StefanLage" => "lagestfan@gmail.com" }
  s.source       = { :git => "https://github.com/StefanLage/SLPagingViewSwift.git", :tag => "0.0.1" }
  s.source_files = "SLPagingViewSwift/**/*.swift"
  s.requires_arc = true
  s.platform = :ios, "7.0"
  s.ios.deployment_target = "7.0"

end
