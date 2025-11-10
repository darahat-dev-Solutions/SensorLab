import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/light_meter/presentation/providers/light_meter_provider.dart';
import 'package:sensorlab/src/features/light_meter/presentation/screens/light_meter_display_widget.dart';

class LightMeterScreen extends ConsumerStatefulWidget {
  const LightMeterScreen({super.key});

  @override
  ConsumerState<LightMeterScreen> createState() => _LightMeterScreenState();
}

class _LightMeterScreenState extends ConsumerState<LightMeterScreen> {
  @override
  void initState() {
    super.initState();
    // Get initial reading when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lightMeterProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightMeterData = ref.watch(lightMeterProvider);
    final lightMeterNotifier = ref.read(lightMeterProvider.notifier);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.lightMeter),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => lightMeterNotifier,
                tooltip: l10n.resetData,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LightMeterDisplayWidget(),
                // Light Level Guide
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.lightLevelGuide,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLightGuideItem(
                          '🌑',
                          l10n.darkLevel,
                          l10n.darkRange,
                          l10n.darkExample,
                          Colors.grey[800]!,
                        ),
                        _buildLightGuideItem(
                          '🌘',
                          l10n.dimLevel,
                          l10n.dimRange,
                          l10n.dimExample,
                          Colors.grey[600]!,
                        ),
                        _buildLightGuideItem(
                          '💡',
                          l10n.indoorLevel,
                          l10n.indoorRange,
                          l10n.indoorExample,
                          Colors.orange,
                        ),
                        _buildLightGuideItem(
                          '🏢',
                          l10n.officeLevel,
                          l10n.officeRange,
                          l10n.officeExample,
                          Colors.yellow[700]!,
                        ),
                        _buildLightGuideItem(
                          '☀️',
                          l10n.brightLevel,
                          l10n.brightRange,
                          l10n.brightExample,
                          Colors.yellow,
                        ),
                        _buildLightGuideItem(
                          '🌞',
                          l10n.daylightLevel,
                          l10n.daylightRange,
                          l10n.daylightExample,
                          Colors.yellow[200]!,
                        ),
                      ],
                    ),
                  ),
                ),

                // Error Message
                if (lightMeterData.errorMessage != null)
                  Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lightMeterData.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightGuideItem(
    String emoji,
    String level,
    String range,
    String examples,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level ($range)',
                  style: TextStyle(fontWeight: FontWeight.w500, color: color),
                ),
                Text(
                  examples,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
