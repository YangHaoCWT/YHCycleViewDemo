Pod::Spec.new do |s|
s.name             = 'YHCycleView'
s.version          = '0.0.3'
s.swift_version = '4.2'
s.summary          = 'Swift无限轮播图'
s.homepage         = 'https://github.com/YangHaoLoad/YHCycleView'
s.license          = 'MIT'
s.author           = { 'YangHao' => '327737175@qq.com' }
s.source           = { :git => 'https://github.com/YangHaoLoad/YHCycleView.git', :tag => s.version }
s.ios.deployment_target = '9.0'
s.source_files = 'YHCycleView/*.swift'
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
