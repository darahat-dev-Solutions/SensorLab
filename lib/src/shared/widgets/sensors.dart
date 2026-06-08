import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/accelerometer/presentation/screens/accelerometer_screen.dart';
import 'package:sensorlab/src/features/compass/presentation/screens/compass_screen.dart';
import 'package:sensorlab/src/features/gyroscope/presentation/screens/gyroscope_screen.dart';
import 'package:sensorlab/src/features/humidity/presentation/screens/humidity_screen.dart';
import 'package:sensorlab/src/features/light_meter/presentation/screens/light_meter_screen.dart';
import 'package:sensorlab/src/features/magnetometer/presentation/screens/magnetometer_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/noise_meter_screen.dart';
import 'package:sensorlab/src/features/speed_meter/presentation/screens/speed_meter_screen.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';

List<SensorCard> getSensors(AppLocalizations l10n) {
  return [
    SensorCard(
      icon: Iconsax.sound,
      label: l10n.noiseMeter,
      color: Colors.teal,
      screen: const NoiseMeterScreen(),
      category: l10n.health,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: Iconsax.sun_1,
      label: l10n.lightMeter,
      color: Colors.amber,
      screen: const LightMeterScreen(),
      category: l10n.environment,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: Icons.compass_calibration_rounded,
      label: l10n.compass,
      color: Colors.deepPurple,
      screen: const CompassScreen(),
      category: l10n.navigation,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: Iconsax.activity,
      label: l10n.accelerometer,
      color: Colors.pink,
      screen: const AccelerometerScreen(),
      category: l10n.motion,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: Iconsax.cpu,
      label: l10n.gyroscope,
      color: Colors.blue,
      screen: const GyroscopeScreen(),
      category: l10n.motion,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: FontAwesomeIcons.magnet,
      label: l10n.magnetometer,
      color: Colors.red,
      screen: const MagnetometerScreen(),
      category: l10n.magnetic,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: FontAwesomeIcons.droplet,
      label: l10n.humidity,
      color: Colors.orange,
      screen: const HumidityScreen(),
      category: l10n.environment,
      title: '',
      description: '',
      isDark: true,
    ),
    SensorCard(
      icon: Iconsax.speedometer,
      label: l10n.speedMeter,
      color: Colors.indigo,
      screen: const SpeedMeterScreen(),
      category: l10n.navigation,
      title: '',
      description: '',
      isDark: true,
    ),
  ];
}
