import 'package:flutter/material.dart';
import 'dart:math';

class CatAnimation extends StatefulWidget {
  const CatAnimation({super.key});
  @override
  State<CatAnimation> createState() => CatAnimationState();
}

class CatAnimationState extends State<CatAnimation>
    with TickerProviderStateMixin {
  late AnimationController _catController;
  late AnimationController _boxController;
  late AnimationController _textController;

  late Animation<double> _catAnimation;
  late Animation _boxAnimation;
  late Animation _textAnimation;

  @override
  initState() {
    super.initState();
    _catController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _catAnimation = Tween<double>(
      begin: 0.0,
      end: 100.0,
    ).animate(CurvedAnimation(parent: _catController, curve: Curves.easeIn));

    _boxController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _boxAnimation = Tween<double>(
      begin: -(pi / 4),
      end: -(pi / 3),
    ).animate(CurvedAnimation(parent: _boxController, curve: Curves.bounceIn));

    _textController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _textAnimation = Tween(begin: 0.0, end: 20).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticIn),
    );
    _textController.repeat();
  }

  @override
  dispose() {
    super.dispose();
    _catController.dispose();
    _boxController.dispose();
    _textController.dispose();
  }

  void onTap() {
    if (_catController.status == AnimationStatus.completed) {
      _catController.reverse();
      _boxController.reset();
      _textController.reset();
    } else if (_catController.status == AnimationStatus.dismissed) {
      _catController.forward();
      _boxController.repeat();
      _textController.repeat();
    }
    // if (_textController.status == AnimationStatus.completed) {}
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedBuilder(
                animation: _catAnimation,
                builder: (context, child) => Stack(
                  clipBehavior: Clip.none,
                  // margin: EdgeInsets.all(20),
                  children: [
                    Positioned(
                      top: -130,
                      height: 200,
                      width: 200,
                      child: Container(
                        margin: EdgeInsets.only(top: _catAnimation.value),
                        child: Image.network('https://i.imgur.com/QwhZRyL.png'),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(color: Colors.blue),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 30,
                      right: 30,
                      child: AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(_textAnimation.value, 0.0),

                          child: Center(
                            child: Text(
                              'Click Me!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      alignment: Alignment.topRight,
                      angle: _boxAnimation.value,
                      child: Container(
                        margin: EdgeInsets.only(left: 190),
                        height: 100,
                        width: 10,
                        decoration: BoxDecoration(color: Colors.blue),
                      ),
                    ),
                    Transform.rotate(
                      alignment: Alignment.topLeft,
                      angle: -(_boxAnimation.value),
                      child: Container(
                        // margin: EdgeInsets.only(left: 20),
                        padding: EdgeInsets.all(10),
                        height: 100,
                        width: 10,
                        decoration: BoxDecoration(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
