import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/database_helper.dart';
import '../models/scan_models.dart';
import '../services/saveQrServices.dart';
import '../services/shareQrServices.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final ssidController = TextEditingController();
  final passwordController = TextEditingController();

  String encryption = "WPA";
  String qrData = "";

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> generateQR() async {
    if (ssidController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter WiFi Name")));
      return;
    }

    setState(() {
      qrData =
          "WIFI:T:$encryption;S:${ssidController.text.trim()};P:${passwordController.text.trim()};;";
    });

    await DatabaseHelper.instance.insertGeneratedQR(
      ScanModel(
        type: "wifi",
        title: "WiFi",
        rawData: qrData,
        date: DateTime.now().toString(),
      ),
    );
  }

  InputDecoration fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(color: Color(0xFF9B8878)),

      prefixIcon: Icon(icon, color: const Color(0xFF8C6A4A)),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE7D8CA)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFD8A15A), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFFDF7F0),

        iconTheme: const IconThemeData(color: Color(0xFF8C6A4A)),

        title: const Text(
          "WiFi QR",
          style: TextStyle(
            color: Color(0xFF4A3325),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),

        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,

                border: Border.all(color: const Color(0xFFD8A15A), width: 1.5),

                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(.12),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),

              child: const Icon(
                Icons.wifi_rounded,
                color: Color(0xFF8C6A4A),
                size: 50,
              ),
            ),

            const SizedBox(height: 30),
            TextField(
              controller: ssidController,
              style: const TextStyle(color: Color(0xFF4A3325), fontSize: 16),
              decoration: fieldDecoration(
                "WiFi Name (SSID)",
                Icons.wifi_rounded,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Color(0xFF4A3325), fontSize: 16),
              decoration: fieldDecoration(
                "Password",
                Icons.lock_outline_rounded,
              ),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: encryption,

              dropdownColor: Colors.white,

              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF8C6A4A),
              ),

              style: const TextStyle(color: Color(0xFF4A3325), fontSize: 16),

              decoration: InputDecoration(
                labelText: "Encryption",

                labelStyle: const TextStyle(color: Color(0xFF9B8878)),

                filled: true,
                fillColor: Colors.white,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Color(0xFFE7D8CA)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8A15A),
                    width: 2,
                  ),
                ),
              ),

              items: const [
                DropdownMenuItem(value: "WPA", child: Text("WPA")),
                DropdownMenuItem(value: "WEP", child: Text("WEP")),
                DropdownMenuItem(value: "nopass", child: Text("Open")),
              ],

              onChanged: (value) {
                setState(() {
                  encryption = value!;
                });
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: generateQR,

                icon: const Icon(Icons.qr_code_rounded),

                label: const Text(
                  "Generate QR",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C6A4A),
                  foregroundColor: Colors.white,

                  elevation: 8,

                  shadowColor: const Color(0xFF8C6A4A).withOpacity(.35),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),
            if (qrData.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFE7D8CA)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(.12),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  size: 235,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await SaveQRService.saveQR(context, qrData);
                      },

                      icon: const Icon(Icons.download_rounded),

                      label: const Text(
                        "Save",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C6A4A),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color(0xFF8C6A4A).withOpacity(.35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ShareQRService.shareQR(context, qrData);
                      },

                      icon: const Icon(Icons.share_rounded),

                      label: const Text(
                        "Share",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8C6A4A),
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF8C6A4A),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}
