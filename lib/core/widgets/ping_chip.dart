import 'package:flutter/material.dart';

import '../common/app_colors.dart';

/// Rounded latency badge shown next to servers: a small colored dot plus the
/// probe round-trip time in milliseconds. Uses real probe data from the core
/// (Server.selectionHistory.lastSuccessDelayMs) — no fake numbers.
///
/// Color scale:
///   <= 100 ms  green   (great)
///   <= 250 ms  yellow  (okay)
///   >  250 ms  red     (slow)
///   unreachable      red with a dash
class PingChip extends StatelessWidget {
  final int? delayMs;

  /// True when the server has sustained probe failures — renders a red dash.
  final bool unreachable;

  const PingChip({super.key, this.delayMs, this.unreachable = false});

  @override
  Widget build(BuildContext context) {
    if (unreachable) {
      return _chip(context, _pingColor(999), '—');
    }
    final ms = delayMs;
    if (ms == null || ms <= 0) {
      // No probe data yet — show nothing rather than a made-up value.
      return const SizedBox.shrink();
    }
    return _chip(context, _pingColor(ms), '$ms ms');
  }

  Widget _chip(BuildContext context, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Color _pingColor(int ms) {
    if (ms <= 100) return AppColors.green6;
    if (ms <= 250) return AppColors.yellow4;
    return AppColors.red5;
  }
}

/// Resolves the ping for a server model. Convenience so list rows and the
/// home card share one rule set.
PingChip? pingChipFor({
  required BuildContext context,
  int? lastSuccessDelayMs,
  required bool isProbedUnreachable,
  required bool isAwaitingProbe,
}) {
  if (isProbedUnreachable) {
    return PingChip(delayMs: null, unreachable: true);
  }
  if (isAwaitingProbe || (lastSuccessDelayMs ?? 0) <= 0) {
    return null;
  }
  return PingChip(delayMs: lastSuccessDelayMs);
}
