class OnboardingPage {
  final String title;
  final String description;
  final String? riveAsset;
  final String? lottieAsset;
  final List<String>? features;
  final String? ctaText;
  final bool hasInteractiveDemo;

  const OnboardingPage({
    required this.title,
    required this.description,
    this.riveAsset,
    this.lottieAsset,
    this.features,
    this.ctaText,
    this.hasInteractiveDemo = false,
  });
}
