Pod::Spec.new do |s|

s.name         = "GnURLManage"
s.version      = "0.0.1"
s.summary      = "swift网络请求 不好用的"

s.homepage     = "https://github.com/1091673851/GnURLManage"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "Gn_chen" => "1091673851@qq.com" }

s.platform     = :ios, "9.0"

s.source       = { :git => "https://github.com/1091673851/GnURLManage.git", :tag => "#{s.version}" }

s.requires_arc = true

s.dependency 'Alamofire', '~> 4.7.3'

s.dependency 'HandyJSON', '~> 4.2.0-beta1'

s.dependency 'SVProgressHUD', '~> 2.2.5'

s.frameworks = 'UIKit'

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
