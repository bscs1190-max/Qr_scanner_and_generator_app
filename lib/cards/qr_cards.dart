import 'package:flutter/material.dart';

class QRCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const QRCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        splashColor: cs.outlineVariant.withValues(alpha: 0.3),
        highlightColor: Colors.transparent,
        onTap: onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,

            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: cs.outline,
              width: 1.2,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.brown.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.brown.withValues(alpha: 0.9),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 14,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                /// Icon Circle
                Container(
                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: cs.primaryContainer,

                    border: Border.all(
                      color: cs.onPrimaryContainer,
                      width: 1.2,
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: cs.onPrimaryContainer,
                    size: 25,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    letterSpacing: .3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
