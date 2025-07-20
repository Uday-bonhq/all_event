import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonSimmer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const SkeletonSimmer(
      {super.key, required this.child, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        key: ValueKey(isLoading),
        enableSwitchAnimation: true,
        justifyMultiLineText: false,
        switchAnimationConfig: const SwitchAnimationConfig(
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.linear,
          transitionBuilder: AnimatedSwitcher.defaultTransitionBuilder,
        ),
        effect: ShimmerEffect(
            duration: const Duration(seconds: 2),
            highlightColor: Colors.white,
            baseColor: Colors.grey.withOpacity(0.3)),
        enabled: isLoading,
        child: child);
  }
}