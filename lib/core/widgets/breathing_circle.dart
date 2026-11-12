import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A slow, gently expanding/contracting set of concentric rings - the
/// app's signature calming motif, matching the reference's full-screen
/// "Breathe In / Breathe Out" rings. Used as a loading indicator and as
/// decorative hero art. Deliberately slow (4s per breath cycle) with an
/// ease-in-out curve so it never feels urgent or mechanical.
class BreathingCircle extends StatefulWidget {
  final double size;
  final Color color;

  const BreathingCircle({
    super.key,
    this.size = 120,
    this.color = AppColors.oliveGreen,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.72,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _ring(widget.size * _scale.value, 0.14),
              _ring(widget.size * 0.72 * (0.85 + _scale.value * 0.15), 0.22),
              _ring(widget.size * 0.46 * (0.85 + _scale.value * 0.15), 0.34),
            ],
          ),
        );
      },
    );
  }

  Widget _ring(double diameter, double opacity) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color.withValues(alpha: opacity),
      ),
    );
  }
}
