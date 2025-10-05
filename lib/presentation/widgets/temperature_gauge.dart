import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/constants/app_colors.dart';

class TemperatureGauge extends StatelessWidget {
  final double temperature;
  final String label;
  final double minTemp;
  final double maxTemp;

  const TemperatureGauge({
    Key? key,
    required this.temperature,
    required this.label,
    this.minTemp = 0,
    this.maxTemp = 100,
  }) : super(key: key);

  Color _getTemperatureColor() {
    if (temperature < 40) return AppColors.success;
    if (temperature < 60) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: GaugePainter(
              value: temperature,
              minValue: minTemp,
              maxValue: maxTemp,
              color: _getTemperatureColor(),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${temperature.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getTemperatureColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final Color color;

  GaugePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi * 0.75,
      pi * 1.5,
      false,
      backgroundPaint,
    );

    final percentage = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    final sweepAngle = pi * 1.5 * percentage;

    final foregroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.5), color],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi * 0.75,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) =>
      value != oldDelegate.value || color != oldDelegate.color;
}
