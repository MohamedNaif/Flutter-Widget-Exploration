import 'package:flutter/material.dart';

class PhysicsPlaygroundScreen extends StatefulWidget {
  const PhysicsPlaygroundScreen({super.key});

  @override
  PhysicsPlaygroundScreenState createState() => PhysicsPlaygroundScreenState();
}

class PhysicsPlaygroundScreenState extends State<PhysicsPlaygroundScreen>
    with TickerProviderStateMixin {
  // Track which containers have been filled
  Map<String, bool> containersFilled = {
    'red': false,
    'blue': false,
    'green': false,
  };

  // Track ball positions for reset functionality
  Map<String, Offset> ballPositions = {
    'red': Offset(100, 240),
    'blue': Offset(215, 240),
    'green': Offset(330, 240),
  };

  // Animation controllers for visual effects
  late AnimationController _successAnimationController;
  late AnimationController _shakeAnimationController;
  late Animation<double> _successAnimation;
  late Animation<double> _shakeAnimation;

  String? _shakingContainer;

  @override
  void initState() {
    super.initState();

    _successAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _successAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _shakeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    _shakeAnimationController.dispose();
    super.dispose();
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _onCorrectDrop(String color) {
    setState(() {
      containersFilled[color] = true;
    });

    _successAnimationController.forward().then((_) {
      _successAnimationController.reverse();
    });

    // Check if all containers are filled
    if (containersFilled.values.every((filled) => filled)) {
      _showCompletionDialog();
    }
  }

  void _onIncorrectDrop(String targetColor) {
    setState(() {
      _shakingContainer = targetColor;
    });

    _shakeAnimationController.forward().then((_) {
      _shakeAnimationController.reset();
      setState(() {
        _shakingContainer = null;
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('🎉 Congratulations!'),
          content: Text(
            'You\'ve successfully matched all the balls to their containers!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      containersFilled = {'red': false, 'blue': false, 'green': false};
    });
  }

  Widget _buildDraggableBall(String color) {
    return Positioned(
      left: ballPositions[color]!.dx - 25,
      top: ballPositions[color]!.dy - 25,
      child: containersFilled[color]!
          ? SizedBox.shrink() // Hide ball if it's been placed
          : Draggable<String>(
              data: color,
              feedback: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getColorFromString(color),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
              ),
              childWhenDragging: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getColorFromString(color).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getColorFromString(color),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getColorFromString(color),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDropTarget(String color, Offset position) {
    bool isShaking = _shakingContainer == color;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Positioned(
          left:
              position.dx +
              (isShaking
                  ? _shakeAnimation.value *
                        (DateTime.now().millisecondsSinceEpoch % 2 == 0
                            ? 1
                            : -1)
                  : 0),
          top: position.dy,
          child: AnimatedBuilder(
            animation: _successAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: containersFilled[color]! ? _successAnimation.value : 1.0,
                child: DragTarget<String>(
                  onAcceptWithDetails: (draggedColor) {
                    if (draggedColor.data == color) {
                      _onCorrectDrop(color);
                    } else {
                      _onIncorrectDrop(color);
                    }
                  },
                  onWillAcceptWithDetails: (draggedColor) => true,
                  builder: (context, candidateData, rejectedData) {
                    bool isHovering = candidateData.isNotEmpty;
                    bool isCorrectHover = candidateData.contains(color);
                    bool isFilled = containersFilled[color]!;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isFilled
                            ? _getColorFromString(color).withValues(alpha: 0.3)
                            : _getColorFromString(color).withValues(alpha: 0.1),
                        border: Border.all(
                          color: isHovering
                              ? (isCorrectHover
                                    ? _getColorFromString(color)
                                    : Colors.red)
                              : _getColorFromString(color),
                          width: isHovering ? 3 : 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isHovering
                            ? [
                                BoxShadow(
                                  color:
                                      (isCorrectHover
                                              ? _getColorFromString(color)
                                              : Colors.red)
                                          .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isFilled)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _getColorFromString(color),
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (isFilled)
                            Icon(Icons.check, color: Colors.white, size: 24),
                          if (!isFilled && isHovering)
                            Icon(
                              isCorrectHover
                                  ? Icons.check_circle_outline
                                  : Icons.close,
                              color: isCorrectHover
                                  ? _getColorFromString(color)
                                  : Colors.red,
                              size: 32,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E6F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Physics Playground',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Instructions
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Drag each colored ball to its matching container!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Draggable balls
          _buildDraggableBall('red'),
          _buildDraggableBall('blue'),
          _buildDraggableBall('green'),

          // Drop target containers
          _buildDropTarget('red', Offset(40, 590)),
          _buildDropTarget('blue', Offset(165, 590)),
          _buildDropTarget('green', Offset(290, 590)),

          // Progress indicator
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Progress: ${containersFilled.values.where((filled) => filled).length}/3',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value:
                          containersFilled.values
                              .where((filled) => filled)
                              .length /
                          3,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
