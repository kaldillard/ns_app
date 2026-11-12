import 'package:flutter/material.dart';

import 'breathing_circle.dart';

/// Shared loading state, used anywhere an AsyncValue is in `loading`.
/// Uses the breathing circle motif instead of a standard spinner to keep
/// even the app's "in-between" moments feeling calm rather than busy.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: BreathingCircle(size: 72));
  }
}
