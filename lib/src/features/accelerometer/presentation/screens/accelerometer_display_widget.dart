import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/accelerometer/application/providers/accelerometer_provider.dart';
import 'package:sensorlab/src/features/accelerometer/models/accelerometer_data.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class AccelerometerDisplayWidget extends ConsumerWidget {
  const AccelerometerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelData = ref.watch(accelerometerProvider);
    final xyzPoints = ref.watch(accelerometerXYZProvider);
    final linearXyzPoints = ref.watch(linearAccelerometerXYZProvider);

    return DefaultTabController(
      length: 4,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Accelerometer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const TabBar(
                tabs: [
                  Tab(text: 'Vector (g)'),
                  Tab(text: 'Multi-Axis (g)'),
                  Tab(text: 'Vector (no g)'),
                  Tab(text: 'Multi-Axis (no g)'),
                ],
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Live Stats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildStatsPanel(accelData),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Charts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    // Vector chart (magnitude, with gravity)
                    RealtimeLineChart(
                      dataPoints: [accelData.magnitude],
                      title:
                          'Acceleration (with g) (${accelData.magnitudeFormatted} m/s²)',
                      lineColor: Colors.green,
                      minY: -15,
                      maxY: 15,
                      horizontalInterval: 5,
                      leftTitleBuilder: (value) => '${value.toInt()}',
                    ),
                    // Multi-axis chart (X, Y, Z, with gravity)
                    MultiLineChart(
                      xyzPoints: xyzPoints,
                      title: 'Acceleration X/Y/Z (with g)',
                      minY: -15,
                      maxY: 15,
                      horizontalInterval: 5,
                      leftTitleBuilder: (value) => '${value.toInt()}',
                      lineColors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.orange,
                      ],
                    ),
                    // Vector chart (magnitude, without gravity)
                    RealtimeLineChart(
                      dataPoints: linearXyzPoints.isNotEmpty
                          ? linearXyzPoints
                                .map(
                                  (e) => sqrt(
                                    e[0] * e[0] + e[1] * e[1] + e[2] * e[2],
                                  ),
                                )
                                .toList()
                          : [],
                      title: 'Acceleration (no g)',
                      lineColor: Colors.teal,
                      minY: -15,
                      maxY: 15,
                      horizontalInterval: 5,
                      leftTitleBuilder: (value) => '${value.toInt()}',
                    ),
                    // Multi-axis chart (X, Y, Z, without gravity)
                    MultiLineChart(
                      xyzPoints: linearXyzPoints,
                      title: 'Acceleration X/Y/Z (no g)',
                      minY: -15,
                      maxY: 15,
                      horizontalInterval: 5,
                      leftTitleBuilder: (value) => '${value.toInt()}',
                      lineColors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.orange,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsPanel(AccelerometerData data) {
    return Row(
      children: [
        _buildStatCard(
          'Current',
          data.magnitudeFormatted,
          Icons.speed,
          Colors.green,
          tooltip: 'Current acceleration magnitude',
        ),
        _buildStatCard(
          'Max',
          data.maxMagnitude.toStringAsFixed(2),
          Icons.arrow_upward,
          Colors.red,
          tooltip: 'Maximum recorded magnitude',
        ),
        _buildStatCard(
          'Min',
          data.minMagnitude.toStringAsFixed(2),
          Icons.arrow_downward,
          Colors.blue,
          tooltip: 'Minimum recorded magnitude',
        ),
        _buildStatCard(
          'Intensity',
          (data.motionIntensity * 100).toStringAsFixed(0) + '%',
          Icons.bolt,
          Colors.orange,
          tooltip: 'Motion intensity (0-100%)',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Tooltip(
        message: tooltip ?? '',
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// MultiLineChart and _MultiLineChartPainter remain unchanged
// Example MultiLineChart widget
// ...existing code...

class MultiLineChart extends StatelessWidget {
  final List<List<double>> xyzPoints;
  final String title;
  final List<Color> lineColors;
  final double minY;
  final double maxY;
  final double horizontalInterval;
  final String Function(double y) leftTitleBuilder;

  const MultiLineChart({
    required this.xyzPoints,
    required this.title,
    required this.lineColors,
    required this.minY,
    required this.maxY,
    required this.horizontalInterval,
    required this.leftTitleBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (xyzPoints.isEmpty) {
      return const Center(child: Text('No data'));
    }

    // Split into separate lists for X, Y, Z
    final xPoints = xyzPoints.map((e) => e[0]).toList();
    final yPoints = xyzPoints.map((e) => e[1]).toList();
    final zPoints = xyzPoints.map((e) => e[2]).toList();

    // Calculate min/max for each axis
    final xMin = xPoints.reduce((a, b) => a < b ? a : b);
    final xMax = xPoints.reduce((a, b) => a > b ? a : b);
    final yMin = yPoints.reduce((a, b) => a < b ? a : b);
    final yMax = yPoints.reduce((a, b) => a > b ? a : b);
    final zMin = zPoints.reduce((a, b) => a < b ? a : b);
    final zMax = zPoints.reduce((a, b) => a > b ? a : b);

    // Current values (latest)
    final xCurrent = xPoints.last;
    final yCurrent = yPoints.last;
    final zCurrent = zPoints.last;

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
        // Legend with current values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAxisInfo('X', lineColors[0], xCurrent, xMin, xMax),
            _buildAxisInfo('Y', lineColors[1], yCurrent, yMin, yMax),
            _buildAxisInfo('Z', lineColors[2], zCurrent, zMin, zMax),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: CustomPaint(
            painter: _MultiLineChartPainter(
              [xPoints, yPoints, zPoints],
              lineColors,
              minY,
              maxY,
              horizontalInterval,
            ),
            size: const Size(double.infinity, 160),
          ),
        ),
      ],
    );
  }

  Widget _buildAxisInfo(
    String label,
    Color color,
    double current,
    double min,
    double max,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${current.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'Min: ${min.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          'Max: ${max.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}

class _MultiLineChartPainter extends CustomPainter {
  final List<List<double>> lines; // [xPoints, yPoints, zPoints]
  final List<Color> colors;
  final double minY;
  final double maxY;
  final double horizontalInterval;

  _MultiLineChartPainter(
    this.lines,
    this.colors,
    this.minY,
    this.maxY,
    this.horizontalInterval,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    final intervalCount = ((maxY - minY) ~/ horizontalInterval);
    for (int i = 0; i <= intervalCount; i++) {
      final y =
          size.height -
          ((i * horizontalInterval) / (maxY - minY) * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw each axis line
    for (int l = 0; l < lines.length; l++) {
      final points = lines[l];
      if (points.length < 2) continue;
      final paint = Paint()
        ..color = colors[l]
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();
      final dx = size.width / (points.length - 1);
      for (int i = 0; i < points.length; i++) {
        final x = i * dx;
        final y =
            size.height - ((points[i] - minY) / (maxY - minY) * size.height);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// Remove the standalone _buildLegendItem function since we now use _buildAxisInfo

// ...existing _MultiLineChartPainter code...
// ...existing imports...
// Add your linear accelerometer provider import if needed
