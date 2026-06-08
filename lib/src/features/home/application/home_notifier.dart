import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void setSensors(List<SensorCard> sensors) {
    state = state.copyWith(sensors: sensors);
  }
}
