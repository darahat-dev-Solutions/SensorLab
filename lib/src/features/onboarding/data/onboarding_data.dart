// import 'package:flutter/material.dart';
// import 'package:sensorlab/l10n/app_localizations.dart';
// import 'package:sensorlab/src/features/onboarding/domain/entities/onboarding_page.dart';

// class OnboardingData {
//   static List<OnboardingPage> pages(BuildContext context) => [
//     OnboardingPage(
//       title: AppLocalizations.of(context)!.onboardingTitleSuperpowers,
//       description: AppLocalizations.of(context)!.onboardingDescSuperpowers,
//       lottieAsset: 'assets/lottie/superpowers.json',
//     ),
//     OnboardingPage(
//       title: AppLocalizations.of(context)!.onboardingTitleSenseWorld,
//       description: AppLocalizations.of(context)!.onboardingDescSenseWorld,
//       lottieAsset: 'assets/lottie/sense_world.json',
//     ),
//     OnboardingPage(
//       title: AppLocalizations.of(context)!.onboardingTitleLaboratory,
//       description: AppLocalizations.of(context)!.onboardingDescLaboratory,
//       lottieAsset: 'assets/lottie/laboratory.json',
//     ),
//     OnboardingPage(
//       title: AppLocalizations.of(context)!.onboardingTitleDiscovery,
//       description: AppLocalizations.of(context)!.onboardingDescDiscovery,
//       lottieAsset: 'assets/lottie/discovery.json',
//     ),
//   ];
// }
import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/onboarding/domain/entities/onboarding_page.dart';

class OnboardingData {
  static List<OnboardingPage> pages(BuildContext context) => [
    const OnboardingPage(
      title: 'Welcome to Your Sensor Lab! 🚀',
      description:
          'Turn your phone into a powerful science lab. Explore the invisible world of sensors that make your device so smart.',
      lottieAsset: 'assets/lottie/welcome.json',
    ),
    const OnboardingPage(
      title: 'Meet Your Sensors',
      description:
          'Transform your phone into a science lab with motion, light, audio sensors and many more for real-world data analysis.',
    ),
    const OnboardingPage(
      title: 'Design Your Experiments',
      description:
          'Create custom labs by mixing sensors, setting measurement intervals, and choosing data parameters for unlimited experimentation.',
    ),
    const OnboardingPage(
      title: 'Jump Right In',
      description:
          'Not sure where to start? We\'ve got you covered with ready-to-go experiments. Learn the basics, then create your own amazing projects!',
      // lottieAsset: 'assets/lottie/presets.json',
    ),
  ];
}
