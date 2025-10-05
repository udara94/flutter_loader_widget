import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'dart:math' as math;

import 'package:loader_widget/view.dart';

class NeonLeafLoaderDemo extends StatefulWidget {
  const NeonLeafLoaderDemo({super.key});

  @override
  State<NeonLeafLoaderDemo> createState() => _NeonLeafLoaderDemoState();
}

class _NeonLeafLoaderDemoState extends State<NeonLeafLoaderDemo> {
  double _size = 250.0;
  Duration _duration = const Duration(seconds: 3);
  double _strokeWidth = 3.0;
  List<Color> _neonColors = [
    const Color(0xFF00FFFF), // Cyan
    const Color(0xFF00FF00), // Green
    const Color(0xFFFF00FF), // Magenta
    const Color(0xFFFFD700), // Gold
  ];

  static final examples = <Funvas>[
    ExampleFunvas(),
    WaveFunvas(),
    OrbsFunvas(),
  ];

  final List<List<Color>> _colorPresets = [
    [
      const Color(0xFF00FFFF), // Cyan
      const Color(0xFF00FF00), // Green
      const Color(0xFFFF00FF), // Magenta
      const Color(0xFFFFD700), // Gold
    ],
    [
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFF45B7D1), // Blue
      const Color(0xFF96CEB4), // Mint
    ],
    [
      const Color(0xFFFF9F43), // Orange
      const Color(0xFF6C5CE7), // Purple
      const Color(0xFFA29BFE), // Light Purple
      const Color(0xFFFD79A8), // Pink
    ],
    [
      const Color(0xFF00D2D3), // Cyan
      const Color(0xFFFFE66D), // Yellow
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFFC44569), // Dark Pink
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Neon Leaf Loader'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FunvasViewer(
        funvases: examples,
      ),
    );
  }
}

class ExampleFunvas extends Funvas {
  @override
  void u(double t) {
    c.drawCircle(
      Offset(x.width / 2, x.height / 2),
      S(t).abs() * x.height / 4 + 42,
      Paint()..color = R(C(t) * 255, 42, 60 + T(t)),
    );
  }
}

/// Funvas adapted 1:1 from https://www.dwitter.net/d/3713.
class WaveFunvas extends Funvas {
  @override
  void u(double t) {
    c.scale(x.width / 1920, x.height / 1080);

    for (var i = 0; i < 64; i++) {
      c.drawRect(
        Rect.fromLTWH(
          i * 30.0,
          400 + C(4 * t + (i * 3)) * 100,
          27,
          200,
        ),
        Paint(),
      );
    }
  }
}

/// Funvas adapted 1:1 from https://www.dwitter.net/d/4342.
class OrbsFunvas extends Funvas {
  @override
  void u(double t) {
    c.scale(x.width / 1920, x.height / 1080);

    final v = t + 800;
    for (var q = 500; q > 0; q--) {
      final paint = Paint()..color = R(q, q, q);
      c.drawCircle(
          Offset(
            920 / 2 + C(v - q) * (v + q),
            540 + S(v - q) * (v - q),
          ),
          40,
          paint);
    }
  }
}
