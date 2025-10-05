import 'dart:math';
import 'package:flutter/material.dart';

class NeonArcLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const NeonArcLoader({
    Key? key,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<NeonArcLoader> createState() => _NeonArcLoaderState();
}

class _NeonArcLoaderState extends State<NeonArcLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            painter: NeonArcPainter(_animation.value),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class NeonArcPainter extends CustomPainter {
  final double rotation;

  NeonArcPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 20;

    // Define the neon colors matching the image
    final colors = [
      const Color(0xFF00FF00), // Bright lime green
      const Color(0xFF00FFFF), // Cyan
      const Color(0xFFFFFF00), // Yellow
      const Color(0xFFFF00FF), // Magenta
      const Color(0xFF0000FF), // Deep blue
    ];

    // Define arc properties
    final arcCount = colors.length;
    final arcSpacing = maxRadius / arcCount;
    final arcLength = 5.5; // 5.5 radians (about 315 degrees)

    for (int i = 0; i < arcCount; i++) {
      final radius = (i + 1) * arcSpacing;
      final color = colors[i];

      // Calculate the start angle for this arc with rotation and offset
      final baseAngle = rotation + (i * 0.3); // Offset each arc slightly
      final startAngle = baseAngle;
      final sweepAngle = arcLength;

      // Create the arc path
      final rect = Rect.fromCircle(center: center, radius: radius);
      final path = Path();
      path.addArc(rect, startAngle, sweepAngle);

      // Create neon glow effect using multiple paint layers
      final paints = _createNeonPaints(color, radius);

      for (final paint in paints) {
        canvas.drawPath(path, paint);
      }
    }
  }

  List<Paint> _createNeonPaints(Color color, double radius) {
    final paints = <Paint>[];

    // Outer glow (largest, most transparent)
    final outerGlow = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = radius * 0.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    paints.add(outerGlow);

    // Middle glow
    final middleGlow = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = radius * 0.15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    paints.add(middleGlow);

    // Inner glow
    final innerGlow = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = radius * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    paints.add(innerGlow);

    // Core bright line
    final corePaint = Paint()
      ..color = color
      ..strokeWidth = radius * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    paints.add(corePaint);

    return paints;
  }

  @override
  bool shouldRepaint(NeonArcPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
