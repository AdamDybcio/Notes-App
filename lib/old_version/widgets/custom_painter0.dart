import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.redAccent.shade400.withOpacity(0.9)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.0866667, size.height * 0.9166667);
    path0.cubicTo(
        size.width * 0.0061000,
        size.height * 0.9154333,
        size.width * 0.0094333,
        size.height * 0.0861333,
        size.width * 0.0881333,
        size.height * 0.0839000);
    path0.cubicTo(
        size.width * 0.0907000,
        size.height * -0.0171000,
        size.width * 0.9166667,
        size.height * 0.0068000,
        size.width * 0.9185667,
        size.height * 0.0814667);
    path0.cubicTo(
        size.width * 0.9969333,
        size.height * 0.0798667,
        size.width * 0.9907667,
        size.height * 0.9195333,
        size.width * 0.9170667,
        size.height * 0.9200000);
    path0.cubicTo(
        size.width * 0.9165667,
        size.height * 0.9991667,
        size.width * 0.0861333,
        size.height * 0.9900000,
        size.width * 0.0866667,
        size.height * 0.9166667);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
