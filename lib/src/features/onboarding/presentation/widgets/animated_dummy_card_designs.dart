import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/home/presentation/home_screen.dart';
import 'package:sensorlab/src/features/home/presentation/widgets/sensor_grid.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';

class CustomLabCardIcon extends StatefulWidget {
  final ThemeData theme;
  final bool isDark;
  const CustomLabCardIcon({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  State<CustomLabCardIcon> createState() => _CustomLabCardIconState();
}

class _CustomLabCardIconState extends State<CustomLabCardIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late final ThemeData theme;
  late final bool isDark;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Back card - slides from left
                  Transform.translate(
                    offset: Offset(-50 - _slideAnimation.value, -40),
                    child: Opacity(
                      opacity: _opacityAnimation.value * 0.15,
                      child: Container(
                        width: 160,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.theme.colorScheme.onPrimary.withOpacity(
                            0.15,
                          ),
                          border: Border.all(
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Middle card - slides from top
                  Transform.translate(
                    offset: Offset(50, 50 - _slideAnimation.value),
                    child: Opacity(
                      opacity: _opacityAnimation.value * 0.2,
                      child: Container(
                        width: 165,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.theme.colorScheme.onPrimary.withOpacity(
                            0.2,
                          ),
                          border: Border.all(
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Front card - scales in
                  Transform.scale(
                    scale: 0.8 + (_opacityAnimation.value * 0.2),
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: Container(
                          width: 170,
                          height: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(1),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0.95),
                                  theme.colorScheme.primary.withOpacity(0.85),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row (no lab icon, no three-dot)

                                // Lab Name
                                Text(
                                  'My Custom Lab',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 16),

                                // Description (secondary text, smaller font)
                                Text(
                                  'Measure light, Sound, Gyroscope',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary
                                        .withOpacity(0.75),
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const Spacer(),

                                // Footer Section (sensor count only, no icon, no arrow)
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onPrimary
                                            .withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '3 Sensors',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PreSetLabCardIcon extends StatefulWidget {
  final ThemeData theme;
  final bool isDark;
  final Map<String, List<Lab>> categories;
  const PreSetLabCardIcon({
    super.key,
    required this.theme,
    required this.isDark,
    required this.categories,
  });

  @override
  State<PreSetLabCardIcon> createState() => _PreSetLabCardIconState();
}

class _PreSetLabCardIconState extends State<PreSetLabCardIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _staggerAnimation;
  late Animation<double> _cardTiltAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _staggerAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _cardTiltAnimation = Tween<double>(begin: 0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = widget.categories.keys.toList();
    final category = categoryList.isNotEmpty
        ? categoryList.first
        : 'Environment';
    final iconData = getCategoryIcon(category);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Back card - slides from bottom right
                  Transform.translate(
                    offset: Offset(
                      -25 + _staggerAnimation.value * 1,
                      -25 + _staggerAnimation.value * 1,
                    ),
                    child: Transform.rotate(
                      angle: _cardTiltAnimation.value,
                      child: Opacity(
                        opacity: _contentFadeAnimation.value * 0.2,
                        child: Container(
                          width: 160,
                          height: 210,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.2),
                            border: Border.all(
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Middle card - slides from top left
                  Transform.translate(
                    offset: Offset(
                      0 - _staggerAnimation.value * 0.08,
                      0 - _staggerAnimation.value * 0.08,
                    ),
                    child: Transform.rotate(
                      angle: -_cardTiltAnimation.value,
                      child: Opacity(
                        opacity: _contentFadeAnimation.value * 0.2,
                        child: Container(
                          width: 165,
                          height: 205,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.2),
                            border: Border.all(
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Front card - main card with content
                  Transform.translate(
                    offset: const Offset(25, 25),
                    child: Transform.scale(
                      scale: 0.9 + (_contentFadeAnimation.value * 0.1),
                      child: Opacity(
                        opacity: _contentFadeAnimation.value,
                        child: Container(
                          width: 170,
                          height: 210,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.onSecondary,
                            border: Border.all(
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category icon with bounce
                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(
                                    0.6,
                                    0.8,
                                    curve: Curves.elasticOut,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        iconData,
                                        size: 14,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Opacity(
                                        opacity: _contentFadeAnimation.value,
                                        child: Text(
                                          category,
                                          style: widget
                                              .theme
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: widget.isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Title with slide up
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  10 - (_contentFadeAnimation.value * 10),
                                ),
                                child: Opacity(
                                  opacity: _contentFadeAnimation.value,
                                  child: Text(
                                    category,
                                    style: widget.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: widget.isDark
                                              ? Colors.white
                                              : Colors.black87,
                                          height: 1.2,
                                          fontSize: 14,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description with delayed fade
                              Opacity(
                                opacity: _contentFadeAnimation.value,
                                child: Expanded(
                                  child: Text(
                                    'Check Your Surroundings',
                                    style: widget.theme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: widget.isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                          height: 1.3,
                                          fontSize: 11,
                                        ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Button with scale animation
                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(
                                    0.7,
                                    1.0,
                                    curve: Curves.elasticOut,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Try Now',
                                        style: widget.theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: colorScheme.onPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 10,
                                        color: colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SensorCardIcon extends StatefulWidget {
  final ThemeData theme;
  const SensorCardIcon({super.key, required this.theme});

  @override
  State<SensorCardIcon> createState() => _SensorCardIconState();
}

class _SensorCardIconState extends State<SensorCardIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(100, -50), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Right card - slides in with rotation
                  Transform.translate(
                    offset: Offset(
                      50 - _slideAnimation.value.dx * 0.5,
                      -5 - _slideAnimation.value.dy * 0.5,
                    ),
                    child: Transform.rotate(
                      angle: .3 - _rotationAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value * 0.15,
                        child: Container(
                          width: 170,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.colorScheme.onPrimary.withOpacity(
                              0.15,
                            ),
                            border: Border.all(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.3,
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Left card - slides in with opposite rotation
                  Transform.translate(
                    offset: Offset(
                      -45 + _slideAnimation.value.dx * 1,
                      -0 + _slideAnimation.value.dy * 1,
                    ),
                    child: Transform.rotate(
                      angle: -0.3 + _rotationAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value * 0.15,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.colorScheme.onPrimary.withOpacity(
                              0.15,
                            ),
                            border: Border.all(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.3,
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main card - scales and fades in
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: Container(
                          width: 170,
                          height: 210,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.onPrimary.withOpacity(1),
                          ),
                          child: MinimalSensorCard(
                            isDark: true,
                            sensor: SensorCard(
                              icon: Icons.graphic_eq,
                              label: 'Noise Meter',
                              color: Theme.of(context).colorScheme.primary,
                              screen: Container(),
                              category: 'Environment',
                              title: 'Noise Sensor',
                              description: 'Measures ambient noise levels',
                              isDark: true,
                            ),
                            onTap: () {},
                            animationController: _controller,
                            scaleAnimation: _scaleAnimation,
                            fadeAnimation: _fadeAnimation,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmptyCustomLabCardIcon extends StatefulWidget {
  final ThemeData theme;
  const EmptyCustomLabCardIcon({super.key, required this.theme});

  @override
  State<EmptyCustomLabCardIcon> createState() => _EmptyCustomLabCardIconState();
}

class _EmptyCustomLabCardIconState extends State<EmptyCustomLabCardIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => GoRouter.of(context).pushNamed('create-lab'),
          child: Container(
            width: 160,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back card - slides from left
                    Transform.translate(
                      offset: Offset(-20 - _slideAnimation.value, -20),
                      child: Opacity(
                        opacity: _opacityAnimation.value * 0.15,
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.15),
                            border: Border.all(
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Middle card - slides from top
                    Transform.translate(
                      offset: Offset(-10, -10 - _slideAnimation.value),
                      child: Opacity(
                        opacity: _opacityAnimation.value * 0.2,
                        child: Container(
                          width: 115,
                          height: 155,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.theme.colorScheme.onPrimary
                                .withOpacity(0.2),
                            border: Border.all(
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Front card - scales in
                    Transform.scale(
                      scale: 0.8 + (_opacityAnimation.value * 0.2),
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.translate(
                          offset: const Offset(0, 0),

                          child: Container(
                            width: 120,
                            height: 160,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.theme.colorScheme.onPrimary
                                  .withOpacity(1),
                              border: Border.all(
                                color: widget.theme.colorScheme.onPrimary
                                    .withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                // Plus icon centered with scale animation
                                Center(
                                  child: ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(
                                        0.4,
                                        0.8,
                                        curve: Curves.elasticOut,
                                      ),
                                    ),

                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.theme.colorScheme.primary
                                            .withOpacity(0.1),
                                        border: Border.all(
                                          color: widget
                                              .theme
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: widget.theme.colorScheme.primary,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
