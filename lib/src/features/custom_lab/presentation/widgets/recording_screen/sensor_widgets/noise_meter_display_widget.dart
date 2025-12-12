import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

// ...existing code...

class NoiseMeterDisplayWidget extends ConsumerWidget {
  const NoiseMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.noiseMeter),
    );
    final noiseMeterData = ref.watch(enhancedNoiseMeterProvider);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Noise Meter Waveform',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            WaveformChart(
              dataPoints: dataPoints,
              lineColor: Colors.red,
              maxY: 120,
              horizontalInterval: 20,
              leftTitleBuilder: (y) => '${y.toInt()} dB',
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}

class WaveformChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color lineColor;
  final double maxY;
  final double horizontalInterval;
  final String Function(double y) leftTitleBuilder;
  final double height;

  const WaveformChart({
    required this.dataPoints,
    required this.lineColor,
    required this.maxY,
    required this.horizontalInterval,
    required this.leftTitleBuilder,
    this.height = 120,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              children: List.generate((maxY ~/ horizontalInterval) + 1, (i) {
                final y = maxY - i * horizontalInterval;
                return SizedBox(
                  height: height / (maxY / horizontalInterval),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      leftTitleBuilder(y),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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
              painter: _WaveformPainter(dataPoints, lineColor, maxY),
              size: Size(double.infinity, height),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;
  final double maxY;

  _WaveformPainter(this.dataPoints, this.color, this.maxY);

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
    final intervalCount = (maxY ~/ 20);
    for (int i = 0; i <= intervalCount; i++) {
      final y = size.height - (i * 20 / maxY * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
