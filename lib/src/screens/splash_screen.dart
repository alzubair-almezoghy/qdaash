import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

class SplashOverlay extends StatefulWidget {
  const SplashOverlay({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<SplashOverlay> createState() => SplashOverlayState();
}

class SplashOverlayState extends State<SplashOverlay>
    with SingleTickerProviderStateMixin {
  static const _logo = AssetImage('assets/brand/gaddash_wallet_logo.png');

  late final AnimationController _entrance;
  late final Animation<double> _scale;
  late final Animation<double> _logoOpacity;
  bool _imageRequested = false;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _dismissing = true);
      }
    });
    final curve = CurvedAnimation(
      parent: _entrance,
      curve: Curves.easeInOutCubic,
    );
    _scale = Tween<double>(begin: .96, end: 1).animate(curve);
    _logoOpacity = curve;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_imageRequested) return;
    _imageRequested = true;
    precacheImage(_logo, context).then((_) {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = math.min(size.width * .88, size.height * .58);
    return AbsorbPointer(
      child: AnimatedOpacity(
        opacity: _dismissing ? 0 : 1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        onEnd: () {
          if (_dismissing) widget.onFinished();
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: MasarColors.splash,
            systemNavigationBarColor: MasarColors.splash,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: MasarColors.splash,
          ),
          child: ColoredBox(
            color: MasarColors.splash,
            child: Center(
              child: FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _scale,
                  child: SizedBox.square(
                    dimension: logoSize,
                    child: const Image(
                      image: _logo,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
