import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/custom_labs_screen/error_labs_state.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/custom_labs_screen/labs_grid_view.dart';

class CustomLabsScreen extends ConsumerWidget {
  const CustomLabsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allLabsAsync = ref.watch(allLabsProvider);

    Widget customLabsSection;
    Widget presetLabsSection;
    if (allLabsAsync.isLoading) {
      customLabsSection = const Center(child: CircularProgressIndicator());
      presetLabsSection = const SizedBox.shrink();
    } else if (allLabsAsync.hasError) {
      customLabsSection = ErrorLabsState(
        error: allLabsAsync.error!,
        onRetry: () => ref.invalidate(allLabsProvider),
      );
      presetLabsSection = const SizedBox.shrink();
    } else if (allLabsAsync.hasValue) {
      final labs = allLabsAsync.value ?? [];
      final customs = labs.where((lab) => !lab.isPreset).toList();
      customs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (customs.isEmpty) {
        customLabsSection = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.noCustomLabsYet,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      } else {
        customLabsSection = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LabsGridView(
            labs: customs,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        );
      }
      final presets = labs.where((lab) => lab.isPreset).toList();
      if (presets.isEmpty) {
        presetLabsSection = const SizedBox.shrink();
      } else {
        presetLabsSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.presetLabs,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LabsGridView(
                labs: presets,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        );
      }
    } else {
      customLabsSection = const SizedBox.shrink();
      presetLabsSection = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customLabs),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: <Widget>[
          // 1. Create New Lab Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => context.pushNamed('create-lab'),
              icon: const Icon(Icons.add),
              label: Text(l10n.newLab),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // 2. My Custom Labs (Quick Access)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.myCustomLabs,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          customLabsSection,

          // 3. Preset Labs (Secondary)
          presetLabsSection,
        ],
      ),
    );
  }
}
