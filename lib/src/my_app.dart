// import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controlCat;
  late Animation _animation;
  late Animation _animatedCat;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _controlCat = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _animatedCat = Tween<double>(begin: 0.0, end: pi * 2).animate(_controlCat);

    _controller.repeat();
    _controlCat.repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Beautiful Animations',
      home: Scaffold(
        appBar: AppBar(title: Text('Animations'), centerTitle: true),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateX(_animation.value),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 7,
                              color: const Color.fromARGB(91, 228, 174, 170),
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 10),
                AnimatedBuilder(
                  animation: _controlCat,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.topRight,
                      transform: Matrix4.identity()
                        ..rotateY(_animatedCat.value),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 7,
                              color: Colors.black12,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateZ(_animation.value),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        // color: Colors.red,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 7,
                              color: const Color.fromARGB(61, 118, 87, 92),
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
