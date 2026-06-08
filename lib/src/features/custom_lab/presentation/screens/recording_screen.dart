import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_monitoring_notifier.dart';
import 'package:sensorlab/src/features/custom_lab/application/state/lab_monitoring_state.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/widgets_index.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  final Lab lab;
  const RecordingScreen({super.key, required this.lab});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  Future<bool?> _showExitConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopRecordingQuestion),
        content: Text(l10n.stopRecordingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.continueRecordingAction),
          ),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(labMonitoringNotifierProvider.notifier)
                  .stopSession();
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.stopAndSave),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monitoringState = ref.watch(labMonitoringNotifierProvider);

    ref.listen<LabMonitoringState>(labMonitoringNotifierProvider, (
      previous,
      next,
    ) {
      if (previous?.activeLab == null && next.activeLab != null) {
        // Session started
      }
    });

    if (!monitoringState.isRecording &&
        !monitoringState.isPaused &&
        monitoringState.activeLab == null) {
      Future.microtask(() {
        ref
            .read(labMonitoringNotifierProvider.notifier)
            .startSession(lab: widget.lab);
        if (widget.lab.sensors.contains(SensorType.gps)) {
          ref.read(geolocatorProvider.notifier).initialize();
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if (monitoringState.isRecording || monitoringState.isPaused) {
          final shouldExit = await _showExitConfirmation(context);
          return shouldExit ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lab.name),
          actions: [
            if (monitoringState.activeSession != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.dataPoints(
                      monitoringState.activeSession!.dataPointsCount,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: LabMonitoringContent(lab: widget.lab),
      ),
    );
  }
}
