import 'dart:math' as math;

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final double maxX;
  final double maxY;
  final double maxZ;
  final double minX;
  final double minY;
  final double minZ;
  final bool isActive;
  final double magnitude;

  const AccelerometerData({
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.maxX = 0,
    this.maxY = 0,
    this.maxZ = 0,
    this.minX = 0,
    this.minY = 0,
    this.minZ = 0,
    this.isActive = false,
    this.magnitude = 0.0,
  });

  AccelerometerData copyWith({
    double? x,
    double? y,
    double? z,
    double? maxX,
    double? maxY,
    double? maxZ,
    double? minX,
    double? minY,
    double? minZ,
    bool? isActive,
    double? magnitude,
  }) {
    return AccelerometerData(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      maxX: maxX ?? this.maxX,
      maxY: maxY ?? this.maxY,
      maxZ: maxZ ?? this.maxZ,
      minX: minX ?? this.minX,
      minY: minY ?? this.minY,
      minZ: minZ ?? this.minZ,
      isActive: isActive ?? this.isActive,
      magnitude: magnitude ?? this.magnitude,
    );
  }

  /// Calculate the magnitude of acceleration vector

  /// Calculate the maximum magnitude recorded
  double get maxMagnitude => math.sqrt(maxX * maxX + maxY * maxY + maxZ * maxZ);
  double get minMagnitude => math.sqrt(minX * minX + minY * minY + minZ * minZ);

  /// Get formatted current values
  String get xFormatted => x.toStringAsFixed(2);
  String get yFormatted => y.toStringAsFixed(2);
  String get zFormatted => z.toStringAsFixed(2);

  /// Get formatted max values
  String get maxXFormatted => maxX.toStringAsFixed(2);
  String get maxYFormatted => maxY.toStringAsFixed(2);
  String get maxZFormatted => maxZ.toStringAsFixed(2);

  /// Get formatted min values
  String get minXFormatted => minX.toStringAsFixed(2);
  String get minYFormatted => minY.toStringAsFixed(2);
  String get minZFormatted => minZ.toStringAsFixed(2);

  /// Get formatted magnitude
  String get magnitudeFormatted => magnitude.toStringAsFixed(2);

  /// Check if device is experiencing significant motion
  bool get hasSignificantMotion =>
      magnitude > 1.0; // Threshold for motion detection

  /// Get motion intensity (0-1 scale)
  double get motionIntensity {
    const maxExpectedAcceleration = 20.0; // m/s²
    return (magnitude / maxExpectedAcceleration).clamp(0.0, 1.0);
  }

  /// Reset max values
  AccelerometerData resetMaxValues() {
    return copyWith(maxX: 0, maxY: 0, maxZ: 0);
  }

  /// Reset min values
  AccelerometerData resetMinValues() {
    return copyWith(minX: 0, minY: 0, minZ: 0);
  }
}

class AccelerometerTriple {
  final double x;
  final double y;
  final double z;
  AccelerometerTriple({required this.x, required this.y, required this.z});
}
