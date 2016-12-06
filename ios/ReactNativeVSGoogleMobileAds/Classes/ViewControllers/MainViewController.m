//
//  MainViewController.m
//  ReactNativeVSGoogleMobileAds
//
//  Created by Philipp Anger on 06/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "MainViewController.h"

#import "RCTBundleURLProvider.h"
#import "RCTRootView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSURL *jsCodeLocation;
  
  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ReactNativeVSGoogleMobileAds"
                                               initialProperties:nil
                                                   launchOptions:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  self.view = rootView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
