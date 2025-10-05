import 'dart:math';

import 'package:drawing_animation_plus/drawing_animation_plus.dart';
import 'package:flutter/material.dart';
import 'animated_svg_loader.dart';

class SimpleSvgTest extends StatefulWidget {
  const SimpleSvgTest({super.key});

  @override
  State<SimpleSvgTest> createState() => _SimpleSvgTestState();
}

class _SimpleSvgTestState extends State<SimpleSvgTest> {
  bool _isRunning = true;
  double _size = 200.0;
  Duration _duration = const Duration(seconds: 2);
  String _selectedSvg = 'assets/svg/women.svg';
  bool run = true;
  double _rotationAngle = 3.14159; // 180 degrees to fix upside down
  LineAnimation _lineAnimation = LineAnimation.oneByOne; // Safe default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          run = !run;
        }),
        child: Icon((run) ? Icons.stop : Icons.play_arrow),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Animation with proper sizing and rotation
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(
                child: SizedBox(
                  width: _size - 20,
                  height: _size - 20,
                  child: Transform.rotate(
                    angle: _rotationAngle,
                    child: AnimatedDrawing.svg(
                      _selectedSvg,
                      run: run,
                      duration: Duration(seconds: 2),
                      lineAnimation: _lineAnimation,
                      animationCurve: Curves.linear,
                      onFinish: () => setState(() {
                        run = false;
                      }),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Rotation controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _rotationAngle = 0),
                  child: const Text('0°'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _rotationAngle = 3.14159), // 180°
                  child: const Text('180°'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _rotationAngle = 3.14159 / 2), // 90°
                  child: const Text('90°'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _rotationAngle = -3.14159 / 2), // -90°
                  child: const Text('-90°'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Line Animation controls
            Text('Line Animation: ${_lineAnimation.name}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      setState(() => _lineAnimation = LineAnimation.oneByOne),
                  child: const Text('One by One'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show warning for allAtOnce as it may cause errors with some SVGs
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Warning: All at Once may cause errors with some SVGs',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() => _lineAnimation = LineAnimation.allAtOnce);
                  },
                  child: const Text('All at Once'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Size control
            Text('Size: ${_size.round()}px'),
            Slider(
              value: _size,
              min: 100,
              max: 300,
              divisions: 20,
              onChanged: (value) => setState(() => _size = value),
            ),

            const SizedBox(height: 20),

            // SVG selection
            DropdownButton<String>(
              value: _selectedSvg,
              items:
                  [
                    'assets/svg/women.svg',
                    'assets/svg/simple_test.svg',
                    'assets/svg/loading_spinner.svg',
                    'assets/svg/wave_loader.svg',
                    'assets/svg/geometric_loader.svg',
                    'assets/svg/heart_loader.svg',
                  ].map((String svg) {
                    return DropdownMenuItem<String>(
                      value: svg,
                      child: Text(svg.split('/').last),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSvg = newValue;
                    run = true; // Restart animation when changing SVG
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
