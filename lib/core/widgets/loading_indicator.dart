import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';

/// Animated Sukot loading indicator: a pulsing blue "S" badge wrapped in a
/// spinning gradient arc, with a soft breathing glow and the Sukot wordmark
/// gently fading underneath.
class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeTop = isDark ? AppColors.blue5 : AppColors.blue6;
    final badgeBottom = isDark ? AppColors.blue8 : AppColors.blue10;
    final ringColor = isDark ? AppColors.blue4 : AppColors.blue6;
    final labelColor = isDark ? AppColors.blue5 : AppColors.blue6;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Smooth 0..1..0 "breathing" value.
        final breath =
            0.5 - 0.5 * math.cos(2 * math.pi * _controller.value);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 104.w,
              height: 104.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft breathing glow behind the badge.
                  Container(
                    width: (88 + 14 * breath).w,
                    height: (88 + 14 * breath).w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          ringColor.withOpacity(0.22 - 0.14 * breath),
                          ringColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  // Spinning gradient arc around the badge.
                  RotationTransition(
                    turns: _controller,
                    child: CustomPaint(
                      size: Size(96.w, 96.w),
                      painter: _ArcPainter(color: ringColor),
                    ),
                  ),
                  // Pulsing "S" badge.
                  Transform.scale(
                    scale: 0.92 + 0.08 * breath,
                    child: Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [badgeTop, badgeBottom],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ringColor.withOpacity(0.35),
                            blurRadius: 18,
                            spreadRadius: 1 + 3 * breath,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 34.w,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            // Sukot wordmark gently breathing under the badge.
            Opacity(
              opacity: 0.55 + 0.45 * breath,
              child: Text(
                'Sukot',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 20.w,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  const _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = math.max(2.5, size.shortestSide * 0.035);
    final rect = Offset.zero & size;
    final inset = rect.deflate(stroke);
    final sweep = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [
        color.withOpacity(0.05),
        color,
      ],
    );
    final paint = Paint()
      ..shader = sweep.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(inset, -math.pi / 2, math.pi * 1.45, false, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => oldDelegate.color != color;
}
