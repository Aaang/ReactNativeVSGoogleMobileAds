//
//  AdModule.h
//  ReactNativeVSGoogleMobileAds
//
//  Created by Philipp Anger on 06/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTEventEmitter.h"

NS_ASSUME_NONNULL_BEGIN

/** The AdModule is the direct interface for requesting and loading Ads (e.g. Google Native Ads) between the native app and the React Native Module. */
@interface AdModule : RCTEventEmitter

/** This method is requesting the content for a specific template id and ad units from DFP. The received content will be sent to the React Native Module via the `onNativeAdLoaded` event or in case of an error `onNativeAdLoadingError` is sent.

 @param templateId The id of the used native ad template.
 @param adUnitIds An array of ad unit ids to be loaded from DFP and providing the content for the ads.
 */
- (void)requestNativeCustomTemplateAds:(NSString *)templateId adUnitIds:(NSArray *)adUnitIds;

@end

NS_ASSUME_NONNULL_END
