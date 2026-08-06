import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String rawData;
  final IconData icon;

  final bool isWifi;

  final String? ssid;
  final String? password;
  final String? encryption;

  final VoidCallback? onConnect;
  final VoidCallback? onDelete;
  final VoidCallback? onOpen;

  const HistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rawData,
    required this.icon,
    this.isWifi = false,
    this.ssid,
    this.password,
    this.encryption,
    this.onConnect,
    this.onDelete,
    this.onOpen,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
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
              child: widget.isWifi
                  ? Column(
                      children: [
                        _row("SSID", widget.ssid ?? ""),
                        const SizedBox(height: 12),
                        _row("Password", widget.password ?? ""),
                        const SizedBox(height: 12),
                        _row("Security", widget.encryption ?? ""),
                      ],
                    )
                  : SelectableText(
                      widget.rawData,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
            ),

            const SizedBox(height: 18),

            Divider(color: cs.outline, thickness: 1),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.isWifi)
                  _button(
                    Icons.wifi_rounded,
                    "Connect",
                    widget.onConnect ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Connect feature coming soon"),
                            ),
                          );
                        },
                  ),

                if (widget.isWifi)
                  _button(Icons.key_rounded, "Password", () {
                    Clipboard.setData(
                      ClipboardData(text: widget.password ?? ""),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password Copied")),
                    );
                  }),

                _button(Icons.copy_rounded, "Copy", () {
                  Clipboard.setData(ClipboardData(text: widget.rawData));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Copied Successfully")),
                  );
                }),

                if (!widget.isWifi && widget.onOpen != null)
                  _button(Icons.open_in_new_rounded, "Open", widget.onOpen!),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 95,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),

          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),

            child: SelectableText(
              value,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
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
