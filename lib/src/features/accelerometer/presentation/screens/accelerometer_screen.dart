import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/accelerometer/presentation/screens/accelerometer_display_widget.dart';

import '../../application/providers/accelerometer_provider.dart';

class AccelerometerScreen extends ConsumerWidget {
  const AccelerometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelerometerData = ref.watch(accelerometerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    // Removed unused variable to satisfy analyzer
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accelerometer),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () => ref.read(accelerometerProvider),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const AccelerometerDisplayWidget(),
        ),
      ),
    );
  }
}
