import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/presets_provider.dart';

class InitializationService {
  final Ref ref;

  InitializationService(this.ref);

  Future<void> initialize() async {
    try {
      await dotenv.load();
    } catch (e) {
      // TODO: Replace with logger
      // print('No .env file found, continuing without environment variables');
    }

    await Hive.initFlutter();
    await ref.read(hiveServiceProvider).init();

    // Initialize presets after Hive is ready - this is critical
    await _initializePresets();
  }

  Future<void> _initializePresets() async {
    try {
      final notifier = ref.read(presetsInitializationProvider.notifier);

      // Force check initialization status
      await notifier.checkInitialization();
      final currentState = ref.read(presetsInitializationProvider);

      // TODO: Replace with logger
      // print(
      // (print statement commented out)

      // Always try to initialize if not initialized
      if (!currentState.isInitialized) {
        // TODO: Replace with logger
        // print('Initializing presets...');
        await notifier.initializePresets();

        // Verify after initialization
        await notifier.checkInitialization();
        final finalState = ref.read(presetsInitializationProvider);
        // TODO: Replace with logger
        // print(
        // (print statement commented out)

        if (!finalState.isInitialized) {
          throw Exception('Presets failed to initialize after attempt');
        }
      } else {
        // TODO: Replace with logger
        // print('Presets were already initialized');
      }
    } catch (e) {
      // TODO: Replace with logger
      // print('Error in presets initialization: $e');
      // Re-throw to handle in main
      throw Exception('Presets initialization failed: $e');
    }
  }
}

final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
