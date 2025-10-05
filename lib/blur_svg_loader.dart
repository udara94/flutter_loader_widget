import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drawing_animation_plus/drawing_animation_plus.dart';
import 'dart:math';
import 'dart:ui';

class BlurSvgLoader extends StatefulWidget {
  final String svgAssetPath;
  final double size;
  final Duration duration;
  final Color? svgColor;
  final String? loadingText;
  final bool showBlurBackground;
  final double blurIntensity;

  const BlurSvgLoader({
    Key? key,
    required this.svgAssetPath,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
    this.svgColor,
    this.loadingText,
    this.showBlurBackground = true,
    this.blurIntensity = 10.0,
  }) : super(key: key);

  @override
  State<BlurSvgLoader> createState() => _BlurSvgLoaderState();
}

class _BlurSvgLoaderState extends State<BlurSvgLoader>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start fade animation
    _fadeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur background
        if (widget.showBlurBackground)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.blurIntensity,
                sigmaY: widget.blurIntensity,
              ),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

        // Main content
        Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated SVG
                SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: AnimatedDrawing.svg(
                    widget.svgAssetPath,
                    run: true,
                    duration: widget.duration,
                    lineAnimation: LineAnimation.oneByOne,
                    animationCurve: Curves.linear,
                    onFinish: () {
                      // Optional: Handle animation completion
                    },
                  ),
                ),

                // Loading text
                if (widget.loadingText != null) ...[
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          widget.loadingText!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Pre-configured blur SVG loaders
class BlurSvgLoaderPresets {
  static const String loadingSpinner = 'assets/svg/loading_spinner.svg';
  static const String geometricLoader = 'assets/svg/geometric_loader.svg';
  static const String waveLoader = 'assets/svg/wave_loader.svg';
  static const String heartLoader = 'assets/svg/heart_loader.svg';
  static const String simpleTest = 'assets/svg/simple_test.svg';
}

/// Convenience widget for blur SVG loaders
class BlurSvgLoaderWidget extends StatelessWidget {
  final BlurSvgLoaderType type;
  final double size;
  final Duration duration;
  final Color? color;
  final String? loadingText;
  final bool showBlurBackground;
  final double blurIntensity;

  const BlurSvgLoaderWidget({
    Key? key,
    required this.type,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
    this.color,
    this.loadingText,
    this.showBlurBackground = true,
    this.blurIntensity = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetPath;
    Color defaultColor;
    String defaultText;

    switch (type) {
      case BlurSvgLoaderType.spinner:
        assetPath = BlurSvgLoaderPresets.loadingSpinner;
        defaultColor = Colors.cyan;
        defaultText = 'Loading...';
        break;
      case BlurSvgLoaderType.geometric:
        assetPath = BlurSvgLoaderPresets.geometricLoader;
        defaultColor = Colors.purple;
        defaultText = 'Processing...';
        break;
      case BlurSvgLoaderType.wave:
        assetPath = BlurSvgLoaderPresets.waveLoader;
        defaultColor = Colors.blue;
        defaultText = 'Syncing...';
        break;
      case BlurSvgLoaderType.heart:
        assetPath = BlurSvgLoaderPresets.heartLoader;
        defaultColor = Colors.pink;
        defaultText = 'Connecting...';
        break;
      case BlurSvgLoaderType.simple:
        assetPath = BlurSvgLoaderPresets.simpleTest;
        defaultColor = Colors.orange;
        defaultText = 'Working...';
        break;
    }

    return BlurSvgLoader(
      svgAssetPath: assetPath,
      size: size,
      duration: duration,
      svgColor: color ?? defaultColor,
      loadingText: loadingText ?? defaultText,
      showBlurBackground: showBlurBackground,
      blurIntensity: blurIntensity,
    );
  }
}

enum BlurSvgLoaderType { spinner, geometric, wave, heart, simple }
