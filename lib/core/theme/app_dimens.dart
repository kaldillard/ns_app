import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared spacing and radius tokens for the Serene Pulse interface.
class AppDimens {
  AppDimens._();

  static const double radiusSmall = 14;
  static const double radiusMedium = 20;
  static const double radiusLarge = 28;
  static const double radiusXL = 32;
  static const double radiusPill = 999;

  static const double spaceXs = 6;
  static const double spaceSm = 12;
  static const double spaceMd = 20;
  static const double spaceLg = 32;
  static const double spaceXl = 48;
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
    BoxShadow(
      color: AppColors.onSurface.withValues(alpha: 0.08),
      blurRadius: 22,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get softTight => [
    BoxShadow(
      color: AppColors.onSurface.withValues(alpha: 0.06),
      blurRadius: 14,
      offset: const Offset(0, 10),
    ),
  ];
}
