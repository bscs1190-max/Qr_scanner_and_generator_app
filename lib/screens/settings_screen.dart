import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, "Preferences"),
            const SizedBox(height: 10),
            _buildVibrateTile(context),
            const SizedBox(height: 12),
            _buildThemeTile(context),
            const SizedBox(height: 30),
            _sectionHeader(context, "Support"),
            const SizedBox(height: 10),
            _buildRateUsTile(context),
            const SizedBox(height: 30),
            _sectionHeader(context, "Privacy"),
            const SizedBox(height: 10),
            _buildPrivacyTile(context),
            const SizedBox(height: 30),
            _sectionHeader(context, "About"),
            const SizedBox(height: 10),
            _buildShareTile(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _settingCard(BuildContext context, Widget child) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline, width: 1.2),
      ),
      child: child,
    );
  }

  Widget _iconBox(BuildContext context, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: cs.onPrimaryContainer, size: 22),
    );
  }

  Widget _buildVibrateTile(BuildContext context) {
    return _settingCard(
      context,
      Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                _iconBox(context, Icons.vibration_rounded),
                const SizedBox(width: 14),
                Text(
                  "Vibrate on Scan",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            value: settings.vibrateOnScan,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (_) => settings.toggleVibrate(),
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return _settingCard(
      context,
      Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final cs = Theme.of(context).colorScheme;
          return SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: cs.onPrimaryContainer,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            value: themeProvider.isDarkMode,
            activeTrackColor: cs.primary,
            onChanged: (_) => themeProvider.toggleTheme(),
          );
        },
      ),
    );
  }

  Widget _buildRateUsTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _settingCard(
      context,
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _iconBox(context, Icons.star_rounded),
        title: Text(
          "Rate Us",
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "Love the app? Leave a review!",
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        onTap: () async {
          final uri = Uri.parse(
            "https://play.google.com/store/apps/details?id=com.example.app",
          );
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }

  Widget _buildPrivacyTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _settingCard(
      context,
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _iconBox(context, Icons.shield_rounded),
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "Read how we handle your data",
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        onTap: () async {
          final uri = Uri.parse("https://your-privacy-policy-url.com");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }

  Widget _buildShareTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return _settingCard(
      context,
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: _iconBox(context, Icons.share_rounded),
        title: Text(
          "Share This App",
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "Tell your friends about QR Generator",
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
        onTap: () {
          SharePlus.instance.share(
            ShareParams(
              text: "Check out QR Generator - Scan & Generate QR Codes!",
            ),
          );
        },
      ),
    );
  }
}
