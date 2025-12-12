import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';

import '../../models/camera_settings_data.dart';
import '../../models/light_meter_data.dart';
import '../../models/plant_light_data.dart';

/// Enum for light meter modes
enum LightMeterMode { standard, plantAssistant, photoAssistant }

/// State notifier for managing light meter data and operations
class LightMeterNotifier extends StateNotifier<LightMeterData> {
  LightMeterNotifier(this._ref) : super(const LightMeterData());
  final List<double> _allReadings = [];
  final Ref _ref;
  Timer? _plantTrackingTimer;
  final List<LightReading> _plantReadings = [];

  // Plant tracking state
  PlantType? _selectedPlantType;
  DateTime? _plantTrackingStartTime;
  double _accumulatedDLI = 0.0;

  // Current mode
  LightMeterMode _currentMode = LightMeterMode.standard;

  /// Get current mode
  LightMeterMode get currentMode => _currentMode;

  /// Get plant tracking data
  PlantLightData? get plantTrackingData {
    if (_selectedPlantType == null) {
      return null;
    }

    final plantInfo = PlantDatabase.getPlantInfo(_selectedPlantType!);
    return PlantLightData(
      plantType: _selectedPlantType!,
      plantName: plantInfo.name,
      lightRequirement: plantInfo.lightRequirement,
      targetDLI: plantInfo.targetDLI,
      currentDLI: _accumulatedDLI,
      trackingStartTime: _plantTrackingStartTime ?? DateTime.now(),
      readings: _plantReadings,
    );
  }

  /// Get camera settings for current lux
  CameraSettingsData? getCameraSettings() {
    if (state.currentLux == 0) {
      return null;
    }
    return CameraSettingsData.fromLux(state.currentLux);
  }

  /// Update light meter data from sensor dataPoints
  void updateFromDataPoints(List<double> dataPoints) {
    if (dataPoints.isEmpty) {
      return;
    }

    try {
      final currentLux = dataPoints.last; // Latest reading
      final minLux = dataPoints.reduce((a, b) => a < b ? a : b);
      final maxLux = dataPoints.reduce((a, b) => a > b ? a : b);
      final averageLux = dataPoints.isNotEmpty
          ? dataPoints.reduce((a, b) => a + b) / dataPoints.length
          : 0.0;

      // Determine light level
      final lightLevel = LightMeterData.getLightLevel(currentLux);

      // Keep only recent 50 readings for chart
      final recentReadings = dataPoints.length > 50
          ? dataPoints.sublist(dataPoints.length - 50)
          : dataPoints;

      // Update state
      state = state.copyWith(
        currentLux: currentLux,
        minLux: minLux,
        maxLux: maxLux,
        averageLux: averageLux,
        lightLevel: lightLevel,
        recentReadings: recentReadings,
        totalReadings: dataPoints.length,
        isReading: true,
      );

      // Accumulate DLI if plant tracking is active
      if (_selectedPlantType != null) {
        _accumulateDLI();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error processing light data: $e');
    }
  }

  /// Start light measurement
  Future<void> startMeasurement() async {
    try {
      state = state.copyWith(
        isReading: true,
        minLux: double.infinity,
        maxLux: double.negativeInfinity,
        averageLux: 0.0,
        totalReadings: 0,
        recentReadings: [],
      );
    } catch (e) {
      state = state.copyWith(
        isReading: false,
        errorMessage: 'Failed to start light measurement: $e',
      );
    }
  }

  /// Stop light measurement
  void stopMeasurement() {
    state = state.copyWith(isReading: false);
  }

  /// Handle incoming light data
  void _onLightData(int luxValue) {
    if (!mounted) {
      return;
    }

    try {
      // Convert to double for calculations
      double lux = luxValue.toDouble();

      // Ensure reasonable bounds for lux
      lux = lux.clamp(0.0, 100000.0);

      // Add to all readings for average calculation
      _allReadings.add(lux);

      // Calculate statistics
      final newMin = min(
        state.minLux == double.infinity ? lux : state.minLux,
        lux,
      );
      final newMax = max(
        state.maxLux == double.negativeInfinity ? lux : state.maxLux,
        lux,
      );
      final newAverage = _allReadings.isNotEmpty
          ? _allReadings.reduce((a, b) => a + b) / _allReadings.length
          : 0.0;

      // Update recent readings for chart (keep last 50 readings)
      final updatedRecentReadings = List<double>.from(state.recentReadings);
      updatedRecentReadings.add(lux);
      if (updatedRecentReadings.length > 50) {
        updatedRecentReadings.removeAt(0);
      }

      // Determine light level
      final lightLevel = LightMeterData.getLightLevel(lux);

      // Update state
      state = state.copyWith(
        currentLux: lux,
        minLux: newMin,
        maxLux: newMax,
        averageLux: newAverage,
        lightLevel: lightLevel,
        recentReadings: updatedRecentReadings,
        totalReadings: _allReadings.length,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error processing light data: $e');
    }
  }

  /// Handle light reading errors
  void _onLightError(dynamic error) {
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      errorMessage: 'Light measurement error: $error',
      isReading: false,
    );

    // Clean up on error
    stopMeasurement();
  }

  /// Reset all data
  void resetData() {
    stopMeasurement();
    _allReadings.clear();

    state = const LightMeterData();
  }

  /// Toggle measurement (start/stop)
  Future<void> toggleMeasurement() async {
    if (state.isReading) {
      stopMeasurement();
    } else {
      await startMeasurement();
    }
  }

  /// Get a single light reading without starting continuous measurement
  Future<void> getSingleReading() async {
    try {
      // Get a single reading from the stream
      final lightValue = await Light().lightSensorStream.first;
      final lux = lightValue.toDouble();

      final lightLevel = LightMeterData.getLightLevel(lux);

      state = state.copyWith(currentLux: lux, lightLevel: lightLevel);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to get light reading: $e');
    }
  }

  @override
  void dispose() {
    _plantTrackingTimer?.cancel();
    super.dispose();
  }

  // ==================== PLANT ASSISTANT METHODS ====================

  /// Start plant light tracking
  void startPlantTracking(PlantType plantType) {
    _selectedPlantType = plantType;
    _plantTrackingStartTime = DateTime.now();
    _accumulatedDLI = 0.0;
    _plantReadings.clear();
    _currentMode = LightMeterMode.plantAssistant;

    // Start continuous measurement if not already running
    if (!state.isReading) {
      startMeasurement();
    }

    // Start DLI accumulation timer (every 10 seconds)
    _plantTrackingTimer?.cancel();
    _plantTrackingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _accumulateDLI(),
    );
  }

