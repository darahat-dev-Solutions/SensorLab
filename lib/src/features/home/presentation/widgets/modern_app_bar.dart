import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../../shared/models/sensor_card.dart';
import '../../../../shared/widgets/sensor_search_delegate.dart';

class ModernAppBar extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final List<SensorCard> sensorList;

  const ModernAppBar({
    super.key,
    required this.isDark,
    required this.l10n,
    required this.sensorList,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Clean gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1A1F35), const Color(0xFF0D111F)]
                      : [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Brand focus - Clean SensorLab title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SensorLab',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Personal Laboratory',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Minimal actions - focus remains on content
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Iconsax.search_normal_1,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: SensorSearchDelegate(sensors: sensorList),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
