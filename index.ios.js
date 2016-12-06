import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

import { loadCustomNativeAds, AD_UNITS } from './src/util/CustomNativeAdManager';
import CustomNativeAd from './src/components/CustomNativeAd';

export default class ReactNativeVSGoogleMobileAds extends Component {

  componentWillMount() {
    loadCustomNativeAds()
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          React Native vs. Google Mobile Ads
        </Text>
        <CustomNativeAd
          adUnitId={AD_UNITS[0].adUnitId}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ReactNativeVSGoogleMobileAds', () => ReactNativeVSGoogleMobileAds);
