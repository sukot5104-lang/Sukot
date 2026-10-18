import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Sukot: every feature is free. The Pro upsell / renewal banners that used
/// to render here are intentionally disabled — the widget renders nothing.
/// The class (and its constructor signature) is kept so existing call sites
/// keep compiling without any behavioural changes elsewhere.
class ProBanner extends ConsumerWidget {
  final String? title;

  final double topMargin;

  const ProBanner({super.key, this.title, this.topMargin = 16});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }
}
