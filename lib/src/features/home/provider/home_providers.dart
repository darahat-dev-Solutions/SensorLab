// lib/src/features/home/provider/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/home_notifier.dart';
import '../application/home_state.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier();
});

// Settings provider is used elsewhere in your app. We expose a simple provider that
// maps to HomeState.adsEnabled so UI can react. The actual settings source
// (e.g. settingsControllerProvider) is still the canonical source.
final homeAdsEnabledProvider = Provider<bool>((ref) {
  final state = ref.watch(homeNotifierProvider);
  return state.adsEnabled;
});
