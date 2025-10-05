import 'package:flutter/material.dart';
import 'neon_arc_loader.dart';

/// Simple loading states demo
class SimpleLoadingStatesDemo extends StatefulWidget {
  const SimpleLoadingStatesDemo({super.key});

  @override
  State<SimpleLoadingStatesDemo> createState() =>
      _SimpleLoadingStatesDemoState();
}

class _SimpleLoadingStatesDemoState extends State<SimpleLoadingStatesDemo> {
  bool _isLoading = false;
  String _status = 'Ready to load';

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading...';
    });

    // Simulate different loading phases
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _status = 'Processing data...';
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _status = 'Almost done...';
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _status = 'Loading complete!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _isLoading ? Colors.blue[600] : Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Loader or content
            if (_isLoading)
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
                    const NeonArcLoader(
                      size: 120,
                      duration: Duration(seconds: 1),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Success!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data has been loaded successfully',
                      style: TextStyle(fontSize: 14, color: Colors.green[600]),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // Action button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _simulateLoading,
              icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.play_arrow),
              label: Text(_isLoading ? 'Loading...' : 'Start Loading'),
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
          ],
        ),
      ),
    );
  }
}

