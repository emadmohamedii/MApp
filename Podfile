source 'ssh://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

def mypods
  pod 'CustomDesignableX', '~> 0.1'
end

def genpods
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxCoreData'
  pod 'RxAlamofire'
  pod 'MBProgressHUD'
  
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
      end
    end
end


end


target 'MApp' do
  mypods
  genpods
end

target 'MAppTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'MAppUITests' do
  # Pods for testing
end
