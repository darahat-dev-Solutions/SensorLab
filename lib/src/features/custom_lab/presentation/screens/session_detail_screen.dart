import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/export_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({required this.sessionId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final exportState = ref.watch(exportProvider);
    final sessionAsync = ref.watch(sessionByIdProvider(sessionId));
    final dataPointsAsync = ref.watch(sessionDataPointsProvider(sessionId));

    return sessionAsync.when(
      data: (session) {
        if (session == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.sessionDetailsTitle)),
            body: Center(child: Text(l10n.sessionNotYetExported)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.sessionDetailsTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: exportState.isExporting
                    ? null
                    : () => _exportAndShare(context, ref, session),
                tooltip: l10n.exportAndShare,
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, session);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(l10n.deleteSession),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Lab name
              Text(
                session.labName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Status badge
              _buildStatusBadge(theme, session),
              const SizedBox(height: 24),

              // Time info
              _buildInfoSection(theme, l10n.recordingTime, [
                _buildInfoRow(
                  theme,
                  Icons.play_arrow,
                  l10n.startTime,
                  DateFormat('MMM d, y • HH:mm:ss').format(session.startTime),
                ),
                if (session.endTime != null)
                  _buildInfoRow(
                    theme,
                    Icons.stop,
                    l10n.endTime,
                    DateFormat('MMM d, y • HH:mm:ss').format(session.endTime!),
                  ),
                _buildInfoRow(
                  theme,
                  Icons.timer,
                  l10n.duration,
                  _formatDuration(session.duration),
                ),
              ]),
              const SizedBox(height: 16),

              // Data info
              _buildInfoSection(theme, l10n.recordingData, [
                _buildInfoRow(
                  theme,
                  Icons.show_chart,
                  l10n.dataPointsCount,
                  '${session.dataPointsCount}',
                ),
                _buildInfoRow(
                  theme,
                  Icons.sensors,
                  l10n.sensorsUsed,
                  '${session.sensorTypes.length}',
                ),
              ]),
              const SizedBox(height: 16),

              // Sensors list
              _buildInfoSection(theme, l10n.sensors, [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: session.sensorTypes.map((sensorType) {
                    return Chip(
                      avatar: Icon(_getSensorIcon(sensorType), size: 18),
                      label: Text(
                        sensorType.name.replaceAll('_', ' ').toUpperCase(),
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
              ]),
              const SizedBox(height: 16),

              // Notes
              if (session.notes != null && session.notes!.isNotEmpty)
                _buildInfoSection(theme, l10n.notes, [
                  Text(session.notes!, style: theme.textTheme.bodyMedium),
                ]),

              const SizedBox(height: 16),

              // Export status
              _buildInfoSection(theme, l10n.export, [
                Consumer(
                  builder: (context, ref, child) {
                    final isExportedAsync = ref.watch(
                      isSessionExportedProvider(session.id),
                    );
                    return isExportedAsync.when(
                      data: (isExported) {
                        if (isExported) {
                          return Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.sessionExportedToCSV,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          );
                        }
                        return Text(
                          l10n.sessionNotYetExported,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => Text(l10n.errorCheckingExportStatus),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 16),

              // Data points preview
              _buildInfoSection(theme, l10n.dataPreview, [
                dataPointsAsync.when(
                  data: (dataPoints) {
                    if (dataPoints.isEmpty) {
                      return Text(
                        l10n.noDataPointsRecorded,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      );
                    }

                    final preview = dataPoints.take(5).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.showingDataPoints(
                            preview.length,
                            dataPoints.length,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...preview.map((point) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${l10n.pointNumber} #${point.sequenceNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          'HH:mm:ss.SSS',
                                        ).format(point.timestamp),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatSensorValues(point.sensorValues),
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text(
                    l10n.errorLoadingDataPoints(error.toString()),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              // Export button
              FilledButton.icon(
                onPressed: exportState.isExporting
                    ? null
                    : () => _exportSession(context, ref, session),
                icon: exportState.isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  exportState.isExporting
                      ? l10n.exportingStatus
                      : l10n.exportToCSV,
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(l10n.errorLoadingSessions))),
    );
  }

  // 🟢 Helper Methods
  Widget _buildStatusBadge(ThemeData theme, LabSession session) {
    Color color;
    IconData icon;
    String label;
    switch (session.status) {
      case RecordingStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'COMPLETED';
        break;
      case RecordingStatus.recording:
        color = Colors.red;
        icon = Icons.fiber_manual_record;
        label = 'RECORDING';
        break;
      case RecordingStatus.paused:
        color = Colors.orange;
        icon = Icons.pause;
        label = 'PAUSED';
        break;
      case RecordingStatus.failed:
        color = Colors.red.shade900;
        icon = Icons.error;
        label = 'FAILED';
        break;
      case RecordingStatus.idle:
        color = Colors.grey;
        icon = Icons.circle;
        label = 'IDLE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    ThemeData theme,
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);

    if (h > 0) return '$h hr ${m} min';
    if (m > 0) return '$m min $s sec';
    return '$s sec';
  }

  String _formatSensorValues(Map<SensorType, dynamic> values) {
    return values.entries
        .map((entry) {
          final value = entry.value;
          if (value is Map) {
            final formatted = value.entries
                .map((e) => '${e.key}: ${_formatNumber(e.value)}')
                .join(', ');
            return '${entry.key.name}: {$formatted}';
          }
          return '${entry.key.name}: ${_formatNumber(value)}';
        })
        .join('\n');
  }

  String _formatNumber(dynamic value) =>
      value is num ? value.toStringAsFixed(2) : value.toString();

  IconData _getSensorIcon(SensorType sensorType) {
    switch (sensorType) {
      case SensorType.accelerometer:
        return Icons.speed;
      case SensorType.gyroscope:
        return Icons.screen_rotation;
      case SensorType.magnetometer:
        return Icons.explore;
      case SensorType.lightMeter:
        return Icons.light_mode;
      case SensorType.noiseMeter:
        return Icons.volume_up;
      case SensorType.gps:
        return Icons.location_on;
      case SensorType.proximity:
        return Icons.phonelink_ring;
      case SensorType.temperature:
        return Icons.thermostat;
      case SensorType.humidity:
        return Icons.water_drop;
      case SensorType.compass:
        return Icons.compass_calibration;
      case SensorType.altimeter:
        return Icons.terrain;
      case SensorType.speedMeter:
        return Icons.speed;
    }
  }

  Future<void> _exportSession(
    BuildContext context,
    WidgetRef ref,
    LabSession session,
  ) async {
    final notifier = ref.read(exportProvider.notifier);
    final csvPath = await notifier.exportSession(session.id);
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          csvPath != null
              ? l10n.exportedTo(csvPath)
              : l10n.failedToExportSession,
        ),
        backgroundColor: csvPath != null ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _exportAndShare(
    BuildContext context,
    WidgetRef ref,
    LabSession session,
  ) async {
    final notifier = ref.read(exportProvider.notifier);
    final csvPath = await notifier.exportForSharing(session.id);
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          csvPath != null
              ? '${l10n.exportedTo(csvPath)}\n${l10n.sharingNotYetImplemented}'
              : l10n.failedToExportSession,
        ),
        backgroundColor: csvPath != null ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    LabSession session,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSession),
        content: Text(l10n.deleteSessionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final useCase = ref.read(recordSessionUseCaseProvider);
      await useCase.deleteSession(session.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sessionDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
