// lib/src/features/home/provider/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/home_notifier.dart';
import '../application/home_state.dart';

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier();
});
