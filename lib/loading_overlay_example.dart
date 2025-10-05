import 'package:flutter/material.dart';
import 'neon_arc_loader.dart';

/// A loading overlay widget that shows a semi-transparent background
/// with the neon loader on top, allowing background content to be visible
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final double loaderSize;
  final Duration animationDuration;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.loaderSize = 120.0,
    this.animationDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background content
        child,

        // Loading overlay
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.7), // Semi-transparent black
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeonArcLoader(
                      size: loaderSize,
                      duration: animationDuration,
                    ),
                    if (loadingText != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        loadingText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Example page with random content and loading overlay
class ContentWithLoadingExample extends StatefulWidget {
  const ContentWithLoadingExample({super.key});

  @override
  State<ContentWithLoadingExample> createState() =>
      _ContentWithLoadingExampleState();
}

class _ContentWithLoadingExampleState extends State<ContentWithLoadingExample> {
  bool _isLoading = false;
  List<String> _contentItems = [];

  @override
  void initState() {
    super.initState();
    _generateContent();
  }

  void _generateContent() {
    setState(() {
      _contentItems = List.generate(20, (index) => _getRandomContent(index));
    });
  }

  String _getRandomContent([int? index]) {
    final contents = [
      "Flutter is Google's UI toolkit for building beautiful, natively compiled applications.",
      "CustomPainter allows you to create custom graphics and animations.",
      "Canvas provides low-level drawing operations for custom shapes.",
      "AnimationController manages animation timing and state.",
      "Neon effects can be achieved using multiple paint layers with different opacities.",
      "Loading states are crucial for good user experience.",
      "Overlay widgets help maintain context during loading operations.",
      "Semi-transparent backgrounds preserve visual hierarchy.",
      "Custom animations make apps feel more polished and professional.",
      "Flutter's widget tree enables efficient rendering and updates.",
      "Material Design provides consistent visual language across platforms.",
      "Responsive design ensures apps work on different screen sizes.",
      "State management is key to building maintainable Flutter apps.",
      "Hot reload speeds up development iteration significantly.",
      "Custom widgets promote code reusability and modularity.",
    ];

    final contentIndex =
        index ?? DateTime.now().millisecondsSinceEpoch % contents.length;
    return contents[contentIndex % contents.length];
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request or data processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _generateContent(); // Refresh content after loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      loadingText: "Loading new content...",
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Content with Loading Overlay'),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _simulateLoading,
              tooltip: 'Refresh Content',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
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
                  'Scroll down to see more content!\nTap refresh to see the loading overlay.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Content cards
              ..._contentItems.asMap().entries.map((entry) {
                final cardIndex = entry.key;
                final content = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getCardColor(cardIndex),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            '${cardIndex + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),

              // Refresh button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _simulateLoading,
                  icon: const Icon(Icons.refresh),
                  label: Text(_isLoading ? 'Loading...' : 'Refresh Content'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      Colors.red[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
      Colors.cyan[400]!,
    ];
    return colors[index % colors.length];
  }
}
