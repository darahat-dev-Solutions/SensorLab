import '../../../shared/models/sensor_card.dart';

class HomeState {
  final int selectedTabIndex;
  final List<SensorCard> sensors;

  const HomeState({this.selectedTabIndex = 0, this.sensors = const []});

  HomeState copyWith({int? selectedTabIndex, List<SensorCard>? sensors}) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      sensors: sensors ?? this.sensors,
    );
  }
}
