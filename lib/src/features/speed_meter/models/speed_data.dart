class SpeedData {
  final double currentSpeed; // m/s
  final double maxSpeed; // m/s
  final double avgSpeed; // m/s
  final double distance; // meters
  final bool isActive;
  final int sampleCount;
  final List<double> speedHistory;

  const SpeedData({
    this.currentSpeed = 0,
    this.maxSpeed = 0,
    this.avgSpeed = 0,
    this.distance = 0,
    this.isActive = false,
    this.sampleCount = 0,
    this.speedHistory = const [],
  });

  // Speed conversions
  double get speedKmh => currentSpeed * 3.6;
  double get speedMph => currentSpeed * 2.23694;
  double get maxSpeedKmh => maxSpeed * 3.6;
  double get maxSpeedMph => maxSpeed * 2.23694;
  double get avgSpeedKmh => avgSpeed * 3.6;
  double get avgSpeedMph => avgSpeed * 2.23694;

  // Distance conversions
  double get distanceKm => distance / 1000.0;
  double get distanceMiles => distance / 1609.34;

  // Formatted strings
  String get speedKmhFormatted => speedKmh.toStringAsFixed(1);
  String get speedMphFormatted => speedMph.toStringAsFixed(1);
  String get maxSpeedKmhFormatted => maxSpeedKmh.toStringAsFixed(1);
  String get maxSpeedMphFormatted => maxSpeedMph.toStringAsFixed(1);
  String get avgSpeedKmhFormatted => avgSpeedKmh.toStringAsFixed(1);
  String get avgSpeedMphFormatted => avgSpeedMph.toStringAsFixed(1);
  String get distanceKmFormatted => distanceKm.toStringAsFixed(2);
  String get distanceMilesFormatted => distanceMiles.toStringAsFixed(2);

  SpeedData copyWith({
    double? currentSpeed,
    double? maxSpeed,
    double? avgSpeed,
    double? distance,
    bool? isActive,
    int? sampleCount,
    List<double>? speedHistory,
  }) {
    return SpeedData(
      currentSpeed: currentSpeed ?? this.currentSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      distance: distance ?? this.distance,
      isActive: isActive ?? this.isActive,
      sampleCount: sampleCount ?? this.sampleCount,
      speedHistory: speedHistory ?? this.speedHistory,
    );
  }

  SpeedData resetStats() => copyWith(
    currentSpeed: 0,
    maxSpeed: 0,
    avgSpeed: 0,
    distance: 0,
    sampleCount: 0,
    speedHistory: [],
  );
}
