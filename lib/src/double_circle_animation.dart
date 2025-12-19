import 'package:flutter/material.dart';
import 'dart:math';

class CircleAnimation extends StatefulWidget {
  const CircleAnimation({super.key});

  @override
  State<CircleAnimation> createState() => _CircleAnimationState();
}

enum CircleArc { left, right }

extension ToPath on CircleArc {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleArc.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleArc.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircle extends CustomClipper<Path> {
  final CircleArc side;
  const HalfCircle({required this.side});
  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _CircleAnimationState extends State<CircleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _leftController;
  late AnimationController _rightController;

  late Animation _leftAnimation;
  late Animation _rightAnimation;

  @override
  initState() {
    super.initState();
    _leftController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    // _rightAnimation = AnimationController(
    //   vsync: this,
    //   duration: Duration(sec_rightonds: 1),
    // );
    _rightController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _leftAnimation = Tween<double>(begin: 0, end: -(pi / 2)).animate(
      CurvedAnimation(curve: Curves.bounceOut, parent: _leftController),
    );
    _rightAnimation = Tween<double>(begin: 0, end: -(pi / 2)).animate(
      CurvedAnimation(parent: _rightController, curve: Curves.bounceOut),
    );

    _leftController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rightAnimation =
            Tween<double>(
              begin: _rightAnimation.value,
              end: _rightAnimation.value + pi,
            ).animate(
              CurvedAnimation(
                parent: _rightController,
                curve: Curves.bounceOut,
              ),
            );
        _rightController
          ..reset()
          ..forward();
      }
    });

    _rightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _leftAnimation =
            Tween<double>(
              begin: _leftAnimation.value,
              end: _leftAnimation.value + -(pi / 2),
            ).animate(
              CurvedAnimation(parent: _leftController, curve: Curves.bounceOut),
            );
        _leftController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _leftController
      ..reset()
      ..forward();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _leftController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(_leftAnimation.value),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _rightController,
                          builder: (context, child) => Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..rotateY(_rightAnimation.value),
                            child: ClipPath(
                              clipper: HalfCircle(side: CircleArc.left),
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.only(
                                  //   topLeft: Radius.circular(100),
                                  //   bottomLeft: Radius.circular(100),
                                  // ),
                                  color: Colors.purple,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(0.0, 1.0),
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        AnimatedBuilder(
                          animation: _rightController,
                          builder: (context, child) => Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..rotateY(_rightAnimation.value),
                            child: ClipPath(
                              clipper: HalfCircle(side: CircleArc.right),
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.only(
                                  //   topRight: Radius.circular(100),
                                  //   bottomRight: Radius.circular(100),
                                  // ),
                                  color: const Color.fromARGB(255, 39, 176, 64),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(0.0, 1.0),
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 100),
              AnimatedBuilder(
                animation: _leftController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(_leftAnimation.value),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _rightController,
                          builder: (context, child) => Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..rotateY(_rightAnimation.value),
                            child: Container(
                              // margin: EdgeInsets.all(10),
                              height: 100,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(100),
                                ),
                                color: Colors.purple,
                                // boxShadow: [
                                //   BoxShadow(
                                //     blurRadius: 3,
                                //     offset: Offset(0.0, 1.0),
                                //     spreadRadius: 1.0,
                                //   ),
                                // ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _rightController,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..rotateY(_rightAnimation.value),
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: 100,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100),
                                  ),
                                  color: const Color.fromARGB(255, 39, 176, 64),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     blurRadius: 3,
                                  //     offset: Offset(0.0, 1.0),
                                  //     spreadRadius: 1.0,
                                  //   ),
                                  // ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
