import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/speed_meter/presentation/providers/speed_meter_provider.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class SpeedMeterDisplayWidget extends ConsumerWidget {
  const SpeedMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speedData = ref.watch(speedMeterProvider);

    return Column(
      children: [
        RealtimeLineChart(
          dataPoints: speedData.speedHistory,
          title: 'Speed (km/h)',
          lineColor: Colors.deepOrange,
          maxY: speedData.speedHistory.isNotEmpty
              ? speedData.speedHistory.reduce((a, b) => a > b ? a : b) * 1.2
              : 100,
          horizontalInterval: 20,
          leftTitleBuilder: (value) => '${value.toInt()}',
        ),
        ElevatedButton(
          onPressed: () =>
              ref.read(speedMeterProvider.notifier).startTracking(),
          child: const Text('Start Speed Tracking'),
        ),
      ],
    );
  }
}
