import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FlowIndicator extends StatefulWidget {
  final double flowRate;
  final String label;
  final IconData icon;

  const FlowIndicator({
    Key? key,
    required this.flowRate,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  State<FlowIndicator> createState() => _FlowIndicatorState();
}

class _FlowIndicatorState extends State<FlowIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.flowRate > 0) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(FlowIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flowRate > 0 && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.flowRate == 0) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 5 * _controller.value),
                      child: Icon(
                        widget.icon,
                        size: 32,
                        color: widget.flowRate > 0
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.flowRate.toStringAsFixed(2)} L/min',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.flowRate > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
