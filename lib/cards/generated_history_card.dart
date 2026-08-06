import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/saveQrServices.dart';
import '../services/shareQrServices.dart';

class GeneratedHistoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String rawData;
  final IconData icon;

  final VoidCallback? onDelete;

  const GeneratedHistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rawData,
    required this.icon,
    this.onDelete,
  });

  @override
  State<GeneratedHistoryCard> createState() => _GeneratedHistoryCardState();
}

class _GeneratedHistoryCardState extends State<GeneratedHistoryCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final date = widget.subtitle.split(" ").first;

    final time = widget.subtitle.split(" ").length > 1
        ? widget.subtitle.split(" ")[1].split(".").first
        : "";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.brown.withValues(alpha: isDark ? 0.25 : 0.9),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    widget.icon,
                    color: cs.onPrimaryContainer,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 13,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            date,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            time,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECE8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: cs.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: cs.onPrimaryContainer,
                ),
              ],
            ),
          ),

          if (expanded) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outline),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QrImageView(
                      data: widget.rawData,
                      size: 160,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 14),

                  SelectableText(
                    widget.rawData,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Divider(color: cs.outline, thickness: 1),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(Icons.download_rounded, "Save", () async {
                  await SaveQRService.saveQR(context, widget.rawData);
                }),

                _button(Icons.share_rounded, "Share", () async {
                  await ShareQRService.shareQR(context, widget.rawData);
                }),

                _button(Icons.copy_rounded, "Copy", () {
                  Clipboard.setData(ClipboardData(text: widget.rawData));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied Successfully")),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _button(IconData icon, String text, VoidCallback onTap) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant, width: 1.2),
            ),
            child: Icon(icon, color: cs.onPrimaryContainer, size: 22),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
