import 'package:flutter/material.dart';
import 'neon_arc_loader.dart';
import 'loading_overlay_example.dart';
import 'simple_loading_demo.dart';
import 'neon_spinner_demo.dart';
import 'svg_loader_demo.dart';
import 'simple_svg_test.dart';
import 'working_svg_test.dart';
import 'blur_svg_loader_demo.dart';
import 'debug_blur_loader.dart';
import 'neon_leaf_loader_demo.dart';

/// Model class for demo items
class DemoItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget demoPage;

  DemoItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.demoPage,
  });
}

/// Main demo list page
class LoaderDemoList extends StatelessWidget {
  const LoaderDemoList({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = [
      DemoItem(
        title: 'Neon Arc Loader',
        description:
            'Interactive demo with customizable size and speed controls',
        icon: Icons.play_circle_outline,
        color: Colors.cyan,
        demoPage: const NeonArcLoaderDemo(),
      ),
      DemoItem(
        title: 'Neon Spinner',
        description:
            'Three-pronged spinner with gradient colors and starry background',
        icon: Icons.autorenew,
        color: Colors.orange,
        demoPage: const NeonSpinnerDemo(),
      ),
      DemoItem(
        title: 'SVG Animation Loader',
        description: 'Animated SVG loaders with drawing_animation package',
        icon: Icons.animation,
        color: Colors.purple,
        demoPage: const SvgLoaderDemo(),
      ),
      DemoItem(
        title: 'SVG Test',
        description: 'Simple SVG animation test to debug issues',
        icon: Icons.bug_report,
        color: Colors.red,
        demoPage: const SimpleSvgTest(),
      ),
      DemoItem(
        title: 'Working SVG Test',
        description: 'Reliable SVG animation using flutter_svg',
        icon: Icons.check_circle,
        color: Colors.green,
        demoPage: const WorkingSvgTest(),
      ),
      // DemoItem(
      //   title: 'Blur SVG Loader',
      //   description:
      //       'Beautiful loader with blur background and SVG drawing animation',
      //   icon: Icons.blur_on,
      //   color: Colors.indigo,
      //   demoPage: const BlurSvgLoaderDemo(),
      // ),
      DemoItem(
        title: 'Debug Blur Loader',
        description: 'Debug version to troubleshoot SVG animation issues',
        icon: Icons.bug_report,
        color: Colors.red,
        demoPage: const DebugBlurLoader(),
      ),
      DemoItem(
        title: 'Neon Leaf Loader',
        description:
            'Beautiful leaf skeleton filled with neon lights from bottom to top',
        icon: Icons.eco,
        color: Colors.green,
        demoPage: const NeonLeafLoaderDemo(),
      ),
      DemoItem(
        title: 'Loading Overlay',
        description:
            'Real-world example with semi-transparent overlay on content',
        icon: Icons.layers,
        color: Colors.purple,
        demoPage: const ContentWithLoadingExample(),
      ),
      // DemoItem(
      //   title: 'Simple Loading States',
      //   description:
      //       'Basic loading states with status updates and completion feedback',
      //   icon: Icons.refresh,
      //   color: Colors.green,
      //   demoPage: const SimpleLoadingStatesDemo(),
      // ),
      // Future demos can be added here easily
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Flutter Loading Widgets'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos[index];
          return DemoCard(
            demo: demo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DemoPageWrapper(title: demo.title, child: demo.demoPage),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Card widget for each demo
class DemoCard extends StatelessWidget {
  final DemoItem demo;
  final VoidCallback onTap;

  const DemoCard({Key? key, required this.demo, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                demo.color.withOpacity(0.1),
                demo.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: demo.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(demo.icon, color: demo.color, size: 30),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      demo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper for demo pages with consistent app bar
class DemoPageWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const DemoPageWrapper({Key? key, required this.title, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: child,
    );
  }
}

/// Standalone Neon Arc Loader Demo
class NeonArcLoaderDemo extends StatefulWidget {
  const NeonArcLoaderDemo({super.key});

  @override
  State<NeonArcLoaderDemo> createState() => _NeonArcLoaderDemoState();
}

class _NeonArcLoaderDemoState extends State<NeonArcLoaderDemo> {
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
            // Main loader display
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
              child: NeonArcLoader(size: _size, duration: _duration),
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
                'A custom Flutter loading widget with neon-style concentric arcs.\n'
                'Built using CustomPainter and Canvas for smooth animations.',
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
