import 'package:flutter/material.dart';
import 'animated_svg_loader.dart';

class SvgLoaderDemo extends StatefulWidget {
  const SvgLoaderDemo({super.key});

  @override
  State<SvgLoaderDemo> createState() => _SvgLoaderDemoState();
}

class _SvgLoaderDemoState extends State<SvgLoaderDemo> {
  SvgLoaderType _selectedType = SvgLoaderType.spinner;
  double _size = 200.0;
  Duration _duration = const Duration(seconds: 2);
  bool _loop = true;
  bool _run = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main SVG Loader Display
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'SVG Animation Loader',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SvgLoader(
                    type: _selectedType,
                    size: _size,
                    duration: _duration,
                    loop: _loop,
                    run: _run,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _run = !_run;
                          });
                        },
                        icon: Icon(_run ? Icons.pause : Icons.play_arrow),
                        label: Text(_run ? 'Pause' : 'Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _run
                              ? Colors.red[600]
                              : Colors.green[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _run = true;
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
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SVG Type Selection
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SVG Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: SvgLoaderType.values.map((type) {
                      return ChoiceChip(
                        label: Text(_getTypeName(type)),
                        selected: _selectedType == type,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedType = type;
                            });
                          }
                        },
                        selectedColor: Colors.blue.withOpacity(0.2),
                        checkmarkColor: Colors.blue,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controls',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Size control
                  Row(
                    children: [
                      Text(
                        'Size: ${_size.toInt()}px',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Expanded(
                        child: Slider(
                          value: _size,
                          min: 100,
                          max: 400,
                          divisions: 30,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey[300],
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
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Expanded(
                        child: Slider(
                          value: _duration.inMilliseconds.toDouble(),
                          min: 500,
                          max: 5000,
                          divisions: 45,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _duration = Duration(milliseconds: value.toInt());
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Loop toggle
                  Row(
                    children: [
                      Checkbox(
                        value: _loop,
                        onChanged: (value) {
                          setState(() {
                            _loop = value ?? true;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'Loop Animation',
                        style: TextStyle(color: Colors.grey[700]),
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
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About SVG Animation Loaders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'These loaders use the drawing_animation package to animate SVG paths. '
                    'Each SVG file contains predefined animations that are drawn progressively, '
                    'creating smooth, vector-based loading animations.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getTypeName(SvgLoaderType type) {
    switch (type) {
      case SvgLoaderType.spinner:
        return 'Spinner';
      case SvgLoaderType.geometric:
        return 'Geometric';
      case SvgLoaderType.wave:
        return 'Wave';
      case SvgLoaderType.heart:
        return 'Heart';
      case SvgLoaderType.simple:
        return 'Heart';
    }
  }
}