  /// Stop plant tracking
  void stopPlantTracking() {
    _plantTrackingTimer?.cancel();
    _plantTrackingTimer = null;
    _currentMode = LightMeterMode.standard;
  }

  /// Reset plant tracking data
  void resetPlantTracking() {
    _accumulatedDLI = 0.0;
    _plantReadings.clear();
    _plantTrackingStartTime = DateTime.now();
  }

  /// Accumulate DLI from current lux reading
  void _accumulateDLI() {
    if (!mounted || state.currentLux == 0) {
      return;
    }

    // Convert lux to PPFD (μmol/m²/s)
    // Approximate conversion: PPFD ≈ Lux / 54
    final ppfd = state.currentLux / 54.0;

    // Calculate DLI contribution for this interval (10 seconds)
    // DLI = PPFD × time(hours) × 3600 / 1,000,000
    const hours = 10 / 3600.0; // 10 seconds in hours
    final dliContribution = ppfd * hours * 3600 / 1000000;

    _accumulatedDLI += dliContribution;

    // Add reading
    _plantReadings.add(
      LightReading(
        timestamp: DateTime.now(),
        lux: state.currentLux,
        ppfd: ppfd,
      ),
    );

    // Keep only last 100 readings
    if (_plantReadings.length > 100) {
      _plantReadings.removeAt(0);
    }
  }

  /// Get plant recommendations
  List<String> getPlantRecommendations() {
    if (_selectedPlantType == null) {
      return [];
    }

    final plantData = PlantDatabase.getPlantInfo(_selectedPlantType!);
    final currentPPFD = state.currentLux / 54.0;

    final recommendations = <String>[];

    // Convert DLI to average PPFD (assuming 12 hours of light per day)
    // DLI (mol/m²/day) = PPFD (μmol/m²/s) × 43200 (12 hours in seconds) / 1,000,000
    final minPPFD = (plantData.minDLI * 1000000) / 43200;
    final maxPPFD = (plantData.maxDLI * 1000000) / 43200;

    // Check if current light is adequate
    if (currentPPFD < minPPFD) {
      recommendations.add('⚠️ Light level too low for optimal growth');
      recommendations.add('💡 Move plant closer to light source');
      recommendations.add('🔆 Consider adding grow lights');
    } else if (currentPPFD > maxPPFD) {
      recommendations.add('⚠️ Light level too high - risk of leaf burn');
      recommendations.add('☂️ Provide some shade during peak hours');
      recommendations.add('📍 Move plant to less intense location');
    } else {
      recommendations.add('✅ Current light level is ideal');
    }

    // Check DLI progress
    final progress = _accumulatedDLI / plantData.targetDLI * 100;
    if (progress < 50) {
      final remaining = plantData.targetDLI - _accumulatedDLI;
      final hoursNeeded = (remaining / (currentPPFD * 3600 / 1000000)).ceil();
      recommendations.add('⏱️ Needs ~$hoursNeeded more hours of current light');
    }

    return recommendations;
  }

  // ==================== PHOTO ASSISTANT METHODS ====================

  /// Switch to photo assistant mode
  void enablePhotoMode() {
    _currentMode = LightMeterMode.photoAssistant;

    // Start measurement if not running
    if (!state.isReading) {
      startMeasurement();
    }
  }

  /// Switch to standard mode
  void enableStandardMode() {
    _currentMode = LightMeterMode.standard;
  }

  /// Get lighting condition name
  String getLightingCondition() {
    final settings = getCameraSettings();
    return settings?.lightingCondition.name ?? 'Unknown';
  }

  /// Get EV (Exposure Value)
  double getExposureValue() {
    final settings = getCameraSettings();
    if (settings == null) {
      return 0.0;
    }

    // EV = log2(lux / 2.5) for ISO 100
    return log(settings.lux / 2.5) / ln2;
  }
}

final lightMeterProvider =
    StateNotifierProvider<LightMeterNotifier, LightMeterData>(
      (ref) => LightMeterNotifier(ref),
    );
