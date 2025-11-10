// lib/src/features/home/presentation/widgets/sensor_grid.dart
import 'package:flutter/material.dart';

import '../../../../shared/models/sensor_card.dart';

typedef SensorTap = void Function(SensorCard sensor);

class SensorGrid extends StatelessWidget {
  final bool isDark;
  final List<SensorCard> sensors;
  final int selectedIndex;
  final SensorTap onSensorTap;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final dynamic l10n;

  const SensorGrid({
    super.key,
    required this.isDark,
    required this.sensors,
    required this.selectedIndex,
    required this.onSensorTap,
    required this.animationController,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _getUniqueCategories(l10n);
    List<SensorCard> filteredSensors;
    if (selectedIndex == 0) {
      filteredSensors = sensors;
    } else {
      final category = categories[selectedIndex - 1];
      filteredSensors = sensors.where((s) => s.category == category).toList();
    }

    if (filteredSensors.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sensors_off_rounded,
                  size: 40,
                  color: isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'No sensors found',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return MinimalSensorCard(
            isDark: isDark,
            sensor: filteredSensors[index],
            onTap: () => onSensorTap(filteredSensors[index]),
            animationController: animationController,
            scaleAnimation: scaleAnimation,
            fadeAnimation: fadeAnimation,
          );
        }, childCount: filteredSensors.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
      ),
    );
  }

  List<String> _getUniqueCategories(dynamic l10n) {
    final list = <String>[];
    for (final s in sensors) {
      if (!list.contains(s.category)) {
        list.add(s.category);
      }
    }
    return list;
  }
}

class MinimalSensorCard extends StatelessWidget {
  final bool isDark;
  final SensorCard sensor;
  final VoidCallback onTap;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;

  const MinimalSensorCard({
    required this.isDark,
    required this.sensor,
    required this.onTap,
    required this.animationController,
    required this.scaleAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    // Get a short description of what the sensor does
    final sensorDescription = _getSensorDescription(sensor.label);

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final secondary = theme.colorScheme.secondary;
    final cardBg = isDark ? surface : Colors.white;
    final cardText = isDark ? onSurface : Colors.black87;
    final sensorColor = sensor.color;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final safeOpacity = fadeAnimation.value.clamp(0.0, 1.0);
        final safeScale = scaleAnimation.value.clamp(0.0, 2.0);

        return Opacity(
          opacity: safeOpacity,
          child: Transform.scale(
            scale: safeScale,
            child: Material(
              elevation: 2,
              shadowColor: theme.shadowColor,
              borderRadius: BorderRadius.circular(12),
              color: cardBg,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Compact icon section
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primary.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Icon(sensor.icon, size: 20, color: primary),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Sensor name - compact
                      Text(
                        sensor.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cardText,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      // What it does - minimal description
                      Text(
                        sensorDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: cardText.withOpacity(0.7),
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      // Minimal category tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          sensor.category,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: secondary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSensorDescription(String sensorLabel) {
    // Map sensor labels to short, clear descriptions
    final descriptions = {
      'Accelerometer': 'Measures motion and tilt',
      'Gyroscope': 'Detects rotation speed',
      'Magnetometer': 'Finds magnetic north',
      'Proximity': 'Detects nearby objects',
      'Light': 'Measures brightness',
      'Pressure': 'Measures air pressure',
      'Temperature': 'Reads ambient heat',
      'Humidity': 'Measures moisture level',
      'Step Counter': 'Counts walking steps',
      'Heart Rate': 'Measures pulse',
      'GPS': 'Shows location',
      'Compass': 'Shows direction',
      'Barometer': 'Measures altitude',
      'Microphone': 'Records sound',
      'Camera': 'Takes photos/videos',
      'Fingerprint': 'Biometric security',
    };

    return descriptions[sensorLabel] ?? 'Measures sensor data';
  }
}
