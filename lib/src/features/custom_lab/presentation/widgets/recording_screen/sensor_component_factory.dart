import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/accelerometer/presentation/screens/accelerometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/altimeter_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/compass_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/gps_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/magnetometer_display_widget.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/recording_screen/sensor_widgets/noise_meter_display_widget.dart';
import 'package:sensorlab/src/features/gyroscope/presentation/screens/gyroscope_display_widget.dart';
import 'package:sensorlab/src/features/light_meter/presentation/screens/light_meter_display_widget.dart';
import 'package:sensorlab/src/features/speed_meter/presentation/screens/speed_meter_display_widget.dart';

/// Factory to create sensor-specific recording widgets
/// This allows custom_lab to reuse existing sensor components from each feature
class SensorComponentFactory {
  /// Widget to show when a sensor is not available on the device
  static Widget unavailableSensorWidget(String sensorName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$sensorName sensor is not available on this device.',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate recording widget for the given sensor type
  static Widget buildSensorWidget(SensorType sensorType) {
    switch (sensorType) {
      case SensorType.lightMeter:
        return const LightMeterDisplayWidget();
      case SensorType.noiseMeter:
        return const NoiseMeterDisplayWidget();
      case SensorType.accelerometer:
        return const AccelerometerDisplayWidget();
      case SensorType.gyroscope:
        return const GyroscopeDisplayWidget();
      case SensorType.magnetometer:
        return const MagnetometerDisplayWidget();
      case SensorType.temperature:
        // TODO: Replace with actual temperature widget when implemented
        final isAvailable = _isSensorAvailable(sensorType);
        return isAvailable
            ? const SizedBox.shrink() // Replace with TemperatureDisplayWidget when ready
            : unavailableSensorWidget('Temperature');
      case SensorType.humidity:
        // TODO: Replace with actual humidity widget when implemented
        final isAvailable = _isSensorAvailable(sensorType);
        return isAvailable
            ? const SizedBox.shrink() // Replace with HumidityDisplayWidget when ready
            : unavailableSensorWidget('Humidity');

      case SensorType.compass:
        return const CompassDisplayWidget();
      case SensorType.altimeter:
        return const AltimeterDisplayWidget();
      case SensorType.speedMeter:
        return const SpeedMeterDisplayWidget();
      case SensorType.gps:
        return const GpsDisplayWidget();
    }
  }

  /// Checks if the sensor is available on the device
  static bool _isSensorAvailable(SensorType sensorType) {
    // TODO: Implement actual device sensor availability check
    // For now, always return false for temperature/humidity
    switch (sensorType) {
      case SensorType.temperature:
      case SensorType.humidity:
        return false;
      default:
        return true;
    }
  }
}
