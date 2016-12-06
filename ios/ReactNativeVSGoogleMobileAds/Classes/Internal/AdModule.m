//
//  AdModule.m
//  ReactNativeVSGoogleMobileAds
//
//  Created by Philipp Anger on 06/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "AdModule.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kOnNativeAdLoadedEvent = @"onNativeAdLoaded";
static NSString * const kOnNativeAdLoadingErrorEvent = @"onNativeAdLoadingError";

@interface AdModule()  <RCTBridgeModule, GADNativeCustomTemplateAdLoaderDelegate, GADAdLoaderDelegate>

  @property (nonatomic, copy) NSMutableDictionary<NSString *, GADAdLoader *> *adLoaders;
  @property (nonatomic, strong) NSNumber *templateId;
  
  @property (nonatomic, assign) BOOL isRequestingNativeAds;
  @property (nonatomic, assign) BOOL isEventEmitterReady;

  @property (nonatomic, copy, nullable) NSArray *adUnitIds;
  @property (nonatomic, strong, nullable) UIViewController *adLoaderViewController;

@end

@implementation AdModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(requestNativeCustomTemplateAds:(NSString *)templateId adUnitIds:(NSArray *)adUnitIds) {
    if (self.isRequestingNativeAds || templateId.length == 0 || adUnitIds.count == 0) {
        return;
    }
  
    self.adLoaderViewController = [UIViewController new];
    self.adUnitIds = [adUnitIds copy];
    self.isRequestingNativeAds = YES;

    [self _requestNativeCustomTemplate:templateId adUnitIds:self.adUnitIds withinViewController:self.adLoaderViewController];
}

#pragma mark - RCTEventEmitter Events

- (NSArray<NSString *> *)supportedEvents {
    return @[kOnNativeAdLoadedEvent, kOnNativeAdLoadingErrorEvent];
}

- (void)startObserving {
    self.isEventEmitterReady = YES;
}

- (void)stopObserving {
    self.isEventEmitterReady = NO;
}

- (void)sendNativeAdLoaded:(NSDictionary *)body {
    if (!self.isEventEmitterReady) {
        return;
    }
    
    [self sendEventWithName:kOnNativeAdLoadedEvent body:body];
}

- (void)sendNativeAdLoadingError:(NSDictionary *)body {
    if (!self.isEventEmitterReady) {
        return;
    }
    
    [self sendEventWithName:kOnNativeAdLoadingErrorEvent body:body];
}

#pragma mark - GADNativeContentAdLoaderDelegate
  
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeCustomTemplateAd:(GADNativeCustomTemplateAd *)nativeCustomTemplateAd {
  NSString *adUnitId = [self.adLoaders allKeysForObject:adLoader].firstObject;
  
  if (!adUnitId) {
    [self _didFailToReceiveAdWithError:nil adUnitId:nil];
    return;
  }
  
  NSMutableDictionary *nativeAdContent = [NSMutableDictionary dictionary];
  [nativeAdContent setObject:adUnitId forKey:@"adUnitId"];
  
  for (NSString *assetName in nativeCustomTemplateAd.availableAssetKeys) {
    if ([nativeCustomTemplateAd stringForKey:assetName]) {
      [nativeAdContent setObject:[nativeCustomTemplateAd stringForKey:assetName] forKey:assetName];
    } else if ([nativeCustomTemplateAd imageForKey:assetName]) {
      GADNativeAdImage *image = [nativeCustomTemplateAd imageForKey:assetName];
      [nativeAdContent setObject:image.imageURL.absoluteString forKey:assetName];
    }
  }
  
  [self _didReceiveNativeCustomTemplateAdContent:nativeAdContent adUnitId:adUnitId];
}
  
- (NSArray *)nativeCustomTemplateIDsForAdLoader:(GADAdLoader *)adLoader {
  return @[self.templateId];
}
  
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
  NSString *adUnitId = [self.adLoaders allKeysForObject:adLoader].firstObject;
  NSError *adError = [NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
  
  if (!adUnitId) {
    [self _didFailToReceiveAdWithError:adError adUnitId:nil];
    return;
  }
  
  [self _didFailToReceiveAdWithError:adError adUnitId:adUnitId];
}

#pragma mark - Private Methods

- (void)_requestNativeCustomTemplate:(NSString *)templateId adUnitIds:(NSArray *)adUnitIds withinViewController:(UIViewController *)viewController {
  NSMutableDictionary<NSString *, GADAdLoader *> *adLoaders = [NSMutableDictionary dictionary];
  self.templateId = [NSNumber numberWithInteger:[templateId integerValue]];
  
  // Create GADAdLoaders
  for (NSString *adUnitId in adUnitIds) {
    GADAdLoader *adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitId
                                               rootViewController:viewController
                                                          adTypes:@[ kGADAdLoaderAdTypeNativeCustomTemplate ]
                                                          options:nil];
    adLoader.delegate = self;
    [adLoaders setObject:adLoader forKey:adUnitId];
  }
  
  // Keep the strong reference to the GADAdLoaders for the delegate calls
  self.adLoaders = [adLoaders mutableCopy];
  
  // Now we request the ad contents
  for (NSString *adUnitId in self.adLoaders.allKeys) {
    GADAdLoader *adLoader = self.adLoaders[adUnitId];
    [adLoader loadRequest:[GADRequest new]];
  }
}
  
- (void)_removeAdUnitId:(nullable NSString *)adUnitId {
    NSMutableArray *tempAdUnits = [self.adUnitIds mutableCopy];
    
    if (adUnitId && [self.adUnitIds indexOfObject:adUnitId] != NSNotFound) {
        [tempAdUnits removeObject:adUnitId];
    } else {
        NSAssert(NO, @"AdModule > _removeAdUnitId > the passed adUnit should always exist in the adUnitIds array!");
        [tempAdUnits removeLastObject];
    }
    
    self.adUnitIds = [tempAdUnits copy];
    
    if (self.adUnitIds.count == 0) {
        [self _resetAdLoader];
    }
}

- (void)_resetAdLoader {
    self.adUnitIds = nil;
    self.adLoaderViewController = nil;
}
  
- (void)_didReceiveNativeCustomTemplateAdContent:(NSDictionary *)adContent adUnitId:(nullable NSString *)adUnitId {
    if (!adUnitId) {
      [self _removeAdUnitId:nil];
      
      return;
    }
    
    [self sendNativeAdLoaded:adContent];
    [self _removeAdUnitId:adUnitId];
  }
  
- (void)_didFailToReceiveAdWithError:(nullable NSError *)error adUnitId:(nullable NSString *)adUnitId {
  if (!adUnitId) {
    [self _removeAdUnitId:nil];
    
    return;
  }
  
  NSMutableDictionary *nativeAdContent = [NSMutableDictionary dictionary];
  [nativeAdContent setObject:adUnitId forKey:@"adUnitId"];
  
  [self sendNativeAdLoadingError:nativeAdContent];
  [self _removeAdUnitId:adUnitId];
}

@end

NS_ASSUME_NONNULL_END
