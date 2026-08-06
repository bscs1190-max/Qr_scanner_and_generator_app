import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/qr_parser.dart';

class QRActions {
  static Future<void> performAction(
    BuildContext context,
    QRResult result,
  ) async {
    switch (result.type) {
      case QRType.website:
        await _openWebsite(result.rawData);
        break;

      case QRType.phone:
        await _makeCall(result.rawData);
        break;

      case QRType.sms:
        await _sendSMS(result.rawData);
        break;

      case QRType.email:
        await _sendEmail(result.rawData);
        break;

      case QRType.location:
        await _openLocation(result.rawData);
        break;

      case QRType.wifi:
        _showWifiDialog(context, result.rawData);
        break;

      case QRType.contact:
        _showContactDialog(context, result.rawData);
        break;

      case QRType.text:
        _showTextDialog(context, result.rawData);
        break;
    }
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint("Cannot launch $url");
    }
  }

  /// WEBSITE
  static Future<void> _openWebsite(String url) async {
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://$url";
    }

    await _launch(url);
  }

  /// PHONE
  static Future<void> _makeCall(String phone) async {
    phone = phone.replaceFirst("tel:", "");
    await _launch("tel:$phone");
  }

  /// SMS
  static Future<void> _sendSMS(String sms) async {
    await _launch(sms);
  }

  /// EMAIL
  static Future<void> _sendEmail(String email) async {
    await _launch(email);
  }

  /// LOCATION
  static Future<void> _openLocation(String geo) async {
    await _launch(geo);
  }

  /// WIFI
  static void _showWifiDialog(BuildContext context, String wifi) {
    String ssid = "";
    String password = "";
    String security = "";

    final parts = wifi.split(";");

    for (var part in parts) {
      if (part.startsWith("S:")) {
        ssid = part.substring(2);
      }

      if (part.startsWith("P:")) {
        password = part.substring(2);
      }

      if (part.startsWith("T:")) {
        security = part.substring(2);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Wi-Fi Network"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("SSID : $ssid"),
            Text("Password : $password"),
            Text("Security : $security"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: password));

              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Password Copied")));
            },
            child: const Text("Copy Password"),
          ),
        ],
      ),
    );
  }

  /// CONTACT
  static void _showContactDialog(BuildContext context, String contact) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact"),
        content: SingleChildScrollView(child: Text(contact)),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: contact));

              Navigator.pop(context);
            },
            child: const Text("Copy"),
          ),
        ],
      ),
    );
  }

  /// TEXT
  static void _showTextDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Scanned Text"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));

              Navigator.pop(context);
            },
            child: const Text("Copy"),
          ),
        ],
      ),
    );
  }
}
