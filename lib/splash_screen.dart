import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'auth_check.dart';

// Add this to your splash_screen.dart file

class InitialBrandingSplash extends StatefulWidget {
  @override
  _InitialBrandingSplashState createState() => _InitialBrandingSplashState();
}

class _InitialBrandingSplashState extends State<InitialBrandingSplash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _controller.forward();
    
    // After animation completes, navigate to the next screen
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SplashScreenSequence(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final Color primaryPurple = Color(0xFF9D7CF4);
    final Color darkPurple = Color(0xFF7C60D5);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeInAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo or app icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryPurple, darkPurple],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkPurple.withOpacity(0.3),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.spa_outlined,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // App name with shine effect
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [
                            darkPurple,
                            primaryPurple,
                            Colors.white,
                            primaryPurple,
                            darkPurple,
                          ],
                          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                          begin: Alignment(-1.0, -0.5),
                          end: Alignment(1.0, 0.5),
                          tileMode: TileMode.clamp,
                          transform: GradientRotation(
                            _controller.value * pi / 2,
                          ),
                        ).createShader(bounds);
                      },
                      child: Text(
                        "Mental Wellness",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Your journey to inner peace",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 60),
                    // Animated loading indicator
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: _controller.value,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




class SplashScreenSequence extends StatefulWidget {
  @override
  _SplashScreenSequenceState createState() => _SplashScreenSequenceState();
}

class _SplashScreenSequenceState extends State<SplashScreenSequence> with TickerProviderStateMixin {
  int _currentScreenIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Timer _timer;
  bool _hasUserInteracted = false;

  // Define theme colors to match login/signup
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animationController.forward();

    // Auto-advance every 4 seconds if user hasn't interacted
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (!_hasUserInteracted && _currentScreenIndex < 2) {
        setState(() {
          _currentScreenIndex++;
          _pageController.animateToPage(
            _currentScreenIndex,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentScreenIndex = index;
              });
            },
            children: [
              _buildFirstSplashScreen(),
              _buildSecondSplashScreen(),
              _buildThirdSplashScreen(),
            ],
          ),
          // Page indicators at the bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 10,
                  width: _currentScreenIndex == index ? 30 : 10,
                  decoration: BoxDecoration(
                    color: _currentScreenIndex == index ? darkPurple : primaryPurple.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          // Skip button at top-right
          Positioned(
            top: 50,
            right: 16,
            child: TextButton(
              onPressed: () {
                _hasUserInteracted = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthCheck()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: darkPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Next/Get Started button at bottom
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _hasUserInteracted = true;
                  if (_currentScreenIndex < 2) {
                    setState(() {
                      _currentScreenIndex++;
                      _pageController.animateToPage(
                        _currentScreenIndex,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
                    });
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthCheck()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: darkPurple.withOpacity(0.5),
                ),
                child: Text(
                  _currentScreenIndex < 2 ? 'Next' : 'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // First splash screen - Mind Garden
  Widget _buildFirstSplashScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightPurple, Color(0xFFF0E9FF)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: _buildMindGardenAnimation(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Text(
                      "Cultivate Your Mind Garden",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Plant seeds of positivity and watch your mental wellness flourish with daily care and attention.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  // Second splash screen - Daily Calm
  Widget _buildSecondSplashScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F4FF), Color(0xFFE8F6FF)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: _buildMeditationAnimation(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Text(
                      "Find Your Daily Calm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5CAEF9),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Take a moment to breathe. Our guided exercises help you find peace in just minutes a day.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  // Third splash screen - AI Therapy
  Widget _buildThirdSplashScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE8E5), Color(0xFFFFF2F0)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: _buildAITherapyAnimation(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Text(
                      "Your 24/7 Support Companion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5716C),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "AI therapy that listens without judgment, anytime you need to talk. Your private space for reflection and growth.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  // Animated mind garden illustration
  Widget _buildMindGardenAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Custom plant growth animation
        CustomPaint(
          size: Size(300, 300),
          painter: GardenPainter(
            animation: _animationController,
          ),
        ),
        // Floating butterflies
        ...List.generate(
          5,
          (index) => AnimatedPositioned(
            duration: Duration(seconds: 2 + index),
            curve: Curves.easeInOut,
            top: 50.0 + 20 * sin(index * pi / 2.5 + DateTime.now().millisecondsSinceEpoch / 2000),
            left: 100.0 + 100 * cos(index * pi / 2.5 + DateTime.now().millisecondsSinceEpoch / 2000),
            child: Transform.rotate(
              angle: sin(DateTime.now().millisecondsSinceEpoch / 1000 + index),
              child: Icon(
                Icons.flutter_dash,
                color: [
                  primaryPurple,
                  Colors.pink[300],
                  Colors.blue[300],
                  Colors.amber[300],
                  Colors.green[300],
                ][index],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Meditation animation
  Widget _buildMeditationAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect circles
            ...List.generate(
              3,
              (index) => Container(
                width: 150 + (index * 50) * _animationController.value,
                height: 150 + (index * 50) * _animationController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5CAEF9).withOpacity(0.2 - (index * 0.05)),
                ),
              ),
            ).reversed,
            // Meditating person
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF5CAEF9).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.self_improvement,
                size: 70,
                color: Color(0xFF5CAEF9),
              ),
            ),
            // Floating particles
            ...List.generate(
              12,
              (index) {
                final angle = index * (pi / 6);
                final radius = 100 + 20 * sin(DateTime.now().millisecondsSinceEpoch / 1000 + index);
                return Positioned(
                  left: 150 + radius * cos(angle),
                  top: 150 + radius * sin(angle),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF5CAEF9).withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // AI therapy animation
  Widget _buildAITherapyAnimation() {
  return AnimatedBuilder(
    animation: _animationController,
    builder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Simple glowing circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFF5716C).withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          
          // Center icon with subtle animation
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF5716C),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF5716C).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.support_agent,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          
          // Pulsing rings
          ...List.generate(3, (index) {
            final delay = index * 0.25;
            final progress = (_animationController.value - delay) % 1.0;
            final visible = _animationController.value > delay && progress < 0.7;
            
            return Opacity(
              opacity: visible ? (1.0 - progress) : 0,
              child: Container(
                width: visible ? 100 + progress * 150 : 0,
                height: visible ? 100 + progress * 150 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFFF5716C).withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            );
          }),
          
          // Clock hands to represent 24/7
          ...List.generate(2, (index) {
            final isHourHand = index == 0;
            final angle = isHourHand 
                ? _animationController.value * 2 * pi / 12
                : _animationController.value * 2 * pi;
            final length = isHourHand ? 30.0 : 40.0;
            final width = isHourHand ? 4.0 : 3.0;
            
            return Center(
              // child: Transform(
              //   alignment: Alignment.topCenter,
              //   transform: Matrix4.identity()
              //     ..translate(0.0, 50.0, 0.0)
              //     ..rotateZ(angle),
              //   child: Container(
              //     height: length,
              //     width: width,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(width / 2),
              //     ),
              //   ),
              // ),
            );
          }),
        ],
      );
    },
  );
}
}

// Custom painter for the garden animation
class GardenPainter extends CustomPainter {
  final Animation<double> animation;
  
  GardenPainter({required this.animation}) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final groundY = size.height * 0.7;
    
    // Paint for ground
    final groundPaint = Paint()
      ..color = Color(0xFF8DD67C)
      ..style = PaintingStyle.fill;
    
    // Paint for stem
    final stemPaint = Paint()
      ..color = Color(0xFF68B357)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    // Paint for flowers
    final flowerPaint = Paint()
      ..color = Color(0xFF9D7CF4)
      ..style = PaintingStyle.fill;
    
    // Draw ground
    canvas.drawRect(
      Rect.fromLTWH(centerX - 100, groundY, 200, 30),
      groundPaint,
    );
    
    // Draw pot
    final potPath = Path();
    potPath.moveTo(centerX - 40, groundY);
    potPath.lineTo(centerX - 50, groundY + 60);
    potPath.lineTo(centerX + 50, groundY + 60);
    potPath.lineTo(centerX + 40, groundY);
    potPath.close();
    
    canvas.drawPath(
      potPath,
      Paint()..color = Color(0xFFBB8571),
    );
    
    // Draw animated stem
    final stemPath = Path();
    stemPath.moveTo(centerX, groundY);
    
    // Bezier curve control points for stem
    final cp1x = centerX - 20;
    final cp1y = groundY - 50 * animation.value;
    final cp2x = centerX + 20;
    final cp2y = groundY - 100 * animation.value;
    final endX = centerX;
    final endY = groundY - 150 * animation.value;
    
    stemPath.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY);
    
    canvas.drawPath(stemPath, stemPaint);
    
    // Draw leaves
    if (animation.value > 0.3) {
      // Left leaf
      final leafLeftPath = Path();
      final leafY = groundY - 70 * animation.value;
      leafLeftPath.moveTo(centerX, leafY);
      leafLeftPath.cubicTo(
        centerX - 20, leafY - 10,
        centerX - 50, leafY,
        centerX - 30 - 20 * animation.value, leafY + 20,
      );
      leafLeftPath.cubicTo(
        centerX - 20, leafY + 30,
        centerX - 10, leafY + 10,
        centerX, leafY,
      );

      // Right leaf
      final leafRightPath = Path();
      leafRightPath.moveTo(centerX, leafY);
      leafRightPath.cubicTo(
        centerX + 20, leafY - 10,
        centerX + 50, leafY,
        centerX + 30 + 20 * animation.value, leafY + 20,
      );
      leafRightPath.cubicTo(
        centerX + 20, leafY + 30,
        centerX + 10, leafY + 10,
        centerX, leafY,
      );
      
      canvas.drawPath(leafLeftPath, Paint()..color = Color(0xFF91C680));
      canvas.drawPath(leafRightPath, Paint()..color = Color(0xFF8DD67C));
    }
    
    // Draw flower at the end
    if (animation.value > 0.6) {
      final flowerProgress = (animation.value - 0.6) / 0.4; // normalize to 0-1
      final flowerSize = 30 * flowerProgress;
      
      // Draw petals
      for (int i = 0; i < 8; i++) {
        final angle = i * pi / 4;
        final petalPath = Path();
        petalPath.moveTo(endX, endY);
        petalPath.cubicTo(
          endX + 15 * cos(angle) * flowerProgress,
          endY + 15 * sin(angle) * flowerProgress,
          endX + 30 * cos(angle) * flowerProgress,
          endY + 30 * sin(angle) * flowerProgress,
          endX + flowerSize * cos(angle),
          endY + flowerSize * sin(angle),
        );
        petalPath.cubicTo(
          endX + 30 * cos(angle + 0.4) * flowerProgress,
          endY + 30 * sin(angle + 0.4) * flowerProgress,
          endX + 15 * cos(angle + 0.4) * flowerProgress,
          endY + 15 * sin(angle + 0.4) * flowerProgress,
          endX,
          endY,
        );
        
        canvas.drawPath(
          petalPath,
          Paint()..color = Color(0xFF9D7CF4).withOpacity(0.9),
        );
      }
      
      // Draw center of flower
      canvas.drawCircle(
        Offset(endX, endY),
        10 * flowerProgress,
        Paint()..color = Color(0xFFFFD700),
      );
    }
  }
  
  @override
  bool shouldRepaint(GardenPainter oldDelegate) => true;
}

// Custom painter for the brain animation
class BrainPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  BrainPainter({required this.progress, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.35;
    
    final path = Path();
    
    // Draw brain outline
    // Left hemisphere
    path.moveTo(centerX, centerY - radius * 0.8);
    
    if (progress > 0.1) {
      path.cubicTo(
        centerX - radius * 0.5 * min(1, progress / 0.3),
        centerY - radius * 0.8,
        centerX - radius * 0.8 * min(1, progress / 0.3),
        centerY - radius * 0.4,
        centerX - radius * 0.8 * min(1, progress / 0.3),
        centerY,
      );
    }
    
    if (progress > 0.3) {
      path.cubicTo(
        centerX - radius * 0.8 * min(1, (progress - 0.3) / 0.3),
        centerY + radius * 0.4,
        centerX - radius * 0.5 * min(1, (progress - 0.3) / 0.3),
        centerY + radius * 0.8,
        centerX,
        centerY + radius * 0.8 * min(1, (progress - 0.3) / 0.3),
      );
    }
    
    // Right hemisphere
    if (progress > 0.5) {
      path.cubicTo(
        centerX + radius * 0.5 * min(1, (progress - 0.5) / 0.3),
        centerY + radius * 0.8,
        centerX + radius * 0.8 * min(1, (progress - 0.5) / 0.3),
        centerY + radius * 0.4,
        centerX + radius * 0.8 * min(1, (progress - 0.5) / 0.3),
        centerY,
      );
    }
    
    if (progress > 0.7) {
      path.cubicTo(
        centerX + radius * 0.8 * min(1, (progress - 0.7) / 0.3),
        centerY - radius * 0.4,
        centerX + radius * 0.5 * min(1, (progress - 0.7) / 0.3),
        centerY - radius * 0.8,
        centerX,
        centerY - radius * 0.8,
      );
    }
    
    canvas.drawPath(path, paint);
    
    // Draw brain folds
    if (progress > 0.9) {
      final foldProgress = (progress - 0.9) / 0.1;
      
      // Draw some folds in the brain
      final foldPaint = Paint()
        ..color = color.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      // Left hemisphere folds
      final leftFold1 = Path();
      leftFold1.moveTo(centerX - radius * 0.3, centerY - radius * 0.6);
      leftFold1.cubicTo(
        centerX - radius * 0.5, centerY - radius * 0.5,
        centerX - radius * 0.6, centerY - radius * 0.3,
        centerX - radius * 0.7, centerY - radius * 0.1,
      );
      canvas.drawPath(leftFold1, foldPaint);
      
      final leftFold2 = Path();
      leftFold2.moveTo(centerX - radius * 0.2, centerY + radius * 0.3);
      leftFold2.cubicTo(
        centerX - radius * 0.4, centerY + radius * 0.4,
        centerX - radius * 0.6, centerY + radius * 0.3,
        centerX - radius * 0.6, centerY + radius * 0.1,
      );
      canvas.drawPath(leftFold2, foldPaint);
      
      // Right hemisphere folds
      final rightFold1 = Path();
      rightFold1.moveTo(centerX + radius * 0.3, centerY - radius * 0.6);
      rightFold1.cubicTo(
        centerX + radius * 0.5, centerY - radius * 0.5,
        centerX + radius * 0.6, centerY - radius * 0.3,
        centerX + radius * 0.7, centerY - radius * 0.1,
      );
      canvas.drawPath(rightFold1, foldPaint);
      
      final rightFold2 = Path();
      rightFold2.moveTo(centerX + radius * 0.2, centerY + radius * 0.3);
      rightFold2.cubicTo(
        centerX + radius * 0.4, centerY + radius * 0.4,
        centerX + radius * 0.6, centerY + radius * 0.3,
        centerX + radius * 0.6, centerY + radius * 0.1,
      );
      canvas.drawPath(rightFold2, foldPaint);
      
      // Middle connection
      final middleFold = Path();
      middleFold.moveTo(centerX - radius * 0.1, centerY);
      middleFold.cubicTo(
        centerX - radius * 0.05, centerY - radius * 0.2,
        centerX + radius * 0.05, centerY - radius * 0.2,
        centerX + radius * 0.1, centerY,
      );
      canvas.drawPath(middleFold, foldPaint);
    }
  }
  
  @override
  bool shouldRepaint(BrainPainter oldDelegate) => 
      oldDelegate.progress != progress || oldDelegate.color != color;
}