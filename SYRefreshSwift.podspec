Pod::Spec.new do |s|

s.name         = "SYRefreshSwift"
s.version      = "1.0.0"
s.summary      = "SY Refresh Swift，下拉刷新组件，使用简单，几行代码即可实现下拉刷新，任何UIScrollView及子类可使用。"
s.description  = <<-DESC
SY Refresh Swift，简单易用的下拉刷新组件，低耦合，使用简单，几行代码即可实现下拉刷新，任何UIScrollView及子类可使用。
DESC

s.homepage     = "https://github.com/reesun1130/SYRefreshSwift"

s.license      = { :type => 'MIT', :file => 'LICENSE_SY.txt' }
s.author       = { "reesun" => "ree.sun.cn@hotmail.com" }

s.source       = { :git => "https://github.com/reesun1130/SYRefreshSwift.git", :tag => s.version }
s.source_files = "SYRefreshSwift/*.swift"
s.resources = "SYRefreshSwift/*.{png,bundle}"

s.platform     = :ios, "8.0"
s.requires_arc = true

end
