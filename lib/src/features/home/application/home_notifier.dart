import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../shared/models/sensor_card.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void updateTabIndex(int index) {
    if (index == state.selectedTabIndex) {
      return;
    }
    state = state.copyWith(selectedTabIndex: index);
  }

  void setInterstitialAd(InterstitialAd? ad) {
    if (ad == state.interstitialAd) {
      return;
    }
    state = state.copyWith(interstitialAd: ad);
  }

  void setSensors(List<SensorCard> sensors) {
    state = state.copyWith(sensors: sensors);
  }

  void setAdsEnabled(bool enabled) {
    state = state.copyWith(adsEnabled: enabled);
  }

  void disposeAd() {
    state.interstitialAd?.dispose();
    state = state.copyWith();
  }
}
