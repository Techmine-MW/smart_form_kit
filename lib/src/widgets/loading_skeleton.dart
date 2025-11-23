import 'package:flutter/material.dart';

class LoadingSkeleton extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const LoadingSkeleton({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  State<LoadingSkeleton> createState() => LoadingSkeletonState();
}

class LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: const Color(0xFFE0E0E0),
      end: const Color(0xFFF5F5F5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _SkeletonAppearance(
          color: _animation.value!,
          child: widget.child,
        );
      },
    );
  }
}

class _SkeletonAppearance extends StatelessWidget {
  final Color color;
  final Widget child;

  const _SkeletonAppearance({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [color, color.withAlpha((0.7 * 255).toInt()), color],
        stops: const [0.0, 0.5, 1.0],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: Opacity(opacity: 0.7, child: child),
    );
  }
}
