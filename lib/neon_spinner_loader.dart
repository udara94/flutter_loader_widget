import 'dart:math';
import 'package:flutter/material.dart';

class NeonSpinnerLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const NeonSpinnerLoader({
    Key? key,
    this.size = 200.0,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<NeonSpinnerLoader> createState() => _NeonSpinnerLoaderState();
}

class _NeonSpinnerLoaderState extends State<NeonSpinnerLoader>
    with TickerProviderStateMixin {
  late AnimationController _spinnerController;
  late AnimationController _starsController;
  late Animation<double> _spinnerAnimation;
  late Animation<double> _starsAnimation;

  @override
  void initState() {
    super.initState();

    // Spinner rotation animation
    _spinnerController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _spinnerAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _spinnerController, curve: Curves.linear),
    );

    // Stars twinkling animation
    _starsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _starsAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _starsController, curve: Curves.linear));

    _spinnerController.repeat();
    _starsController.repeat();
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_spinnerAnimation, _starsAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: NeonSpinnerPainter(
              _spinnerAnimation.value,
              _starsAnimation.value,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class NeonSpinnerPainter extends CustomPainter {
  final double rotation;
  final double starsPhase;

  NeonSpinnerPainter(this.rotation, this.starsPhase);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 20;

    // Draw starry background
    _drawStarryBackground(canvas, size);

    // Draw the three-pronged spinner
    _drawSpinner(canvas, center, maxRadius);
  }

  void _drawStarryBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0A0A2E), // Dark blue-black
          const Color(0xFF16213E), // Slightly lighter dark blue
          const Color(0xFF0F0F23), // Very dark blue
        ],
        stops: const [0.0, 0.7, 1.0],
        center: Alignment.center,
        radius: 1.0,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = paint.shader,
    );

    // Draw twinkling stars
    final random = Random(42); // Fixed seed for consistent star positions
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 2 + 0.5;
      final opacity =
          (sin(starsPhase + i) + 1) / 2 * 0.8 + 0.2; // Twinkling effect

      canvas.drawCircle(
        Offset(x, y),
        starSize,
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
    }
  }

  void _drawSpinner(Canvas canvas, Offset center, double maxRadius) {
    final armLength = maxRadius * 0.7;
    final hubRadius = maxRadius * 0.15;
    final armWidth = maxRadius * 0.08;

    // Define gradient colors for each arm
    final armColors = [
      [const Color(0xFF00FFFF), const Color(0xFFFF00FF)], // Cyan to Magenta
      [const Color(0xFFFF00FF), const Color(0xFF0000FF)], // Magenta to Blue
      [const Color(0xFF0000FF), const Color(0xFFFF6600)], // Blue to Orange
    ];

    // Draw each arm
    for (int i = 0; i < 3; i++) {
      final armAngle = rotation + (i * 2 * pi / 3);
      _drawArm(canvas, center, armAngle, armLength, armWidth, armColors[i]);
    }

    // Draw central hub
    _drawHub(canvas, center, hubRadius);
  }

  void _drawArm(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    double width,
    List<Color> colors,
  ) {
    final startRadius = length * 0.3;
    final endRadius = length;

    // Create arm path
    final path = Path();

    // Calculate arm endpoints
    final startX = center.dx + cos(angle) * startRadius;
    final startY = center.dy + sin(angle) * startRadius;
    final endX = center.dx + cos(angle) * endRadius;
    final endY = center.dy + sin(angle) * endRadius;

    // Create diamond/trapezoid shape for arm
    final perpendicular = angle + pi / 2;
    final halfWidth = width / 2;

    final p1 = Offset(
      startX + cos(perpendicular) * halfWidth,
      startY + sin(perpendicular) * halfWidth,
    );
    final p2 = Offset(
      endX + cos(perpendicular) * halfWidth * 1.5,
      endY + sin(perpendicular) * halfWidth * 1.5,
    );
    final p3 = Offset(
      endX - cos(perpendicular) * halfWidth * 1.5,
      endY - sin(perpendicular) * halfWidth * 1.5,
    );
    final p4 = Offset(
      startX - cos(perpendicular) * halfWidth,
      startY - sin(perpendicular) * halfWidth,
    );

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    path.lineTo(p4.dx, p4.dy);
    path.close();

    // Create gradient paint
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromPoints(p1, p3));

    // Draw neon glow layers
    _drawNeonGlow(canvas, path, gradientPaint, width);
  }

  void _drawNeonGlow(
    Canvas canvas,
    Path path,
    Paint basePaint,
    double baseWidth,
  ) {
    // Outer glow (largest, most transparent)
    final outerGlow = Paint()
      ..shader = basePaint.shader
      ..strokeWidth = baseWidth * 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, outerGlow);

    // Middle glow
    final middleGlow = Paint()
      ..shader = basePaint.shader
      ..strokeWidth = baseWidth * 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, middleGlow);

    // Inner glow
    final innerGlow = Paint()
      ..shader = basePaint.shader
      ..strokeWidth = baseWidth * 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path, innerGlow);

    // Core bright line
    final corePaint = Paint()
      ..shader = basePaint.shader
      ..strokeWidth = baseWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, corePaint);
  }

  void _drawHub(Canvas canvas, Offset center, double radius) {
    // Create hub gradient (orange to red-orange)
    final hubGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6600), // Orange
          const Color(0xFFFF4500), // Red-orange
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw hub glow layers
    final hubPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    // Outer glow
    canvas.drawPath(
      hubPath,
      Paint()
        ..shader = hubGradient.shader
        ..strokeWidth = radius * 0.3
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Inner glow
    canvas.drawPath(
      hubPath,
      Paint()
        ..shader = hubGradient.shader
        ..strokeWidth = radius * 0.15
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Core hub
    canvas.drawPath(
      hubPath,
      Paint()
        ..shader = hubGradient.shader
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(NeonSpinnerPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.starsPhase != starsPhase;
  }
}
