import React from 'react';
import {
  NativeEventEmitter,
  NativeModules,
  View,
  Text,
  Image,
} from 'react-native';

import { getAd } from '../util/CustomNativeAdManager';

class CustomNativeAd extends React.Component {

  constructor(props: Props) {
    super(props);

    this.state = {
      imageWidth: 0,
      imageHeight: 0,
      imageContainerWidth: 0,
    };

    this.listeners = [];
  }

  componentDidMount() {
    const adModuleEvents = new NativeEventEmitter(NativeModules.AdModule);
    const loadedListener = adModuleEvents.addListener('onNativeAdLoaded', (nativeAdData) => {
      if (nativeAdData.adUnitId === this.props.adUnitId) {
        this.forceUpdate();
      }
    });
    const errorListener = adModuleEvents.addListener('onNativeAdLoadingError', (nativeAdData) => {
      console.log(nativeAdData);
      if (nativeAdData.adUnitId === this.props.adUnitId) {
        this.forceUpdate();
      }
    });
    this.listeners.push(loadedListener);
    this.listeners.push(errorListener);
  }

  componentWillUnmount() {
    this.listeners.forEach(l => l.remove());
  }

  render() {
    const ad = getAd(this.props.adUnitId);

    if (!ad) {
      return this._renderLoadingState();
    } else if (ad.hasError) {
      return this._renderErrorState();
    } else {
      return this._renderAd(ad);
    }
  }

  _renderLoadingState() {
    return (
      <Text>Loading ...</Text>
    );
  }

  _renderErrorState() {
    return (
      <Text>Error ...</Text>
    );
  }

  _renderAd(ad) {
    const {
      headline,
      caption,
      imageUrl,
    } = ad;

    return (
      <View>
        <Text>{headline}</Text>
        <View>
          <Image style={[{ width: 200, height: 200 }]} resizeMode={Image.resizeMode.cover} source={{ uri: imageUrl }} />
        </View>
        <Text>{caption}</Text>
      </View>
    );
  }
}

export default CustomNativeAd;
