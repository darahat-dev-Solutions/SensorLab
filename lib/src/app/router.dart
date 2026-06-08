import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
// Sensor Screens
import '../features/accelerometer/presentation/screens/accelerometer_screen.dart';
import '../features/altimeter/presentation/screens/altimeter_screen.dart';
import '../features/app_settings/presentation/pages/settings_page.dart';
import '../features/barometer/presentation/screens/barometer_screen.dart';
import '../features/compass/presentation/screens/compass_screen.dart';
// Custom Lab
import '../features/custom_lab/domain/entities/lab.dart';
import '../features/custom_lab/presentation/screens/create_lab_screen.dart';
import '../features/custom_lab/presentation/screens/custom_labs_screen.dart';
import '../features/custom_lab/presentation/screens/lab_detail_screen.dart';
import '../features/custom_lab/presentation/screens/recording_screen.dart';
import '../features/custom_lab/presentation/screens/session_detail_screen.dart';
import '../features/custom_lab/presentation/screens/session_history_screen.dart';
import '../features/geolocator/presentation/screens/geolocator_screen.dart';
import '../features/gyroscope/presentation/screens/gyroscope_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/landing_page.dart';
import '../features/humidity/presentation/screens/humidity_screen.dart';
import '../features/light_meter/presentation/screens/light_meter_screen.dart';
import '../features/magnetometer/presentation/screens/magnetometer_screen.dart';
import '../features/noise_meter/domain/entities/acoustic_report_entity.dart';
import '../features/noise_meter/presentation/screens/acoustic_monitoring_screen.dart';
import '../features/noise_meter/presentation/screens/acoustic_preset_selection_screen.dart';
import '../features/noise_meter/presentation/screens/acoustic_report_detail_screen.dart';
import '../features/noise_meter/presentation/screens/acoustic_reports_list_screen.dart';
import '../features/noise_meter/presentation/screens/custom_preset_creation_screen.dart';
import '../features/noise_meter/presentation/screens/noise_meter_screen.dart';
// Shared / Onboarding / Settings / Home / Splash
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
// Scanner

import '../features/speed_meter/presentation/screens/speed_meter_screen.dart';
import '../features/vibration_meter/presentation/screens/vibration_meter_screen.dart';
import '../shared/presentation/screens/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pageNotFound)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(l10n.pageNotFoundMessage(state.uri.toString())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.goHome),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      // Splash & Onboarding
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Home
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // === Sensor Routes ===
      GoRoute(
        path: '/altimeter',
        name: 'altimeter',
        builder: (c, s) => const AltimeterScreen(),
      ),
      GoRoute(
        path: '/barometer',
        name: 'barometer',
        builder: (c, s) => const BarometerScreen(),
      ),
      GoRoute(
        path: '/accelerometer',
        name: 'accelerometer',
        builder: (c, s) => const AccelerometerScreen(),
      ),
      GoRoute(
        path: '/compass',
        name: 'compass',
        builder: (c, s) => const CompassScreen(),
      ),

      GoRoute(
        path: '/geolocator',
        name: 'geolocator',
        builder: (c, s) => const GeolocatorPage(),
      ),
      GoRoute(
        path: '/gyroscope',
        name: 'gyroscope',
        builder: (c, s) => const GyroscopeScreen(),
      ),
      GoRoute(
        path: '/humidity',
        name: 'humidity',
        builder: (c, s) => const HumidityScreen(),
      ),
      GoRoute(
        path: '/light-meter',
        name: 'light-meter',
        builder: (c, s) => const LightMeterScreen(),
      ),
      GoRoute(
        path: '/magnetometer',
        name: 'magnetometer',
        builder: (c, s) => const MagnetometerScreen(),
      ),

      GoRoute(
        path: '/speed-meter',
        name: 'speed-meter',
        builder: (c, s) => const SpeedMeterScreen(),
      ),
      GoRoute(
        path: '/vibration-meter',
        name: 'vibration-meter',
        builder: (c, s) => const VibrationMeterScreen(),
      ),

      // === Noise Meter Routes ===
      GoRoute(
        path: '/noise-meter',
        name: 'noise-meter',
        builder: (c, s) => const NoiseMeterScreen(),
        routes: [
          GoRoute(
            path: 'custom-preset',
            name: 'custom-preset-creation',
            builder: (c, s) => const CustomPresetCreationScreen(),
          ),
          GoRoute(
            path: 'reports',
            name: 'acoustic-reports-list',
            builder: (c, s) => const AcousticReportsListScreen(),
          ),
          GoRoute(
            path: 'report-detail',
            name: 'acoustic-report-detail',
            builder: (c, s) => AcousticReportDetailScreen(
              report: AcousticReport(
                id: '',
                startTime: DateTime.now(),
                endTime: DateTime.now(),
                duration: const Duration(),
                preset: RecordingPreset.custom,
                averageDecibels: 0,
                minDecibels: 0,
                maxDecibels: 0,
                events: const [],
                timeInLevels: const {},
                hourlyAverages: const [],
                environmentQuality: '',
                recommendation: '',
                qualityScore: 0,
                interruptionCount: 0,
              ),
            ),
          ),
          GoRoute(
            path: 'preset-selection',
            name: 'acoustic-preset-selection',
            builder: (c, s) => const AcousticPresetSelectionScreen(),
          ),
          GoRoute(
            path: 'monitoring',
            name: 'acoustic-monitoring',
            builder: (c, s) =>
                const AcousticMonitoringScreen(preset: RecordingPreset.custom),
          ),
        ],
      ),

      // === Custom Labs ===
      GoRoute(
        path: '/custom-labs',
        name: 'custom-labs',
        builder: (c, s) => const CustomLabsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create-lab',
            builder: (c, s) => CreateLabScreen(labToEdit: s.extra as Lab?),
          ),
          GoRoute(
            path: 'lab/:labId',
            name: 'lab-details',
            builder: (c, s) {
              final labId = s.pathParameters['labId']!;
              return LabDetailScreen(labId: labId);
            },
            routes: [
              GoRoute(
                path: 'record',
                name: 'lab-recording',
                builder: (c, s) {
                  final lab = s.extra as Lab?;
                  if (lab != null) {
                    return RecordingScreen(lab: lab);
                  }
                  final labId = s.pathParameters['labId']!;
                  // Fallback: create empty lab if not passed
                  return RecordingScreen(
                    lab: Lab(
                      id: labId,
                      name: '',
                      description: '',
                      sensors: const [],
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'sessions',
                name: 'lab-session-history',
                builder: (c, s) {
                  final labId = s.pathParameters['labId']!;
                  return SessionHistoryScreen(
                    lab: Lab(
                      id: labId,
                      name: '',
                      description: '',
                      sensors: const [],
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':sessionId',
                    name: 'lab-session-detail',
                    builder: (c, s) {
                      final sessionId = s.pathParameters['sessionId']!;
                      return SessionDetailScreen(sessionId: sessionId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
