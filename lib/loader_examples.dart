import 'package:flutter/material.dart';
import 'neon_arc_loader.dart';

/// Example usage of the NeonArcLoader widget
class LoaderExample extends StatelessWidget {
  const LoaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Basic usage
            const NeonArcLoader(),

            const SizedBox(height: 40),

            // Custom size
            const NeonArcLoader(size: 150.0, duration: Duration(seconds: 3)),

            const SizedBox(height: 40),

            // Small loader
            const NeonArcLoader(
              size: 80.0,
              duration: Duration(milliseconds: 1500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of using the loader in a loading state
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NeonArcLoader(
                    size: 200.0,
                    duration: Duration(seconds: 2),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Content Loaded!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}


