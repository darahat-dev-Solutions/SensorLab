import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/accelerometer_data.dart';

// Model for accelerometer triple (X, Y, Z)
class AccelerometerTriple {
  final double x;
  final double y;
  final double z;

  AccelerometerTriple({required this.x, required this.y, required this.z});
}

class AccelerometerNotifier extends StateNotifier<AccelerometerData> {
  StreamSubscription<AccelerometerEvent>? _subscription;

  AccelerometerNotifier() : super(const AccelerometerData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      _updateData(event);
    });
  }

  void _updateData(AccelerometerEvent event) {
    // Update max values
    final newMaxX = math.max(state.maxX, event.x.abs());
    final newMaxY = math.max(state.maxY, event.y.abs());
    final newMaxZ = math.max(state.maxZ, event.z.abs());

    state = state.copyWith(
      x: event.x,
      y: event.y,
      z: event.z,
      maxX: newMaxX,
      maxY: newMaxY,
      maxZ: newMaxZ,
      isActive: true,
    );
  }

  void resetMaxValues() {
    state = state.resetMaxValues();
  }

  void reset() {
    state = const AccelerometerData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final accelerometerProvider =
    StateNotifierProvider<AccelerometerNotifier, AccelerometerData>(
      (ref) => AccelerometerNotifier(),
    );

// History notifier for raw accelerometer (with gravity)
class AccelerometerHistoryNotifier
    extends StateNotifier<List<AccelerometerTriple>> {
  StreamSubscription<AccelerometerEvent>? _subscription;
  static const int maxSamples = 100;

  AccelerometerHistoryNotifier() : super([]) {
    _startListening();
  }

  void _startListening() {
    _subscription = accelerometerEventStream().listen((event) {
      final newData = AccelerometerTriple(x: event.x, y: event.y, z: event.z);
      state = [...state, newData];
      if (state.length > maxSamples) {
        state = state.sublist(state.length - maxSamples);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// History notifier for linear accelerometer (without gravity)
class LinearAccelerometerHistoryNotifier
    extends StateNotifier<List<AccelerometerTriple>> {
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  static const int maxSamples = 100;

  LinearAccelerometerHistoryNotifier() : super([]) {
    _startListening();
  }

  void _startListening() {
    _subscription = userAccelerometerEventStream().listen((event) {
      final newData = AccelerometerTriple(x: event.x, y: event.y, z: event.z);
      state = [...state, newData];
      if (state.length > maxSamples) {
        state = state.sublist(state.length - maxSamples);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final accelerometerRawProvider =
    StateNotifierProvider<
      AccelerometerHistoryNotifier,
      List<AccelerometerTriple>
    >((ref) {
      return AccelerometerHistoryNotifier();
    });

final linearAccelerometerRawProvider =
    StateNotifierProvider<
      LinearAccelerometerHistoryNotifier,
      List<AccelerometerTriple>
    >((ref) {
      return LinearAccelerometerHistoryNotifier();
    });

final accelerometerXYZProvider = Provider<List<List<double>>>((ref) {
  final raw = ref.watch(accelerometerRawProvider);
  return raw.map((e) => [e.x, e.y, e.z]).toList();
});

final linearAccelerometerXYZProvider = Provider<List<List<double>>>((ref) {
  final linear = ref.watch(linearAccelerometerRawProvider);
  return linear.map((e) => [e.x, e.y, e.z]).toList();
});

class AccelerometerService {
  static double magnitude(AccelerometerTriple triple) {
    return math.sqrt(
      triple.x * triple.x + triple.y * triple.y + triple.z * triple.z,
    );
  }
}
