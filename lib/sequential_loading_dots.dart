import 'package:flutter/material.dart';

class LoadingDotsWidget extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final Duration duration;
  final double spacing;

  const LoadingDotsWidget({
    super.key,
    this.dotColor = Colors.blue,
    this.dotSize = 12.0,
    this.duration = const Duration(milliseconds: 1500),
    this.spacing = 8.0,
  });

  @override
  LoadingDotsWidgetState createState() => LoadingDotsWidgetState();
}

class LoadingDotsWidgetState extends State<LoadingDotsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  // Scale animations for each dot
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<double> _scaleAnimation3;

  // Opacity animations for each dot
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Create sequential animations with overlapping timing
    // Each dot animation starts 0.2 seconds after the previous one

    // First dot animations (0.0 - 0.6)
    _scaleAnimation1 = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation1 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Second dot animations (0.2 - 0.8)
    _scaleAnimation2 = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation2 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Third dot animations (0.4 - 1.0)
    _scaleAnimation3 = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.8, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation3 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Start the animation and loop it continuously
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildDot({
    required Animation<double> scaleAnimation,
    required Animation<double> opacityAnimation,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Opacity(
            opacity: opacityAnimation.value,
            child: Container(
              padding: EdgeInsets.zero,
              width: widget.dotSize,
              height: widget.dotSize,
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.dotColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(
          scaleAnimation: _scaleAnimation1,
          opacityAnimation: _opacityAnimation1,
        ),
        // SizedBox(width: widget.spacing),
        _buildDot(
          scaleAnimation: _scaleAnimation2,
          opacityAnimation: _opacityAnimation2,
        ),
        // SizedBox(width: widget.spacing),
        _buildDot(
          scaleAnimation: _scaleAnimation3,
          opacityAnimation: _opacityAnimation3,
        ),
      ],
    );
  }
}

// Advanced loading dots with bounce effect
class AdvancedLoadingDots extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final Duration duration;
  final double spacing;

  const AdvancedLoadingDots({
    super.key,
    this.dotColor = Colors.orange,
    this.dotSize = 14.0,
    this.duration = const Duration(milliseconds: 1800),
    this.spacing = 10.0,
  });

  @override
  AdvancedLoadingDotsState createState() => AdvancedLoadingDotsState();
}

class AdvancedLoadingDotsState extends State<AdvancedLoadingDots>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  // Vertical bounce animations
  late Animation<double> _bounceAnimation1;
  late Animation<double> _bounceAnimation2;
  late Animation<double> _bounceAnimation3;

  // Scale animations
  late Animation<double> _scaleAnimation1;
  late Animation<double> _scaleAnimation2;
  late Animation<double> _scaleAnimation3;

  // Opacity animations
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<double> _opacityAnimation3;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Create bounce animations with different timing
    _bounceAnimation1 = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.bounceOut),
      ),
    );

    _bounceAnimation2 = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.15, 0.65, curve: Curves.bounceOut),
      ),
    );

    _bounceAnimation3 = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.8, curve: Curves.bounceOut),
      ),
    );

    // Scale animations
    _scaleAnimation1 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation2 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.15, 0.45, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation3 = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Opacity animations
    _opacityAnimation1 = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _opacityAnimation2 = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.15, 0.4, curve: Curves.easeIn),
      ),
    );

    _opacityAnimation3 = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.55, curve: Curves.easeIn),
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAdvancedDot({
    required Animation<double> bounceAnimation,
    required Animation<double> scaleAnimation,
    required Animation<double> opacityAnimation,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, bounceAnimation.value),
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: widget.dotColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.dotColor.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Extra height for bounce effect
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAdvancedDot(
            bounceAnimation: _bounceAnimation1,
            scaleAnimation: _scaleAnimation1,
            opacityAnimation: _opacityAnimation1,
          ),
          // SizedBox(width: widget.spacing),
          _buildAdvancedDot(
            bounceAnimation: _bounceAnimation2,
            scaleAnimation: _scaleAnimation2,
            opacityAnimation: _opacityAnimation2,
          ),
          // SizedBox(width: widget.spacing),
          _buildAdvancedDot(
            bounceAnimation: _bounceAnimation3,
            scaleAnimation: _scaleAnimation3,
            opacityAnimation: _opacityAnimation3,
          ),
        ],
      ),
    );
  }
}

// Complete demo app
class LoadingAnimationApp extends StatelessWidget {
  const LoadingAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('sequential Loading Dots'),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),

              // Standard loading dots
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Standard Loading Dots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      LoadingDotsWidget(dotColor: Colors.blue, dotSize: 12),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Advanced bouncing dots
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Bouncing Loading Dots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      AdvancedLoadingDots(dotColor: Colors.orange, dotSize: 14),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Multiple variants
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Different Styles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30),

                      LoadingDotsWidget(
                        dotColor: Colors.purple,
                        dotSize: 16,
                        duration: Duration(milliseconds: 1200),
                      ),

                      SizedBox(height: 30),

                      LoadingDotsWidget(
                        dotColor: Colors.green,
                        dotSize: 10,
                        duration: Duration(milliseconds: 2000),
                        spacing: 6,
                      ),

                      SizedBox(height: 30),

                      LoadingDotsWidget(
                        dotColor: Colors.red,
                        dotSize: 8,
                        duration: Duration(milliseconds: 800),
                        spacing: 4,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
