# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CustomLoginDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CustomLoginDemo

	pod 'Firebase/Analytics'
	pod 'Firebase/Auth'	
	pod 'Firebase/Core'
	pod 'Firebase/Firestore'
	pod 'LibTorch-Lite', '~>1.10.0'
	pod 'GoogleMaps'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
      end
    end
  end
