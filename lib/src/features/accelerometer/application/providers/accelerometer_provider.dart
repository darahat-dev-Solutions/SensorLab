import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/accelerometer_data.dart';

// Model for accelerometer triple (X, Y, Z)
class AccelerometerTriple {
  final double x;
  final double y;
  final double z;

  AccelerometerTriple({required this.x, required this.y, required this.z});
  double get magnitude => math.sqrt(x * x + y * y + z * z);
}

// Low-level raw accelerometer event provider(direct sensor stream)
final rawAccelerometerEventProvider = StreamProvider<AccelerometerEvent>((ref) {
  return accelerometerEventStream();
});

// High-level accelerometer data provider (derived from sensor time series)
final accelerometerProvider = Provider<AccelerometerData>((ref) {
  // Watch the sensor time series (magnitude data)
  final dataPoints = ref.watch(
    sensorTimeSeriesProvider(SensorType.accelerometer),
  );

  final currentMagnitude = dataPoints.isNotEmpty ? dataPoints.last : 0.0;
  final maxMagnitude = dataPoints.isNotEmpty
      ? dataPoints.reduce((a, b) => a > b ? a : b)
      : 0.0;
  final minMagnitude = dataPoints.isNotEmpty
      ? dataPoints.reduce((a, b) => a < b ? a : b)
      : 0.0;
  final avgMagnitude = dataPoints.isNotEmpty
      ? dataPoints.reduce((a, b) => a + b) / dataPoints.length
      : 0.0;

  return AccelerometerData(
    x: 0.0,
    y: 0.0,
    z: 0.0,
    maxX: 0.0,
    maxY: 0.0,
    maxZ: 0.0,
    minX: 0.0,
    minY: 0.0,
    minZ: 0.0,
    isActive: dataPoints.isNotEmpty,
    magnitude: currentMagnitude,
  );
});

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

  static List<double> magnitudes(List<AccelerometerTriple> triples) {
    return triples.map(magnitude).toList();
  }
}
