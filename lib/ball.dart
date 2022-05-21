import 'package:flutter/material.dart';
import 'dart:math' as math;

Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}

class Ball extends StatefulWidget {
  final double x;
  final double y;
  final int radius;
  const Ball({Key? key, required this.x, required this.y, required this.radius})
      : super(key: key);

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BallPainter(x: widget.x, y: widget.y, radius: widget.radius),
      child: Container(),
    );
  }
}

class BallPainter extends CustomPainter {
  final double x;
  final double y;
  final int radius;

  BallPainter({required this.x, required this.y, required this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    Iterable<Offset> createCircle(int wheel) {
      return positiveIntegers
          .map((e) => e * 360.0 / wheel)
          .map((e) => e + x + y)
          .map((e) => e * (math.pi / 180))
          .map((e) =>
              Offset(x + (radius * math.cos(e)), y + radius * math.sin(e)))
          .take(wheel);
    }

    final points = createCircle(180).toList();
    final outerCirclePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final innerCirclePaint = Paint()
      ..color = Colors.green.shade300
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    createCircle(4).forEach((element) {
      canvas.drawLine(Offset(x, y), element, innerCirclePaint);
    });

    for (int i = 0; i < points.length; i++) {
      canvas.drawLine(
          points[i], points[(i + 1) % points.length], outerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(BallPainter oldDelegate) {
    return true;
  }
}
