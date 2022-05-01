import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _xValue = 0.0;

  double _yValue = 1.1;

  double _degree = 0;

  int _velocity = 0;

  bool isRight = true;

  bool isLeft = true;

  bool isDown = true;

  double accel = 0.0;

  double width = 100.0;
  double height = 100.0;

  TextEditingController _velocityController = TextEditingController();

  void _addXValue() {
    if (_velocity > 0 && _xValue < 1.5) {
      _velocity -= 1;
      _xValue += (_velocity / 800);
      _degree += 15;
      _velocityController.text = _velocity.toString();
    }
  }

  void _reduceXValue() {
    if (_velocity > 0 && _xValue > -1.5) {
      _velocity -= 1;
      _xValue -= (_velocity / 800);
      _degree -= 15;
      _velocityController.text = _velocity.toString();
    }
  }

  void _launchToRight(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      if (_velocity <= 0) {
        timer.cancel();
      }
      if (isRight) {
        setState(_addXValue);
        if (_xValue + (_velocity / 800) > 1) {
          isRight = false;
        }
      } else {
        setState(_reduceXValue);
        if (_xValue - (_velocity / 800) < -1) {
          isRight = true;
        }
      }
    });
  }

  void _launchToLeft(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      if (_velocity <= 0) {
        timer.cancel();
      }
      if (isLeft) {
        setState(_reduceXValue);
        if (_xValue - (_velocity / 800) < -1) {
          isLeft = false;
        }
      } else {
        setState(_addXValue);
        if (_xValue + (_velocity / 800) > 1) {
          isLeft = true;
        }
      }
    });
  }

  void _addYValue() {
    if (_yValue < 1.0 && accel >= 0.0) {
      _yValue += accel;
      width += 2.0;
      height += 2.0;
    }
  }

  void _launchToEarth(int _duration) {
    Timer.periodic(Duration(milliseconds: _duration), (timer) {
      setState(() {
        if (_yValue >= 1.11) {
          accel = 0.0;
          _yValue = 1.0;
          timer.cancel();
        }
        if (_yValue >= 0.8) {
          accel *= -1;
          width -= 3;
          height -= 3;
        }
        accel += 0.1;
        width += 1;
        height += 1;
        _yValue += accel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // int _duration = _velocity > 0
    //     ? ((_velocity / (_velocity * 0.01)) - (_velocity * 0.1) + 10).floor()
    //     : 0;
    final Widget ball = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 100),
        alignment: Alignment(_xValue, _yValue),
        child: Transform.rotate(
          angle: _degree * math.pi / 180,
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Center(
              child: Text(
                'BOLA INI BOI',
                style: TextStyle(
                  fontSize: 8.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final Widget _velocityTextField = Padding(
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
                  handleOnPressed: () => setState(_reduceXValue),
                  icon: Icons.arrow_left,
                ),
                CircleButton(
                  handleOnPressed: () => {_launchToLeft(100)},
                  icon: Icons.keyboard_double_arrow_left,
                ),
                _velocityTextField,
                CircleButton(
                  handleOnPressed: () => {_launchToRight(100)},
                  icon: Icons.keyboard_double_arrow_right,
                ),
                CircleButton(
                  handleOnPressed: () => setState(_addXValue),
                  icon: Icons.arrow_right,
                ),
              ],
            ),
            SizedBox(
              width: 800,
              child: Slider(
                value: _xValue,
                onChanged: (double newValue) {
                  setState(() {
                    _xValue = newValue;
                  });
                },
                min: -1.0,
                max: 1.0,
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
                  value: _yValue,
                  onChanged: (double newValue) {
                    setState(() {
                      if (isDown) {
                        if (_yValue >= 1.0) {
                          isDown = false;
                        }
                        width += 0.3;
                        height += 0.3;
                      } else {
                        if (_yValue <= -1.0) {
                          isDown = true;
                        }
                        width -= 0.3;
                        height -= 0.3;
                      }
                      _yValue = newValue;
                    });
                  },
                  min: -1.0,
                  max: 1.5,
                ),
              ),
            ),
            CircleButton(
              handleOnPressed: () => setState(_addYValue),
              icon: Icons.keyboard_arrow_down,
            ),
            CircleButton(
              handleOnPressed: () => {_launchToEarth(100)},
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 800,
                  height: 600,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: ball,
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
