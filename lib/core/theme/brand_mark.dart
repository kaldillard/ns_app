import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The app's brand mark - four overlapping olive-green dots in a clover
/// arrangement, matching the reference. Drawn with CustomPainter rather
/// than an image asset so it scales cleanly at any size and its color
/// can be swapped from [AppColors] alone.
class BrandMark extends StatelessWidget {
  final double size;
  final Color color;

  const BrandMark({
    super.key,
    this.size = 40,
    this.color = AppColors.oliveGreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CloverPainter(color: color)),
    );
  }
}

class _CloverPainter extends CustomPainter {
  final Color color;
  const _CloverPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final dotRadius = size.width * 0.24;
    final offset = size.width * 0.26;
    final center = Offset(size.width / 2, size.height / 2);

    final positions = [
      center + Offset(0, -offset), // top
      center + Offset(-offset, 0), // left
      center + Offset(offset, 0), // right
      center + Offset(0, offset), // bottom
    ];

    for (final pos in positions) {
      canvas.drawCircle(pos, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CloverPainter oldDelegate) =>
      oldDelegate.color != color;
}
