import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:sensorlab/src/features/onboarding/application/onboarding_service.dart';
import 'package:sensorlab/src/features/onboarding/data/onboarding_data.dart';
import 'package:sensorlab/src/features/onboarding/presentation/widgets/animated_dummy_card_designs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingServiceProvider).completeOnboarding();
    final prefs = await SharedPreferences.getInstance();
    final landingShown = prefs.getBool('landing_shown') ?? false;
    if (mounted) {
      if (!landingShown) {
        context.go('/landing');
      } else {
        context.go('/');
      }
    }
  }

  void _goToHome() async {
    await ref.read(onboardingServiceProvider).completeOnboarding();
    context.go('/');
  }

  void _goToCreateLab() async {
    await ref.read(onboardingServiceProvider).completeOnboarding();
    context.go('/custom-labs/create');
  }

  // Updated button labels with more engaging text
  String _getPrimaryLabel(int index) {
    switch (index) {
      case 0:
        return 'Continue Exploring';
      case 1:
        return 'Sounds Good!';
      case 2:
        return 'Next';
      case 3:
        return 'Continue';
      default:
        return 'Continue';
    }
  }

  String _getSecondaryLabel(int index) {
    switch (index) {
      case 0:
        return 'Go To Home';
      case 1:
        return 'Browse All Sensors';
      case 2:
        return 'Create Custom Lab';
      case 3:
        return 'Check All Presets';
      default:
        return 'Skip';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = OnboardingData.pages(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator with step counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentPage + 1} of ${pages.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: _goToHome,
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Animated progress dots
                  Row(
                    children: List.generate(pages.length, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _currentPage >= index
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: _onPageChanged,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return _OnboardingPageContent(
                    title: page.title,
                    description: page.description,
                    lottieAsset: page.lottieAsset,
                    primaryLabel: _getPrimaryLabel(index),
                    primaryAction: index == pages.length - 1
                        ? _completeOnboarding
                        : () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                    secondaryLabel: _getSecondaryLabel(index),
                    secondaryAction: index == 2 ? _goToCreateLab : _goToHome,
                    theme: theme,
                    pageIndex: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  final String title;
  final String description;
  final String? lottieAsset;
  final String primaryLabel;
  final VoidCallback primaryAction;
  final String secondaryLabel;
  final VoidCallback secondaryAction;
  final ThemeData theme;
  final int pageIndex;

  const _OnboardingPageContent({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.primaryLabel,
    required this.primaryAction,
    required this.secondaryLabel,
    required this.secondaryAction,
    required this.theme,
    required this.pageIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced visual section with gradient background
          Container(
            width: 240,
            height: 280,

            child: lottieAsset != null
                ? Lottie.asset(lottieAsset!, height: 180, fit: BoxFit.contain)
                : _buildAlternativeVisual(pageIndex, theme),
          ),

          const SizedBox(height: 48),

          // Title with emoji for personality
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description with improved styling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),

          // Enhanced button section
          Column(
            children: [
              // Primary button with shadow and animation
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FilledButton(
                  onPressed: primaryAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(primaryLabel),
                      if (pageIndex < 3) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Secondary button with subtle styling
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: secondaryAction,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(secondaryLabel),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAlternativeVisual(int pageIndex, ThemeData theme) {
    // Custom visual elements instead of icons
    return switch (pageIndex) {
      1 => SensorCardIcon(theme: theme), // Remove sensor grid for page 2
      2 => CustomLabCardIcon(theme: theme, isDark: true),
      3 => PreSetLabCardIcon(theme: theme, isDark: true, categories: {}),
      _ => Container(), // Fallback
    };
  }

  Widget _buildSensorGrid(ThemeData theme) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildSensorChip('Motion', Icons.vibration, theme),
        _buildSensorChip('Light', Icons.lightbulb, theme),
        _buildSensorChip('Sound', Icons.mic, theme),
        _buildSensorChip('More+', Icons.add, theme),
      ],
    );
  }

  Widget _buildSensorChip(String label, IconData icon, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabCreationVisual(ThemeData theme) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              Iconsax.cpu,
              size: 40,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Icon(
              Iconsax.chart_2,
              size: 32,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container matching your card design
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.additem,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // "Create Lab" text
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'CREATE LAB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsVisual(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPresetCard('Fitness', theme),
        const SizedBox(width: 8),
        _buildPresetCard('Science', theme),
        const SizedBox(width: 8),
        _buildPresetCard('Fun', theme),
      ],
    );
  }

  Widget _buildPresetCard(String label, ThemeData theme) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
