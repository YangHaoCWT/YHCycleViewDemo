Pod::Spec.new do |s|
s.name         = 'CycleView'
s.version      = '1.0.1'
s.summary      = 'Swift无线轮播'
s.homepage     = 'https://github.com/YangHaoLoad/YHCycleViewDemo'
s.license      = 'MIT'
s.authors      = {'MrYangHao' => '1065671784@qq.com'}
s.platform     = :ios, '10.0'
s.source       = {:git => 'https://github.com/YangHaoLoad/YHCycleViewDemo.git', :tag => s.version}
s.source_files = 'YHCycleView/**/*'
s.requires_arc = true
end
