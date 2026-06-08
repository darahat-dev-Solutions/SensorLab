import 'package:hive/hive.dart';

part 'sensor_type.g.dart';

/// Enum representing available sensor types that can be included in a lab
@HiveType(typeId: 20)
enum SensorType {
  @HiveField(0)
  accelerometer,

  @HiveField(1)
  gyroscope,

  @HiveField(2)
  magnetometer,

  @HiveField(3)
  lightMeter,

  @HiveField(4)
  noiseMeter,

  @HiveField(5)
  gps,

  @HiveField(6)
  proximity,

  @HiveField(7)
  temperature,

  @HiveField(8)
  humidity,

  @HiveField(9)
  compass,

  @HiveField(10)
  altimeter,

  @HiveField(11)
  speedMeter;

  /// Get display name for the sensor
  String get displayName {
    switch (this) {
      case SensorType.accelerometer:
        return 'Accelerometer';
      case SensorType.gyroscope:
        return 'Gyroscope';
      case SensorType.magnetometer:
        return 'Magnetometer';
      case SensorType.lightMeter:
        return 'Light Meter';
      case SensorType.noiseMeter:
        return 'Noise Meter';
      case SensorType.gps:
        return 'GPS';
      case SensorType.proximity:
        return 'Proximity';
      case SensorType.temperature:
        return 'Temperature';
      case SensorType.humidity:
        return 'Humidity';
      case SensorType.compass:
        return 'Compass';
      case SensorType.altimeter:
        return 'Altimeter';
      case SensorType.speedMeter:
        return 'Speed Meter';
    }
  }

  /// Get icon name for the sensor
  String get iconName {
    switch (this) {
      case SensorType.accelerometer:
        return 'accelerometer';
      case SensorType.gyroscope:
        return 'gyroscope';
      case SensorType.magnetometer:
        return 'magnetometer';
      case SensorType.lightMeter:
        return 'light_meter';
      case SensorType.noiseMeter:
        return 'noise_meter';
      case SensorType.gps:
        return 'gps';
      case SensorType.proximity:
        return 'proximity';
      case SensorType.temperature:
        return 'temperature';
      case SensorType.humidity:
        return 'humidity';
      case SensorType.compass:
        return 'compass';
      case SensorType.altimeter:
        return 'altimeter';
      case SensorType.speedMeter:
        return 'speed_meter';
    }
  }
}
