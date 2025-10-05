import 'package:flutter/material.dart';
import 'package:drawing_animation_plus/drawing_animation_plus.dart';
import 'dart:ui';

class DebugBlurLoader extends StatefulWidget {
  const DebugBlurLoader({super.key});

  @override
  State<DebugBlurLoader> createState() => _DebugBlurLoaderState();
}

class _DebugBlurLoaderState extends State<DebugBlurLoader> {
  bool _isRunning = true;
  String _selectedSvg = 'assets/svg/simple_test.svg';
  double _rotationAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Debug Blur Loader'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue[100],
                  child: const Center(
                    child: Text(
                      'Background Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRunning = !_isRunning;
                    });
                  },
                  child: Text(
                    _isRunning ? 'Stop Animation' : 'Start Animation',
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedSvg,
                  items:
                      [
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
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Blur overlay with SVG
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
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
                        // Debug info
                        Text(
                          'SVG: ${_selectedSvg.split('/').last}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Running: $_isRunning',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Rotation: ${(_rotationAngle * 180 / 3.14159).round()}°',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SVG Animation
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: Transform.rotate(
                                angle: _rotationAngle,
                                child: AnimatedDrawing.svg(
                                  _selectedSvg,
                                  run: _isRunning,
                                  duration: const Duration(seconds: 2),
                                  lineAnimation: LineAnimation.oneByOne,
                                  animationCurve: Curves.linear,
                                  onFinish: () {
                                    print('SVG animation finished!');
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Rotation controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  setState(() => _rotationAngle = 0),
                              child: const Text('0°'),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(
                                () => _rotationAngle = 3.14159,
                              ), // 180°
                              child: const Text('180°'),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(
                                () => _rotationAngle = 3.14159 / 2,
                              ), // 90°
                              child: const Text('90°'),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(
                                () => _rotationAngle = -3.14159 / 2,
                              ), // -90°
                              child: const Text('-90°'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
