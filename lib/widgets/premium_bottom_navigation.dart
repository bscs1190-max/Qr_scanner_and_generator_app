import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              height: 76,

              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,

                borderRadius: BorderRadius.circular(30),

                border: Border.all(
                  color: cs.outline,
                  width: 1.2,
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _item(context, index: 0, icon: Icons.qr_code_scanner_rounded, text: "Scan"),
                  _item(context, index: 1, icon: Icons.dashboard_customize_rounded, text: "Home"),
                  _item(context, index: 2, icon: Icons.history_rounded, text: "History"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String text,
  }) {
    final cs = Theme.of(context).colorScheme;
    bool selected = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(index),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,

        padding: EdgeInsets.symmetric(
          horizontal: selected ? 18 : 14,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              size: 23,
              color: selected ? cs.onPrimary : cs.onSurfaceVariant,
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),

              child: selected
                  ? Row(
                children: [
                  const SizedBox(width: 8),

                  Text(
                    text,
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
