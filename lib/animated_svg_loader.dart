import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class AnimatedSvgLoader extends StatefulWidget {
  final String svgAssetPath;
  final double size;
  final Duration duration;
  final Color? color;
  final bool loop;
  final bool run;

  const AnimatedSvgLoader({
    Key? key,
    required this.svgAssetPath,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
    this.color,
    this.loop = true,
    this.run = true,
  }) : super(key: key);

  @override
  State<AnimatedSvgLoader> createState() => _AnimatedSvgLoaderState();
}

class _AnimatedSvgLoaderState extends State<AnimatedSvgLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.run) {
      if (widget.loop) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedSvgLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.run != oldWidget.run) {
      if (widget.run) {
        if (widget.loop) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SvgPicture.asset(
                widget.svgAssetPath,
                width: widget.size,
                height: widget.size,
                colorFilter: widget.color != null
                    ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Pre-configured SVG loaders for common patterns
class SvgLoaderPresets {
  static const String loadingSpinner = 'assets/svg/loading_spinner.svg';
  static const String geometricLoader = 'assets/svg/geometric_loader.svg';
  static const String waveLoader = 'assets/svg/wave_loader.svg';
  static const String heartLoader = 'assets/svg/heart_loader.svg';
  static const String simpleTest = 'assets/svg/simple_test.svg';
}

/// Convenience widget for common SVG loading patterns
class SvgLoader extends StatelessWidget {
  final SvgLoaderType type;
  final double size;
  final Duration duration;
  final Color? color;
  final bool loop;
  final bool run;

  const SvgLoader({
    Key? key,
    required this.type,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
    this.color,
    this.loop = true,
    this.run = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetPath;
    Color defaultColor;

    switch (type) {
      case SvgLoaderType.spinner:
        assetPath = SvgLoaderPresets.loadingSpinner;
        defaultColor = Colors.cyan;
        break;
      case SvgLoaderType.geometric:
        assetPath = SvgLoaderPresets.geometricLoader;
        defaultColor = Colors.purple;
        break;
      case SvgLoaderType.wave:
        assetPath = SvgLoaderPresets.waveLoader;
        defaultColor = Colors.blue;
        break;
      case SvgLoaderType.heart:
        assetPath = SvgLoaderPresets.heartLoader;
        defaultColor = Colors.pink;
        break;
      case SvgLoaderType.simple:
        assetPath = SvgLoaderPresets.simpleTest;
        defaultColor = Colors.orange;
        break;
    }

    return AnimatedSvgLoader(
      svgAssetPath: assetPath,
      size: size,
      duration: duration,
      color: color ?? defaultColor,
      loop: loop,
      run: run,
    );
  }
}

enum SvgLoaderType { spinner, geometric, wave, heart, simple }
