import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root of the Flutter app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Increment & Toggle App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.cyanAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Button text color
            backgroundColor: Colors.orange, // Default button colors
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: const HomePage(), // Only one screen
    );
  }
}

/// HomePage combining both counter and image toggle, plus a Reset feature.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // -- Counter State --
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // -- Image Toggle State + Animation --
  bool _showFirstImage = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // 1-second fade animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start fully visible on the first image
    _animationController.forward(from: 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Toggles the image and starts the fade animation
  void _toggleImage() {
    setState(() {
      _showFirstImage = !_showFirstImage;
    });
    _animationController.forward(from: 0.0);
  }

  /// Reset to initial values: counter=0, first image
  void _reset() {
    setState(() {
      _counter = 0;
      _showFirstImage = true;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final currentImageUrl = _showFirstImage
        ? 'https://images.icc-cricket.com/image/upload/t_ratio21_9-size50/v1719742258/prd/tpglffhkwkhjxzqgps4r'
        : 'https://a3.espncdn.com/combiner/i?img=%2Fmedia%2Fmotion%2F2018%2F1024%2Fdm_181024_241018%2D25MOMENTS%2DDHONI%2DNRH%2Fdm_181024_241018%2D25MOMENTS%2DDHONI%2DNRH.jpg';

    return Scaffold(
      body: Container(
        // Pastel gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFDAB9), // Peach Puff
              Color(0xFFFCEEB5), // Pastel Yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App title
                  Text(
                    'Increment & Image Toggle App',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // ------------------ Counter Card ------------------
                  Card(
                    color: Colors.white70,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: _incrementCounter,
                            icon: const Icon(Icons.add),
                            label: const Text('Increment'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ------------------ Image Toggle Card ------------------
                  Card(
                    color: Colors.white70,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                currentImageUrl,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                                // Provide an error builder in case the image fails to load
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 250,
                                    height: 250,
                                    child: Center(child: Text('Image not available')),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _toggleImage,
                            child: const Text('Toggle Image'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ------------------ Reset Button ------------------
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // distinct color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: () {
                      // Show a confirmation dialog before resetting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Reset'),
                            content: const Text(
                              'Are you sure you want to reset the counter and image?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _reset();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
