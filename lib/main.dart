import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'ball.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double maxXValue = 750;
  double maxYValue = 550;

  double minXValue = 50.0;
  double minYValue = 50.0;

  double _xValue = 375.0;
  double _yValue = 550.0;

  int _velocity = 0;

  int accel = 50;

  int friction = 1;

  int radius = 40;

  double canvasWidth = 800.0;
  double canvasHeight = 600.0;

  TextEditingController _velocityController = TextEditingController();
  final _ballHeightController = TextEditingController();

  void _addXValue() {
    setState(() {
      if (_velocity > 0) {
        if (_xValue + _velocity >= maxXValue) {
          _xValue -= _velocity;
        } else {
          _xValue += _velocity;
          _velocity -= friction;
          _velocityController.text = _velocity.toString();
        }
      }
    });
  }

  void _reduceXValue() {
    setState(() {
      if (_velocity > 0) {
        if (_xValue - _velocity <= minXValue) {
          _xValue += _velocity;
        } else {
          _xValue -= _velocity;
          _velocity -= friction;
          _velocityController.text = _velocity.toString();
        }
      }
    });
  }

  void _launchToRight(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      setState(() {
        if (_velocity != 0) {
          if (_xValue + _velocity >= maxXValue ||
              _xValue + _velocity <= minXValue) {
            _velocity *= -1;
            friction *= -1;
          }
          _xValue += _velocity;
          _velocity -= friction;
          _velocityController.text = _velocity.abs().toString();
        } else {
          timer.cancel();
          _velocity = 0;
        }
      });
    });
  }

  void _launchToLeft(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      setState(() {
        if (_velocity != 0) {
          if (_xValue - _velocity >= maxXValue ||
              _xValue - _velocity <= minXValue) {
            _velocity *= -1;
            friction *= -1;
          }
          _xValue -= _velocity;
          _velocity -= friction;
          _velocityController.text = _velocity.abs().toString();
        } else {
          timer.cancel();
          _velocity = 0;
        }
      });
    });
  }

  void _addYValue() {
    setState(() {
      if (_yValue + accel <= maxYValue && accel >= 0) {
        _yValue += accel;
        accel += 1;
        if (radius <= 40) {
          radius += 4;
        }
      }
    });
  }

  void _launchToEarth(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      var counter = 1;
      setState(() {
        if (_yValue != maxYValue || accel != 0) {
          _yValue += accel;
          if (_yValue > maxYValue) {
            _yValue = math.max(0, math.min(_yValue, maxYValue));
            accel *= -1;
            accel = (accel * 0.5).floor();
            counter *= -1;
          }
          accel += 1;
          if (radius <= 40) {
            radius += counter;
          }
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // int _duration = _velocity > 0
    //     ? ((_velocity / (_velocity * 0.01)) - (_velocity * 0.1) + 10).floor()
    //     : 0;

    Widget _velocityTextField = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
            width: 100,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'velocity',
                border: OutlineInputBorder(),
              ),
              controller: _velocityController,
              onChanged: (newValue) {
                setState(() {
                  if (int.parse(newValue) >= 0.0 &&
                      int.parse(newValue) <= 500.0) {
                    _velocity = int.parse(newValue);
                  }
                });
              },
            )));

    final Widget _xValueButtons = Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  handleOnPressed: () => {_reduceXValue()},
                  icon: Icons.arrow_left,
                ),
                CircleButton(
                  handleOnPressed: () => {_launchToLeft(50)},
                  icon: Icons.keyboard_double_arrow_left,
                ),
                _velocityTextField,
                CircleButton(
                  handleOnPressed: () => {_launchToRight(50)},
                  icon: Icons.keyboard_double_arrow_right,
                ),
                CircleButton(
                  handleOnPressed: () => {_addXValue()},
                  icon: Icons.arrow_right,
                ),
              ],
            ),
            SizedBox(
              width: 800,
              child: Slider(
                activeColor: Colors.green[300],
                thumbColor: Colors.black,
                value: _xValue,
                onChanged: (double newValue) {
                  setState(() {
                    _xValue = newValue;
                  });
                },
                min: minXValue,
                max: maxXValue,
              ),
            )
          ],
        ));

    final Widget _yValueButtons = Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: 540,
                child: Slider(
                  activeColor: Colors.green[300],
                  thumbColor: Colors.black,
                  value: _yValue,
                  onChanged: (double newValue) {
                    setState(() {
                      _yValue = newValue;
                      radius = (newValue / 13).floor();
                    });
                  },
                  min: minXValue,
                  max: maxYValue,
                ),
              ),
            ),
            CircleButton(
              handleOnPressed: () => {_addYValue()},
              icon: Icons.keyboard_arrow_down,
            ),
            CircleButton(
              handleOnPressed: () => {_launchToEarth(1)},
              icon: Icons.keyboard_double_arrow_down,
            ),
            // Text('yValue: ${_yValue.floor().toString()}'),
            // Text('width: ${width.floor().toString()}'),
            // Text('height: ${height.floor().toString()}'),
            // Text('accel: ${accel.toString()}'),
          ],
        ));

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: canvasWidth,
                  height: canvasHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Ball(
                    x: _xValue,
                    y: _yValue,
                    radius: radius,
                  ),
                ),
                _xValueButtons
              ],
            ),
            _yValueButtons,
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final handleOnPressed;
  // ignore: prefer_typing_uninitialized_variables
  final icon;

  const CircleButton({
    required this.handleOnPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      child: IconButton(
        color: Colors.black,
        onPressed: handleOnPressed,
        icon: Icon(icon),
        hoverColor: Colors.transparent,
      ),
    );
  }
}
