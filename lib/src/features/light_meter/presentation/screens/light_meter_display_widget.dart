import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/light_meter/presentation/providers/light_meter_provider.dart';

class LightMeterDisplayWidget extends ConsumerWidget {
  const LightMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.lightMeter),
    );

    // Watch and update light meter provider with dataPoints
    final lightMeterData = ref.watch(lightMeterProvider);

    // Update light meter notifier with latest dataPoints
    ref.listen(sensorTimeSeriesProvider(SensorType.lightMeter), (
      previous,
      next,
    ) {
      ref.read(lightMeterProvider.notifier).updateFromDataPoints(next);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current Reading Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                      lightMeterData.lightLevelColor,
                    ).withOpacity(0.2),
                    border: Border.all(
                      color: Color(lightMeterData.lightLevelColor),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lightMeterData.lightLevelIcon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lightMeterData.formattedCurrentLux,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(lightMeterData.lightLevelColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lightMeterData.lightLevelDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(lightMeterData.lightLevelColor),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LineChartWidget(
                  dataPoints: dataPoints,
                  title: 'Light Level (lux)',
                  lineColor: Colors.yellow[700]!,
                  maxY: dataPoints.isNotEmpty
                      ? (dataPoints.reduce((a, b) => a > b ? a : b) * 1.2)
                            .clamp(1000, 100000)
                      : 1000,
                  horizontalInterval: 200,
                  leftTitleBuilder: (value) => '${value.toInt()}',
                  height: 160,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> dataPoints;
  final String title;
  final Color lineColor;
  final double maxY;
  final double horizontalInterval;
  final String Function(double y) leftTitleBuilder;
  final double height;

  const LineChartWidget({
    required this.dataPoints,
    required this.title,
    required this.lineColor,
    required this.maxY,
    required this.horizontalInterval,
    required this.leftTitleBuilder,
    this.height = 160,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: height + 32,
          width: double.infinity,
          child: Stack(
            children: [
              // Y-axis labels
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate((maxY ~/ horizontalInterval) + 1, (
                    i,
                  ) {
                    final y = maxY - i * horizontalInterval;
                    return SizedBox(
                      height: height / (maxY / horizontalInterval),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          leftTitleBuilder(y),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Chart
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: CustomPaint(
                  painter: _LineChartPainter(
                    dataPoints,
                    lineColor,
                    maxY,
                    horizontalInterval,
                  ),
                  size: Size(double.infinity, height),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;
  final double maxY;
  final double horizontalInterval; // <-- Add this

  _LineChartPainter(
    this.dataPoints,
    this.color,
    this.maxY,
    this.horizontalInterval,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final dx = size.width / (dataPoints.length - 1);
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * dx;
      final y = size.height - (dataPoints[i] / maxY * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    final intervalCount = (maxY ~/ horizontalInterval);
    for (int i = 0; i <= intervalCount; i++) {
      final y = size.height - (i * horizontalInterval / maxY * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
