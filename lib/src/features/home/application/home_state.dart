import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../shared/models/sensor_card.dart';

class HomeState {
  final int selectedTabIndex;
  final InterstitialAd? interstitialAd;
  final List<SensorCard> sensors;
  final bool adsEnabled;

  const HomeState({
    this.selectedTabIndex = 0,
    this.interstitialAd,
    this.sensors = const [],
    this.adsEnabled = true,
  });

  HomeState copyWith({
    int? selectedTabIndex,
    InterstitialAd? interstitialAd,
    List<SensorCard>? sensors,
    bool? adsEnabled,
  }) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      interstitialAd: interstitialAd ?? this.interstitialAd,
      sensors: sensors ?? this.sensors,
      adsEnabled: adsEnabled ?? this.adsEnabled,
    );
  }
}
