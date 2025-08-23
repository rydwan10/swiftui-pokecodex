# Uncomment the next line to define a global platform for your project
platform :ios, '18.0'

target 'PokeCodex' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PokeCodex
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'PagerTabStripView', '~> 4.0'
  pod 'CouchbaseLite-Swift', '3.2.4'


  target 'PokeCodexTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PokeCodexUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
            end
        end
    end
end
