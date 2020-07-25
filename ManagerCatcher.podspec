#
#  Be sure to run `pod spec lint ManagerCatcher.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ManagerCatcher"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you perform calculation.
                   DESC

  spec.homepage     = "https://github.com/ifleon/ManagerCatcher"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "leonfr" => "leonfrcol@gmail.com" }

  spec.ios.deployment_target = "13.5"
  spec.swift_version = "5.0"

  spec.source        = { :git => "https://github.com/ifleon/ManagerCatcher.git", :tag => "#{spec.version}" }
  spec.source_files  = "ManagerCatcher/**/*.{h,m,swift}"

end
