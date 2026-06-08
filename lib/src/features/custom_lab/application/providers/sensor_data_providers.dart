import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/sensor_stream_service_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Manages the time series data for a single sensor.
class SensorTimeSeriesNotifier extends StateNotifier<List<double>> {
  SensorTimeSeriesNotifier() : super([]);

  DateTime? _lastUpdate;
  static const _minUpdateInterval = Duration(milliseconds: 500);

  void addDataPoint(double value) {
    final now = DateTime.now();
    if (_lastUpdate != null &&
        now.difference(_lastUpdate!) < _minUpdateInterval) {
      return;
    }

    _lastUpdate = now;
    state = [...state, value];
    if (state.length > 100) {
      state = state.sublist(state.length - 100);
    }
  }

  void clear() {
    state = [];
    _lastUpdate = null;
  }
}

/// A family of providers for each sensor's time series data.
// ...existing code...

final sensorTimeSeriesProvider =
    StateNotifierProvider.family<
      SensorTimeSeriesNotifier,
      List<double>,
      SensorType
    >((ref, sensorType) {
      AppLogger.log('sensorTimeSeriesProvider Called for $sensorType');

      final notifier = SensorTimeSeriesNotifier();
      final sensorStreamService = ref.watch(sensorStreamServiceProvider);

      final subscription = sensorStreamService.getStream(sensorType).listen(
        (dynamic value) {
          double? dataPoint;

          if (sensorType == SensorType.speedMeter) {
            // Position from geolocator
            if (value is Position) {
              // Explicit cast to avoid analyzer complaining about 'speed'
              final double speedMs = (value as Position).speed ?? 0.0;
              dataPoint = speedMs * 3.6; // convert m/s -> km/h
            } else if (value is num) {
              // raw numeric speed (assumed m/s)
              dataPoint = value.toDouble() * 3.6;
            } else if (value is Map<String, dynamic>) {
              final speedVal = value['speed'];
              if (speedVal is num) {
                dataPoint = speedVal.toDouble() * 3.6;
              }
            }
          } else {
            // Other sensors: map with either a numeric value or {x,y,z}
            if (value is Map<String, dynamic>) {
              final rawValue = value[sensorType.name];
              if (rawValue is num) {
                dataPoint = rawValue.toDouble();
              } else if (rawValue is Map<String, dynamic>) {
                final x = (rawValue['x'] as num?)?.toDouble() ?? 0.0;
                final y = (rawValue['y'] as num?)?.toDouble() ?? 0.0;
                final z = (rawValue['z'] as num?)?.toDouble() ?? 0.0;
                // compute magnitude even if zero — chart may want zeros
                dataPoint = sqrt(x * x + y * y + z * z);
              }
            }
          }

          // Update chart UI
          if (dataPoint != null) {
            notifier.addDataPoint(dataPoint);
          }

          // If recording is active, persist data
          final recordingSession = ref.read(recordingSessionProvider);
          if (recordingSession != null &&
              recordingSession.id != null &&
              dataPoint != null) {
            ref
                .read(recordSessionUseCaseProvider)
                .addDataPoint(
                  sessionId: recordingSession.id!,
                  sensorValues: {sensorType: dataPoint},
                );
          }
        },
        onError: (error) => AppLogger.log(
          'Error in $sensorType stream: $error',
          level: LogLevel.error,
        ),
      );

      ref.onDispose(() {
        subscription.cancel();
        notifier.clear();
      });

      return notifier;
    });
