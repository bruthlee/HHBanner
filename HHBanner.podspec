Pod::Spec.new do |s|
  s.name         = "HHBanner"
  s.author             = { "bruthlee" => "bruthle@163.com" }
  s.version      = "0.1"
  s.summary      = "HHBanner is a view for picture to scroll unlimited."
  s.description  = <<-DESC
                        HHBanner is a view for picture to scroll and drag unlimited.
                    DESC

  s.homepage     = "https://github.com/bruthlee/HHBanner"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  
  s.source       = { :git => "https://github.com/bruthlee/HHBanner.git", :tag => s.version.to_s }
  s.source_files  = "HHBanner/HHBanner"
  s.public_header_files = "HHBanner/HHBanner/*.h"

  s.framework  = "UIKit"
  s.dependency "SDWebImage", "~> 4.3.3"  
  s.ios.deployment_target = '8.0'

end
