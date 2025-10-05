import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class WorkingSvgTest extends StatefulWidget {
  const WorkingSvgTest({super.key});

  @override
  State<WorkingSvgTest> createState() => _WorkingSvgTestState();
}

class _WorkingSvgTestState extends State<WorkingSvgTest>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isRunning = true;
  double _size = 200.0;
  Duration _duration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (_isRunning) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Working SVG Test'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SVG Animation Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Test with flutter_svg and custom animation
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SizedBox(
                  width: _size,
                  height: _size,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: SvgPicture.asset(
                            'assets/svg/simple_test.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.orange,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isRunning = !_isRunning;
                      if (_isRunning) {
                        _controller.repeat();
                      } else {
                        _controller.stop();
                      }
                    });
                  },
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning
                        ? Colors.red[600]
                        : Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isRunning = true;
                      _controller.reset();
                      _controller.repeat();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Size control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Size: '),
                Slider(
                  value: _size,
                  min: 100,
                  max: 300,
                  divisions: 20,
                  onChanged: (value) {
                    setState(() {
                      _size = value;
                    });
                  },
                ),
                Text('${_size.toInt()}px'),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'This uses flutter_svg with custom rotation and scaling animation.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

