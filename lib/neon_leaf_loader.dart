import 'dart:math';
import 'package:flutter/material.dart';

class NeonLeafLoader extends StatefulWidget {
  final double size;
  final Duration duration;
  final List<Color> neonColors;
  final double strokeWidth;

  const NeonLeafLoader({
    super.key,
    this.size = 200.0,
    this.duration = const Duration(seconds: 3),
    this.neonColors = const [
      Color(0xFF00FFFF), // Cyan
      Color(0xFF00FF00), // Green
      Color(0xFFFF00FF), // Magenta
      Color(0xFFFFD700), // Gold
    ],
    this.strokeWidth = 3.0,
  });

  @override
  State<NeonLeafLoader> createState() => _NeonLeafLoaderState();
}

class _NeonLeafLoaderState extends State<NeonLeafLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
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
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: NeonLeafPainter(
              animationValue: _animation.value,
              neonColors: widget.neonColors,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class NeonLeafPainter extends CustomPainter {
  final double animationValue;
  final List<Color> neonColors;
  final double strokeWidth;

  NeonLeafPainter({
    required this.animationValue,
    required this.neonColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = min(size.width, size.height) / 200.0;

    // Define leaf skeleton paths (bottom to top order)
    final leafPaths = _getLeafPaths(centerX, centerY, scale);

    // Draw each path with neon effect
    for (int i = 0; i < leafPaths.length; i++) {
      final path = leafPaths[i];
      final colorIndex = i % neonColors.length;
      final color = neonColors[colorIndex];

      // Calculate animation progress for this path (staggered from bottom)
      final pathProgress = _calculatePathProgress(i, leafPaths.length);

      if (animationValue >= pathProgress) {
        _drawNeonPath(canvas, path, color, strokeWidth);
      }
    }
  }

  List<Path> _getLeafPaths(double centerX, double centerY, double scale) {
    final paths = <Path>[];

    // Main stem (bottom to top)
    final stemPath = Path();
    stemPath.moveTo(centerX, centerY + 80 * scale);
    stemPath.lineTo(centerX, centerY - 80 * scale);
    paths.add(stemPath);

    // Left side veins (bottom to top)
    final leftVeins = [
      [
        centerX,
        centerY + 60 * scale,
        centerX - 40 * scale,
        centerY + 50 * scale,
      ],
      [
        centerX,
        centerY + 30 * scale,
        centerX - 45 * scale,
        centerY + 20 * scale,
      ],
      [centerX, centerY, centerX - 50 * scale, centerY - 10 * scale],
      [
        centerX,
        centerY - 30 * scale,
        centerX - 55 * scale,
        centerY - 40 * scale,
      ],
      [
        centerX,
        centerY - 60 * scale,
        centerX - 60 * scale,
        centerY - 70 * scale,
      ],
    ];

    for (final vein in leftVeins) {
      final path = Path();
      path.moveTo(vein[0], vein[1]);
      path.lineTo(vein[2], vein[3]);
      paths.add(path);
    }

    // Right side veins (bottom to top)
    final rightVeins = [
      [
        centerX,
        centerY + 60 * scale,
        centerX + 40 * scale,
        centerY + 50 * scale,
      ],
      [
        centerX,
        centerY + 30 * scale,
        centerX + 45 * scale,
        centerY + 20 * scale,
      ],
      [centerX, centerY, centerX + 50 * scale, centerY - 10 * scale],
      [
        centerX,
        centerY - 30 * scale,
        centerX + 55 * scale,
        centerY - 40 * scale,
      ],
      [
        centerX,
        centerY - 60 * scale,
        centerX + 60 * scale,
        centerY - 70 * scale,
      ],
    ];

    for (final vein in rightVeins) {
      final path = Path();
      path.moveTo(vein[0], vein[1]);
      path.lineTo(vein[2], vein[3]);
      paths.add(path);
    }

    // Secondary branching veins
    final secondaryVeins = [
      // Left side branches
      [
        centerX - 40 * scale,
        centerY + 50 * scale,
        centerX - 60 * scale,
        centerY + 40 * scale,
      ],
      [
        centerX - 40 * scale,
        centerY + 50 * scale,
        centerX - 50 * scale,
        centerY + 30 * scale,
      ],
      [
        centerX - 45 * scale,
        centerY + 20 * scale,
        centerX - 65 * scale,
        centerY + 10 * scale,
      ],
      [
        centerX - 45 * scale,
        centerY + 20 * scale,
        centerX - 55 * scale,
        centerY,
      ],

      // Right side branches
      [
        centerX + 40 * scale,
        centerY + 50 * scale,
        centerX + 60 * scale,
        centerY + 40 * scale,
      ],
      [
        centerX + 40 * scale,
        centerY + 50 * scale,
        centerX + 50 * scale,
        centerY + 30 * scale,
      ],
      [
        centerX + 45 * scale,
        centerY + 20 * scale,
        centerX + 65 * scale,
        centerY + 10 * scale,
      ],
      [
        centerX + 45 * scale,
        centerY + 20 * scale,
        centerX + 55 * scale,
        centerY,
      ],
    ];

    for (final vein in secondaryVeins) {
      final path = Path();
      path.moveTo(vein[0], vein[1]);
      path.lineTo(vein[2], vein[3]);
      paths.add(path);
    }

    // Leaf outline (bottom to top)
    final outlinePath = Path();
    outlinePath.moveTo(centerX, centerY - 80 * scale);
    outlinePath.quadraticBezierTo(
      centerX - 20 * scale,
      centerY - 85 * scale,
      centerX - 40 * scale,
      centerY - 75 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX - 60 * scale,
      centerY - 60 * scale,
      centerX - 70 * scale,
      centerY - 40 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX - 75 * scale,
      centerY - 20 * scale,
      centerX - 70 * scale,
      centerY,
    );
    outlinePath.quadraticBezierTo(
      centerX - 65 * scale,
      centerY + 20 * scale,
      centerX - 55 * scale,
      centerY + 40 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX - 45 * scale,
      centerY + 60 * scale,
      centerX - 30 * scale,
      centerY + 80 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX - 15 * scale,
      centerY + 100 * scale,
      centerX,
      centerY + 120 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX + 15 * scale,
      centerY + 100 * scale,
      centerX + 30 * scale,
      centerY + 80 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX + 45 * scale,
      centerY + 60 * scale,
      centerX + 55 * scale,
      centerY + 40 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX + 65 * scale,
      centerY + 20 * scale,
      centerX + 70 * scale,
      centerY,
    );
    outlinePath.quadraticBezierTo(
      centerX + 75 * scale,
      centerY - 20 * scale,
      centerX + 70 * scale,
      centerY - 40 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX + 60 * scale,
      centerY - 60 * scale,
      centerX + 40 * scale,
      centerY - 75 * scale,
    );
    outlinePath.quadraticBezierTo(
      centerX + 20 * scale,
      centerY - 85 * scale,
      centerX,
      centerY - 80 * scale,
    );
    paths.add(outlinePath);

    return paths;
  }

  double _calculatePathProgress(int pathIndex, int totalPaths) {
    // Stagger the animation so paths fill from bottom to top
    final baseProgress = pathIndex / totalPaths;
    final staggerAmount = 0.1; // 10% stagger between paths
    return baseProgress + (staggerAmount * pathIndex / totalPaths);
  }

  void _drawNeonPath(
    Canvas canvas,
    Path path,
    Color color,
    double strokeWidth,
  ) {
    // Create neon glow effect with multiple layers
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = strokeWidth * 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final mainPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = strokeWidth * 0.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw glow layer
    canvas.drawPath(path, glowPaint);

    // Draw main neon line
    canvas.drawPath(path, mainPaint);

    // Draw inner highlight
    canvas.drawPath(path, innerPaint);
  }

  @override
  bool shouldRepaint(NeonLeafPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.neonColors != neonColors ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
