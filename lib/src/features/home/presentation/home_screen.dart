import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/custom_labs_screen/error_labs_state.dart';
import 'package:sensorlab/src/features/home/presentation/widgets/custom_lab_card.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';
import 'package:sensorlab/src/shared/widgets/show_interstitial_ad_than_navigate.dart';

import '../../../shared/widgets/sensors.dart';
import '../provider/home_providers.dart';
import 'widgets/modern_app_bar.dart';
import 'widgets/sensor_grid.dart';

// --- Section Headers and Buttons ---
Widget _buildSensorsHeader(
  bool isDark,
  AppLocalizations l10n,
  ThemeData theme,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.sensors_rounded,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              'Available Sensors',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Explore individual sensors for your experiments',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey[500] : Colors.grey[500],
          ),
        ),
      ],
    ),
  );
}

Widget _buildViewAllButton(
  bool isDark,
  ThemeData theme,
  BuildContext context,
  List<Lab> presets,
) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to full preset labs screen
            // context.pushNamed('preset-labs', extra: presets);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All Templates',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

final sensorsProvider = Provider.family<List<SensorCard>, BuildContext>((
  ref,
  context,
) {
  final l10n = AppLocalizations.of(context)!;
  return getSensors(l10n);
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final sensorGridKey = GlobalKey();
  AsyncValue<List<Lab>> get allLabsAsync => ref.watch(allLabsProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sensors = ref.read(sensorsProvider(context));
      ref.read(homeNotifierProvider.notifier).setSensors(sensors);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    ref.read(homeNotifierProvider.notifier).disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeNotifierProvider);
    final sensors = homeState.sensors;

    final allLabsAsync = ref.watch(allLabsProvider);
    // List<Lab> labs = [];
    List<Lab> customs = [];
    // List<Lab> presets = [];

    Widget quickAccessSection;
    Widget presetLabsSection;

    if (allLabsAsync.isLoading) {
      quickAccessSection = _buildQuickAccessShimmer();
      presetLabsSection = const SizedBox.shrink();
    } else if (allLabsAsync.hasError) {
      quickAccessSection = ErrorLabsState(
        error: allLabsAsync.error!,
        onRetry: () => ref.invalidate(allLabsProvider),
      );
      presetLabsSection = const SizedBox.shrink();
    } else if (allLabsAsync.hasValue) {
      final labs = allLabsAsync.value ?? [];
      customs = labs.where((lab) => !lab.isPreset).toList();
      final presets = labs.where((lab) => lab.isPreset).toList();

      customs.sort((a, b) {
        // Sort by createdAt descending, fallback to id
        return b.createdAt.compareTo(a.createdAt);
      });

      // Quick Access Section - Primary Focus

      quickAccessSection = customLabCard(customs, isDark, theme, context);

      // Preset Labs - Secondary/Discovery Section
      if (presets.isEmpty) {
        presetLabsSection = const SizedBox.shrink();
      } else {
        presetLabsSection = _buildPresetLabsSection(
          presets,
          isDark,
          theme,
          context,
          l10n,
        );
      }
    } else {
      quickAccessSection = const SizedBox.shrink();
      presetLabsSection = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0E21)
          : const Color(0xFFF8FAFC),
      floatingActionButton: (customs.isNotEmpty)
          ? FloatingActionButton(
              onPressed: () => context.goNamed('create-lab'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [
          ModernAppBar(isDark: isDark, l10n: l10n, sensorList: sensors),

          // 🎯 PRIMARY FOCUS: Create New Lab - Hero Section
          // if (allLabsAsync.hasValue && customs.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: _buildCreateLabHero(isDark, l10n, context, customs),
          //   ),
          // 🎯 PRIMARY FOCUS: Quick Access Labs
          SliverToBoxAdapter(
            child: _buildQuickAccessHeader(isDark, l10n, theme, allLabsAsync),
          ),
          SliverToBoxAdapter(child: quickAccessSection),

          // 🔍 SECONDARY: Preset Labs (Discovery)
          if (presetLabsSection is! SizedBox)
            SliverToBoxAdapter(child: presetLabsSection),

          // 🔍 SECONDARY: Sensors (Discovery)
          SliverToBoxAdapter(child: _buildSensorsHeader(isDark, l10n, theme)),
          SensorGrid(
            key: sensorGridKey,
            isDark: isDark,
            sensors: sensors,
            selectedIndex: homeState.selectedTabIndex,
            l10n: l10n,
            onSensorTap: (sensor) {
              showInterstitialAdThenNavigate(
                context: context,
                screen: sensor.screen,
                interstitialAd: homeState.interstitialAd,
                adsEnabled: homeState.adsEnabled,
              );
            },
            animationController: _animationController,
            scaleAnimation: _scaleAnimation,
            fadeAnimation: _fadeAnimation,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateLabHero(
    bool isDark,
    AppLocalizations l10n,
    BuildContext context,
    List<Lab> customs,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
              : [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create New Lab',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Build custom experiments with your preferred sensors',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.goNamed('create-lab'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Start Creating',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Icon(
            Icons.science_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessHeader(
    bool isDark,
    AppLocalizations l10n,
    ThemeData theme,
    AsyncValue<List<Lab>> allLabsAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Labs',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              if (allLabsAsync.hasValue)
                Text(
                  'Quick access to your recent experiments',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
            ],
          ),
          if (allLabsAsync.hasValue &&
              (allLabsAsync.value?.isNotEmpty ?? false))
            Text(
              '${allLabsAsync.value!.where((lab) => !lab.isPreset).length} labs',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetLabsSection(
    List<Lab> presets,
    bool isDark,
    ThemeData theme,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    // Group presets by category for better organization
    final presetCategories = _groupPresetsByCategory(presets);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Value Proposition
          _buildSectionHeader(isDark, theme, presets.length),
          const SizedBox(height: 20),
          // Category Tabs for Better Organization
          if (presetCategories.length > 1) ...[
            _buildCategoryTabs(presetCategories, isDark, theme),
            const SizedBox(height: 16),
          ],
          // Featured Preset Labs Grid
          _buildPresetLabsGrid(presetCategories, isDark, theme, context),
          // View All CTA
          if (presets.length > 6) ...[
            const SizedBox(height: 16),
            _buildViewAllButton(isDark, theme, context, presets),
          ],
        ],
      ),
    );
  }

  // Helper method to group presets by category
  Map<String, List<Lab>> _groupPresetsByCategory(List<Lab> presets) {
    final categories = <String, List<Lab>>{};
    for (final preset in presets) {
      // Extract category from description or use default
      final category = _extractCategoryFromLab(preset);
      if (!categories.containsKey(category)) {
        categories[category] = [];
      }
      categories[category]!.add(preset);
    }
    return categories;
  }

  String _extractCategoryFromLab(Lab lab) {
    // You can customize this logic based on your lab data structure
    final description = lab.description.toLowerCase();
    if (description.contains('motion') ||
        description.contains('accelerometer') ||
        description.contains('gyroscope')) {
      return 'Motion & Movement';
    } else if (description.contains('environment') ||
        description.contains('temperature') ||
        description.contains('humidity')) {
      return 'Environment';
    } else if (description.contains('location') ||
        description.contains('gps') ||
        description.contains('compass')) {
      return 'Location & Navigation';
    } else if (description.contains('health') ||
        description.contains('heart') ||
        description.contains('fitness')) {
      return 'Health & Fitness';
    } else {
      return 'General Experiments';
    }
  }

  Widget _buildSectionHeader(bool isDark, ThemeData theme, int presetCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.blue[800]! : Colors.blue[100]!,
        ),
      ),
      child: Row(
        children: [
          // Value Proposition Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 24,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(width: 12),
          // Value Proposition Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Lab Templates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready-to-use experiments crafted by experts. Perfect for learning and quick starts.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Preset Count Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$presetCount templates',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.blue[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(
    Map<String, List<Lab>> categories,
    bool isDark,
    ThemeData theme,
  ) {
    final categoryList = categories.keys.toList();
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          final category = categoryList[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${categories[category]!.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPresetLabsGrid(
    Map<String, List<Lab>> categories,
    bool isDark,
    ThemeData theme,
    BuildContext context,
  ) {
    final allPresets = categories.values
        .expand((list) => list)
        .take(6)
        .toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8, // Adjusted for new card size
      ),
      itemCount: allPresets.length,
      itemBuilder: (context, index) {
        final lab = allPresets[index];
        final category = _extractCategoryFromLab(lab);

        return _PresetLabCard(
          lab: lab,
          category: category,
          isDark: isDark,
          theme: theme,
          onTap: () => context.pushNamed('lab-details', extra: lab),
        );
      },
    );
  }
}

// Top-level helpers for category icon and color
IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Motion & Movement':
      return Icons.directions_run_rounded;
    case 'Environment':
      return Icons.thermostat_rounded;
    case 'Location & Navigation':
      return Icons.explore_rounded;
    case 'Health & Fitness':
      return Icons.monitor_heart_rounded;
    default:
      return Icons.science_rounded;
  }
}

Color getCategoryColor(String category, ThemeData theme) {
  return theme.colorScheme.secondary;
}

// Removed stray code after _PresetLabCard. If you need the sensors header, use _buildSensorsHeader above.

Widget _buildQuickAccessShimmer() {
  return SizedBox(
    height: 160,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300]!.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    ),
  );
}

class _PresetLabCard extends StatelessWidget {
  final Lab lab;
  final String category;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  const _PresetLabCard({
    Key? key,
    required this.lab,
    required this.category,
    required this.isDark,
    required this.theme,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconData = getCategoryIcon(category);
    final color = getCategoryColor(category, theme);

    return Material(
      color: isDark ? Colors.grey[900] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160, // Fixed width to match grid expectations
          height: 200, // Fixed height to prevent overflow
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header - Compact
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4), // Smaller padding
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      iconData,
                      size: 14,
                      color: color,
                    ), // Smaller icon
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 10, // Smaller font
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Lab Name - Compact
              Text(
                lab.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.2,
                  fontSize: 14, // Slightly smaller
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Lab Description - Flexible space
              Expanded(
                child: Text(
                  lab.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.3,
                    fontSize: 11, // Smaller font
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              // CTA Button - Compact
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Try Now',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 10, // Smaller font
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 10,
                      color: color,
                    ), // Smaller icon
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
