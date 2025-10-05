import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TankLevelWidget extends StatefulWidget {
  final double level;
  final double maxCapacity;

  const TankLevelWidget({
    Key? key,
    required this.level,
    required this.maxCapacity,
  }) : super(key: key);

  @override
  State<TankLevelWidget> createState() => _TankLevelWidgetState();
}

class _TankLevelWidgetState extends State<TankLevelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.maxCapacity > 0
        ? (widget.level / widget.maxCapacity * 100).clamp(0, 100)
        : 0;

    return CustomPaint(
      size: const Size(200, 300),
      painter: TankPainter(
        level: percentage.toDouble(),
        animation: _controller,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.level.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'L',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TankPainter extends CustomPainter {
  final double level;
  final Animation<double> animation;

  TankPainter({
    required this.level,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.grey.shade300;

    final tankRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
      const Radius.circular(20),
    );
    canvas.drawRRect(tankRect, paint);

    final liquidHeight = (size.height - 40) * (level / 100);
    final liquidTop = size.height - 20 - liquidHeight;

    final gradient = LinearGradient(
      colors: [
        AppColors.primary.withOpacity(0.7),
        AppColors.primary,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final liquidPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(20, liquidTop, size.width - 40, liquidHeight),
      );

    final path = Path();
    path.moveTo(20, liquidTop + 10 * animation.value);

    for (double i = 20; i < size.width - 20; i += 10) {
      final waveHeight = 5 * animation.value;
      path.lineTo(
        i,
        liquidTop + waveHeight * (i % 20 == 0 ? 1 : -1),
      );
    }

    path.lineTo(size.width - 20, liquidTop);
    path.lineTo(size.width - 20, size.height - 20);
    path.lineTo(20, size.height - 20);
    path.close();

    canvas.clipRRect(tankRect);
    canvas.drawPath(path, liquidPaint);
  }

  @override
  bool shouldRepaint(TankPainter oldDelegate) => true;
}
