Pod::Spec.new do |s|
    s.name         = 'react-native-vs-google-mobile-ads'
    s.version      = '1.0.0'
    s.summary      = 'An example app to reproduce the react native vs. google mobile ads issue library.'
    s.source       = { :git => 'https://github.com/Aaang/ReactNativeVSGoogleMobileAds.git', :tag => s.version.to_s }

    s.ios.deployment_target = '8.0'

    s.compiler_flags = '-Werror' # treat warnings as errors

    s.header_dir = 'RNVSGMA'
    s.default_subspec = 'core'

    s.subspec "core" do |core|
        core.frameworks	 = 'Foundation', 'UIKit', 'GoogleMobileAds'
        core.xcconfig = {
        'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/react-native-vs-google-mobile-ads/ReactNativeVSGoogleMobileAds/Frameworks/GoogleMobileAdsSdkiOS-7.15.0"'
        }
        core.source_files = 'ios/ReactNativeVSGoogleMobileAds/Classes/**/*.{h,m}'
        core.resources = 'ios/ReactNativeVSGoogleMobileAds/Classes/**/*.{storyboard,xib}'
        core.public_header_files  = 'ios/ReactNativeVSGoogleMobileAds/Classes/*.h'
        core.private_header_files = 'ios/ReactNativeVSGoogleMobileAds/Classes/Internal/*.h'
        core.preserve_paths = 'ios/ReactNativeVSGoogleMobileAds/Frameworks/GoogleMobileAdsSdkiOS-7.15.0/GoogleMobileAds.framework'

        # There would be other dependencies
    end
end
