import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/record_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';

/// Provider for record session use case
final recordSessionUseCaseProvider = Provider<RecordSessionUseCase>((ref) {
  final repository = ref.watch(labRepositoryProvider);
  return RecordSessionUseCase(repository);
});

/// Provider for fetching sessions by lab ID
final labSessionsProvider = FutureProvider.family<List<LabSession>, String>((
  ref,
  labId,
) async {
  final repository = ref.watch(labRepositoryProvider);
  return repository.getSessionsByLabId(labId);
});

/// Provider for fetching data points for a session
final sessionDataPointsProvider =
    FutureProvider.family<List<SensorDataPoint>, String>((
      ref,
      sessionId,
    ) async {
      try {
        final useCase = ref.read(recordSessionUseCaseProvider);
        final dataPoints = await useCase.getSessionDataPoints(sessionId);

        return dataPoints;
      } catch (e) {
        print('Error loading data points: $e');
        rethrow;
      }
    });
// ...existing code...
final sessionByIdProvider = FutureProvider.family<LabSession?, String>((
  ref,
  sessionId,
) async {
  final repo = ref.watch(labRepositoryProvider);
  return await repo.getSessionById(sessionId);
});

/// Provider for the currently active recording session
final recordingSessionProvider = StateProvider<LabSession?>((ref) => null);
// ...existing code...
