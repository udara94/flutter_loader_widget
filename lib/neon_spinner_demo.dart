import 'package:flutter/material.dart';
import 'neon_spinner_loader.dart';

/// Neon Spinner Demo Page
class NeonSpinnerDemo extends StatefulWidget {
  const NeonSpinnerDemo({super.key});

  @override
  State<NeonSpinnerDemo> createState() => _NeonSpinnerDemoState();
}

class _NeonSpinnerDemoState extends State<NeonSpinnerDemo> {
  double _size = 200.0;
  Duration _duration = const Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main spinner display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: NeonSpinnerLoader(size: _size, duration: _duration),
            ),

            const SizedBox(height: 40),

            // Controls
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'Controls',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Size control
                  Row(
                    children: [
                      Text(
                        'Size: ${_size.toInt()}px',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          value: _size,
                          min: 100,
                          max: 400,
                          divisions: 30,
                          activeColor: Colors.cyan,
                          inactiveColor: Colors.grey[600],
                          onChanged: (value) {
                            setState(() {
                              _size = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Duration control
                  Row(
                    children: [
                      Text(
                        'Speed: ${_duration.inMilliseconds}ms',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          value: _duration.inMilliseconds.toDouble(),
                          min: 500,
                          max: 5000,
                          divisions: 45,
                          activeColor: Colors.pink,
                          inactiveColor: Colors.grey[600],
                          onChanged: (value) {
                            setState(() {
                              _duration = Duration(milliseconds: value.toInt());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'A three-pronged neon spinner with gradient colors and starry background.\n'
                'Features cyan-magenta-blue-orange gradients with realistic neon glow effects.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
