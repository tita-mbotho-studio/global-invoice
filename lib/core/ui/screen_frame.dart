import 'package:flutter/widgets.dart';

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: child,
          ),
        ),
      );
}
