import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensorlab/src/core/utils/logger.dart';

import '../../models/speed_data.dart';

class SpeedMeterNotifier extends StateNotifier<SpeedData> {
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;
  double _totalSpeed = 0;
  bool _isTracking = false;

  SpeedMeterNotifier() : super(const SpeedData());

  Future<void> startTracking() async {
    if (_isTracking) {
      return;
    }

    // Check permissions
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.log('))))))))))))))Location service disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.log('Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppLogger.log('Location permission permanently denied');
      return;
    }

    _isTracking = true;
    _lastPosition = null;

    // Start listening to position stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // Update every meter
    );

    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((position) {
          AppLogger.log(
            'New position: ${position.latitude}, ${position.longitude}, speed: ${position.speed}',
          );

          _updateSpeed(position);
        }, onError: (e) => AppLogger.log('Position stream error: $e'));
  }

  void _updateSpeed(Position position) {
    // Get speed from GPS (in m/s)
    final rawSpeed = position.speed;
    if (position.accuracy != null && position.accuracy < 20) {
      final currentSpeed = position.speed >= 0 ? position.speed : 0.0;

      // Calculate distance if we have a previous position
      double distanceIncrement = 0;
      if (_lastPosition != null) {
        distanceIncrement = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
      }

      _lastPosition = position;

      // Update max speed
      final newMaxSpeed = math.max(state.maxSpeed, currentSpeed);

      // Update average speed
      final newSampleCount = state.sampleCount + 1;
      _totalSpeed += currentSpeed;
      final newAvgSpeed = _totalSpeed / newSampleCount;

      // Update total distance
      final newDistance = state.distance + distanceIncrement;

      final updatedHistory = [
        ...state.speedHistory,
        currentSpeed * 3.6, // Store as km/h
      ];
      final trimmedHistory = updatedHistory.length > 100
          ? updatedHistory.sublist(updatedHistory.length - 100)
          : updatedHistory;

      state = state.copyWith(
        currentSpeed: currentSpeed,
        maxSpeed: newMaxSpeed,
        avgSpeed: newAvgSpeed,
        distance: newDistance,
        isActive: true,
        sampleCount: newSampleCount,
        speedHistory: trimmedHistory, // <-- ensure not null
      );
    }
  }

  void stopTracking() {
    _isTracking = false;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    state = state.copyWith(isActive: false);
  }

  void resetStats() {
    _totalSpeed = 0;
    state = state.resetStats();
  }

  void reset() {
    _totalSpeed = 0;
    _lastPosition = null;
    state = const SpeedData();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

final speedMeterProvider = StateNotifierProvider<SpeedMeterNotifier, SpeedData>(
  (ref) => SpeedMeterNotifier(),
);
