import 'dart:io';

import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Use case for exporting recording sessions to CSV
class ExportSessionUseCase {
  final LabRepository _repository;

  ExportSessionUseCase(this._repository);

  /// Export a session to CSV file
  Future<String> exportToCSV(String sessionId) async {
    AppLogger.log('📋 [ExportUseCase] Starting export for session: $sessionId');

    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      AppLogger.log(
        '❌ [ExportUseCase] Session not found: $sessionId',
        level: LogLevel.error,
      );
      throw Exception('Session not found: $sessionId');
    }

    AppLogger.log('✅ [ExportUseCase] Session found: $sessionId');
    AppLogger.log(
      '   Lab name: ${session.labName}, Duration: ${session.duration}s, Data points count: ${session.dataPointsCount}',
    );

    // Get the data points for the session
    AppLogger.log(
      '📊 [ExportUseCase] Fetching data points for session: $sessionId',
    );
    final dataPoints = await _repository.getSensorDataPoints(sessionId);
    AppLogger.log(
      '📊 [ExportUseCase] Retrieved ${dataPoints.length} data points',
    );

    if (dataPoints.isEmpty) {
      AppLogger.log(
        '⚠️ [ExportUseCase] No data points found for session $sessionId',
        level: LogLevel.warning,
      );
    } else {
      AppLogger.log(
        '   First data point keys: ${dataPoints.first.keys.toList()}',
        level: LogLevel.debug,
      );
    }

    AppLogger.log('💾 [ExportUseCase] Calling repository to export to CSV');
    final csvPath = await _repository.exportSessionToCSV(sessionId, dataPoints);
    AppLogger.log('✅ [ExportUseCase] CSV exported to: $csvPath');

    // Update session with export path
    final updatedSession = session.copyWith(exportPath: csvPath);
    await _repository.updateSession(updatedSession);
    AppLogger.log('✅ [ExportUseCase] Session updated with export path');

    return csvPath;
  }

  /// Export a session and return the file path for sharing
  /// (UI layer can use share_plus or other sharing mechanism)
  Future<String> exportForSharing(String sessionId) async {
    final csvPath = await exportToCSV(sessionId);
    final file = File(csvPath);

    if (!await file.exists()) {
      throw Exception('Exported file not found');
    }

    return csvPath;
  }

  /// Get the export path for a session (if already exported)
  Future<String?> getExportPath(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    return session?.exportPath;
  }

  /// Check if a session has been exported
  Future<bool> isSessionExported(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      return false;
    }

    if (session.exportPath == null) {
      return false;
    }

    // Check if file still exists
    final file = File(session.exportPath!);
    return await file.exists();
  }

  /// Delete exported CSV file
  Future<void> deleteExportedFile(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null || session.exportPath == null) {
      return;
    }

    final file = File(session.exportPath!);
    if (await file.exists()) {
      await file.delete();
    }

    // Update session to remove export path
    final updatedSession = session.copyWith(exportPath: null);
    await _repository.updateSession(updatedSession);
  }

  /// Exports multiple sessions to a single file (e.g., Excel with multiple sheets).
  Future<String> exportMultipleForSharing(
    String labId,
    List<String> sessionIds,
  ) async {
    AppLogger.log(
      '📦 [ExportUseCase] Starting multi-session export. Lab: $labId, sessions: ${sessionIds.length}',
    );

    final lab = await _repository.getLabById(labId);

    if (lab == null) {
      throw Exception('Lab not found: $labId');
    }

    final Map<String, List<Map<String, dynamic>>> sessionsData = {};

    for (final sessionId in sessionIds) {
      AppLogger.log(
        '📊 [ExportUseCase] Collecting data points for session: $sessionId',
      );
      final dataPoints = await _repository.getSensorDataPoints(sessionId);
      AppLogger.log(
        '📊 [ExportUseCase] Session $sessionId has ${dataPoints.length} data points',
      );
      sessionsData[sessionId] = dataPoints;
    }

    final nonEmptyCount = sessionsData.values.where((v) => v.isNotEmpty).length;
    AppLogger.log(
      '🧮 [ExportUseCase] Completed collection. Non-empty sessions: $nonEmptyCount / ${sessionsData.length}',
    );
    if (nonEmptyCount == 0) {
      AppLogger.log(
        '⚠️ [ExportUseCase] No data points in selected sessions. Aborting export.',
        level: LogLevel.warning,
      );
      throw Exception('No data points to export in selected sessions');
    }

    AppLogger.log(
      '💾 [ExportUseCase] Invoking repository to build multi-session file',
    );

    final filePath = await _repository.exportMultipleSessionsToFile(
      lab.name,
      sessionsData,
    );
    AppLogger.log('✅ [ExportUseCase] Multi-session export complete: $filePath');
    return filePath;
  }
}
