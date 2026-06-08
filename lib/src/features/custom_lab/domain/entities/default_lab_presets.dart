import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:uuid/uuid.dart';

/// Default lab presets that come pre-configured with the app
class DefaultLabPresets {
  static const _uuid = Uuid();

  /// Get all default presets
  static List<Lab> getDefaultPresets() {
    return [
      environmentMonitor(),
      motionAnalysis(),
      indoorQuality(),
      outdoorExplorer(),
      vehicleDynamics(),
    ];
  }

  /// Environment Monitor - Temperature, Humidity, Light, Noise, Pressure
  static Lab environmentMonitor() {
    return Lab(
      id: _uuid.v4(),
      name: 'Environment Monitor',
      description:
          'Track environmental conditions with temperature, humidity, light, noise, and barometric pressure sensors.',
      sensors: const [
        SensorType.temperature,
        SensorType.humidity,
        SensorType.lightMeter,
        SensorType.noiseMeter,
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: true,
      iconName: 'environment',
      colorValue: Colors.green.value,
      recordingInterval: 1000, // 1 second
    );
  }

  /// Motion Analysis - Accelerometer, Gyroscope, Magnetometer
  static Lab motionAnalysis() {
    return Lab(
      id: _uuid.v4(),
      name: 'Motion Analysis',
      description:
          'Analyze movement and orientation using accelerometer, gyroscope, and magnetometer sensors.',
      sensors: const [
        SensorType.accelerometer,
        SensorType.gyroscope,
        SensorType.magnetometer,
        SensorType.compass,
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: true,
      iconName: 'motion',
      colorValue: Colors.blue.value,
    );
  }

  /// Indoor Quality - Light, Noise, Temperature, Humidity
  static Lab indoorQuality() {
    return Lab(
      id: _uuid.v4(),
      name: 'Indoor Quality',
      description:
          'Monitor indoor environment quality with light levels, noise pollution, temperature, and humidity.',
      sensors: const [
        SensorType.lightMeter,
        SensorType.noiseMeter,
        SensorType.temperature,
        SensorType.humidity,
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: true,
      iconName: 'indoor',
      colorValue: Colors.orange.value,
      recordingInterval: 2000, // 2 seconds
    );
  }

  /// Outdoor Explorer - GPS, Altimeter, Speed, Barometer, Compass
  static Lab outdoorExplorer() {
    return Lab(
      id: _uuid.v4(),
      name: 'Outdoor Explorer',
      description:
          'Track outdoor activities with GPS location, altitude, speed, atmospheric pressure, and direction.',
      sensors: const [
        SensorType.gps,
        SensorType.altimeter,
        SensorType.speedMeter,
        SensorType.compass,
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: true,
      iconName: 'outdoor',
      colorValue: Colors.teal.value,
      recordingInterval: 1000, // 1 second
    );
  }

  /// Vehicle Dynamics - Accelerometer, Gyroscope, GPS, Speed
  static Lab vehicleDynamics() {
    return Lab(
      id: _uuid.v4(),
      name: 'Vehicle Dynamics',
      description:
          'Monitor vehicle movement with acceleration, rotation, GPS tracking, and speed measurement.',
      sensors: const [
        SensorType.accelerometer,
        SensorType.gyroscope,
        SensorType.gps,
        SensorType.speedMeter,
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: true,
      iconName: 'vehicle',
      colorValue: Colors.red.value,
      recordingInterval: 500, // 500ms for vehicle data
    );
  }
}
