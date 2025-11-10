// lib/src/features/home/presentation/widgets/quick_access_section.dart
import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../../shared/models/sensor_card.dart';

typedef OnSensorTap = void Function(SensorCard sensor);

class QuickAccessSection extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final List<SensorCard> sensors;
  final OnSensorTap onCardTap;
  final VoidCallback onViewAll;

  const QuickAccessSection({
    super.key,
    required this.isDark,
    required this.l10n,
    required this.sensors,
    required this.onCardTap,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1F36),
                ),
              ),
              TextButton.icon(
                onPressed: onViewAll,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF667EEA),
                ),
                label: Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF667EEA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return _QuickCard(
                  sensor: sensor,
                  isDark: isDark,
                  onTap: () => onCardTap(sensor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final SensorCard sensor;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickCard({
    required this.sensor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 2,
        shadowColor: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF1E2139) : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        sensor.color.withOpacity(0.2),
                        sensor.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(sensor.icon, size: 26, color: sensor.color),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    sensor.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF1A1F36),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
