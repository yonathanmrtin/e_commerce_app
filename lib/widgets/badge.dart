import 'package:flutter/material.dart';

/// A widget that displays a notification badge on top of its child.
class Badge extends StatelessWidget {
  /// The widget below the badge in the stack.
  final Widget child;

  /// The text value to display in the badge.
  final String value;

  /// The color of the badge. Defaults to the theme's secondary color.
  final Color? color;

  const Badge({
    super.key,
    required this.child,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // This is the widget that the badge will be displayed on top of (e.g., an icon).
        child,

        // We only show the badge if the value is not '0'.
        // This prevents showing an empty or '0' badge when the cart is empty.
        if (value != '0')
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              // A BoxDecoration to style the badge.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color ?? Theme.of(context).colorScheme.secondary,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
