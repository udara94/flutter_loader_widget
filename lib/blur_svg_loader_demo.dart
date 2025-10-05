import 'package:flutter/material.dart';
import 'blur_svg_loader.dart';

class BlurSvgLoaderDemo extends StatefulWidget {
  const BlurSvgLoaderDemo({super.key});

  @override
  State<BlurSvgLoaderDemo> createState() => _BlurSvgLoaderDemoState();
}

class _BlurSvgLoaderDemoState extends State<BlurSvgLoaderDemo> {
  BlurSvgLoaderType _selectedType = BlurSvgLoaderType.simple;
  double _size = 200.0;
  Duration _duration = const Duration(seconds: 2);
  Color _color = Colors.blue;
  String _loadingText = 'Loading...';
  bool _showBlurBackground = true;
  double _blurIntensity = 10.0;
  bool _isLoading = false;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Blur SVG Loader Demo'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background content to demonstrate blur effect
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.purple[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Blur SVG Loader Component\nTap "Show Loader" to see the blur effect!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sample content cards
                ...List.generate(8, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sample Content ${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'This is sample content to demonstrate the blur background effect when the loader is shown.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 100), // Space for controls
              ],
            ),
          ),

          // Controls panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show Loader Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                      },
                      icon: Icon(_isLoading ? Icons.stop : Icons.play_arrow),
                      label: Text(_isLoading ? 'Hide Loader' : 'Show Loader'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? Colors.red[600]
                            : Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Loader Type Selection
                  Text(
                    'Loader Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: BlurSvgLoaderType.values.map((type) {
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
                        selectedColor: _color.withOpacity(0.2),
                        checkmarkColor: _color,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Size and Duration controls
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Size: ${_size.toInt()}px'),
                            Slider(
                              value: _size,
                              min: 100,
                              max: 300,
                              divisions: 20,
                              activeColor: _color,
                              onChanged: (value) {
                                setState(() {
                                  _size = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Speed: ${_duration.inMilliseconds}ms'),
                            Slider(
                              value: _duration.inMilliseconds.toDouble(),
                              min: 500,
                              max: 5000,
                              divisions: 45,
                              activeColor: _color,
                              onChanged: (value) {
                                setState(() {
                                  _duration = Duration(
                                    milliseconds: value.toInt(),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Blur intensity control
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Blur: ${_blurIntensity.toStringAsFixed(1)}'),
                            Slider(
                              value: _blurIntensity,
                              min: 0,
                              max: 20,
                              divisions: 40,
                              activeColor: _color,
                              onChanged: (value) {
                                setState(() {
                                  _blurIntensity = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Background Blur'),
                            Switch(
                              value: _showBlurBackground,
                              onChanged: (value) {
                                setState(() {
                                  _showBlurBackground = value;
                                });
                              },
                              activeColor: _color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Color selection
                  Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: _availableColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _color = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _color == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Blur SVG Loader
          if (_isLoading)
            BlurSvgLoaderWidget(
              type: _selectedType,
              size: _size,
              duration: _duration,
              color: _color,
              loadingText: _loadingText,
              showBlurBackground: _showBlurBackground,
              blurIntensity: _blurIntensity,
            ),
        ],
      ),
    );
  }

  String _getTypeName(BlurSvgLoaderType type) {
    switch (type) {
      case BlurSvgLoaderType.spinner:
        return 'Spinner';
      case BlurSvgLoaderType.geometric:
        return 'Geometric';
      case BlurSvgLoaderType.wave:
        return 'Wave';
      case BlurSvgLoaderType.heart:
        return 'Heart';
      case BlurSvgLoaderType.simple:
        return 'Simple';
    }
  }
}

