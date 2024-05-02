import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_electricity_meter/electricity_meter/electricity_manager.dart';

class ElectricityMeter extends StatefulWidget {
  const ElectricityMeter(
      {required this.width,
      required this.manager,
      this.colors = const [],
      super.key});

  final ElectricityMeterManager manager;
  final double width;
  final List<Color> colors;

  @override
  State<ElectricityMeter> createState() => _ElectricityMeterState();
}

class _ElectricityMeterState extends State<ElectricityMeter> {
  ElectricityMeterManager get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.width,
          height: widget.width / 2,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(bottom: 15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomPaint(
                painter: _ElectricityMeterPainter(
                  maxValue: manager.maxValue,
                  colors: widget.colors,
                ),
                child: SizedBox(
                  width: widget.width,
                  height: widget.width / 2,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder<int>(
                        valueListenable: manager.currentValue,
                        builder: (context, value, child) {
                          final newAngle = pi * (value / manager.maxValue);
                          return Transform.rotate(
                            angle: newAngle,
                            child: Transform.translate(
                              offset: Offset(-(widget.width / 5.7), 0),
                              child: ClipPath(
                                clipper: _TrianglePainter(),
                                child: Container(
                                    height: 25,
                                    color: Colors.red,
                                    width: widget.width / 2.6),
                              ),
                            ),
                          );
                        }),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height / 2);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ElectricityMeterPainter extends CustomPainter {
  final List<Color> colors;
  final int maxValue;

  _ElectricityMeterPainter({required this.colors, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    var start = 0.0;
    final distance = -(pi / colors.length);
    final disVal = maxValue / colors.length;

    for (var i = 0; i < colors.length; i++) {
      final redCircle = Paint()
        ..color = colors[i]
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke;
      final arcRect = Rect.fromCircle(
          center: size.bottomCenter(Offset.zero), radius: size.width / 2);
      if (i == 0) {
        final path = Path();
        path.moveTo(size.width, size.height);
        path.quadraticBezierTo(
            size.width, size.height + 5, size.width, size.height);
        canvas.drawPath(path, redCircle);
        canvas.drawArc(arcRect, start, distance, false, redCircle);
      } else if (i == colors.length - 1) {
        final path = Path();
        path.moveTo(0, size.height);
        path.quadraticBezierTo(0, size.height + 5, 0, size.height);
        canvas.drawPath(path, redCircle);
        canvas.drawArc(arcRect, start, distance, false, redCircle);
      } else {
        canvas.drawArc(arcRect, start, distance, false, redCircle);
      }
      final des = start + distance;

      drawCircleInAngle(canvas, size, size.width / 2 - 5, des,
          ((disVal * (colors.length - i - 1))).toInt());

      start = des;
    }

    drawCircleInAngle(canvas, size, size.width / 2 - 5, 0, maxValue);
  }

  void drawCircleInAngle(
      Canvas canvas, Size size, double radius, double angle, int value) {
    final center = Offset(size.width / 2, size.height);
    final secondAngle = angle + 0.01;

    final double xOffset = center.dx + (radius * cos(angle));
    final double yOffset = center.dy + (radius * sin(angle));
    final firstOffset = Offset(xOffset, yOffset);

    final double x2Offset = center.dx + (radius * cos(secondAngle));
    final double y2Offset = center.dy + (radius * sin(secondAngle));
    final secondOffset = Offset(x2Offset, y2Offset);

    final secondRadius = radius - 10;
    final double x3Offset = center.dx + (secondRadius * cos(angle));
    final double y3Offset = center.dy + (secondRadius * sin(angle));
    final thirdOffset = Offset(x3Offset, y3Offset);

    final double x4Offset = center.dx + (secondRadius * cos(secondAngle));
    final double y4Offset = center.dy + (secondRadius * sin(secondAngle));
    final forthOffset = Offset(x4Offset, y4Offset);

    final path = Path();
    path.moveTo(firstOffset.dx, firstOffset.dy);
    path.lineTo(secondOffset.dx, secondOffset.dy);
    path.lineTo(thirdOffset.dx, thirdOffset.dy);
    path.lineTo(forthOffset.dx, forthOffset.dy);
    path.lineTo(firstOffset.dx, firstOffset.dy);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4);

    final double textXOffset = center.dx + ((radius - 25) * cos(secondAngle));
    final double textYOffset = center.dy + ((radius - 25) * sin(secondAngle));
    final textOffset = Offset(textXOffset, textYOffset);
    drawText(canvas, size, textOffset, value);
  }

  void drawText(Canvas canvas, Size size, Offset offset, int value) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    var text = value.toString();
    if (value > 1000) {
      text = '${value ~/ 1000}k';
    }
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = offset.dx - textPainter.width / 2;
    final yCenter = offset.dy - textPainter.height / 2;
    final centerOffset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, centerOffset);
  }

  @override
  bool shouldRepaint(_ElectricityMeterPainter oldDelegate) => true;
}
