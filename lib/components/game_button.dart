import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onPressed;
  final double defaultSize;

  const GameButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
    this.defaultSize = 56,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = _isPressed ? widget.defaultSize * 0.71 : widget.defaultSize;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onPressed != null ? () {
                HapticFeedback.mediumImpact();
                widget.onPressed!();
              } : null,
              borderRadius: BorderRadius.circular(size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: size * 0.6,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
        )
      ],
    );
  }
}