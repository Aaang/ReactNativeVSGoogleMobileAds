import {
  DeviceEventEmitter,
  NativeEventEmitter,
  NativeModules,
} from 'react-native';

import { get, uniq } from 'lodash';

import AdModule from '../native_modules/AdModule';

export const AD_UNITS = [
  { adUnitId: '/6499/example/native' },
];

const CONTENT_AD_TEMPLATE_ID = '10063170';

let ads = {};

export function loadCustomNativeAds() {
  const adUnitIds = uniq(AD_UNITS.map((ad) => ad.adUnitId));

  const adModuleEvents = new NativeEventEmitter(NativeModules.AdModule);
  adModuleEvents.addListener('onNativeAdLoaded', (nativeAdData) => {

    const ad = buildAd(nativeAdData);
    ads[nativeAdData.adUnitId] = ad;
    console.log(`Ads:`);
    console.log(ads);
  });

  adModuleEvents.addListener('onNativeAdLoadingError', (nativeAdData) => {
    const contentAd = buildAd(nativeAdData);
    contentAd.hasError = true;
    ads[nativeAdData.adUnitId] = contentAd;
  });

  try {
    AdModule.requestNativeCustomTemplateAds(CONTENT_AD_TEMPLATE_ID, adUnitIds);
  } catch (e) {
    console.log(`CAUGHT ERROR: ${e}`);
  }
}

function buildAd(nativeAdData) {
  const adUnitId = get(nativeAdData, 'adUnitId');
  const imageUrl = get(nativeAdData, 'MainImage');
  const headline = get(nativeAdData, 'Headline', '');
  const caption = get(nativeAdData, 'Caption', '');

  return {
    adUnitId,
    imageUrl,
    headline,
    caption,
  };
}

export function getAd(adUnitId) {
  console.log(`GET AD: ${adUnitId}`);
  return ads[adUnitId];
}
