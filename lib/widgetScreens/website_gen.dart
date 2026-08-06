import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/database_helper.dart';
import '../models/scan_models.dart';
import '../services/saveQrServices.dart';
import '../services/shareQrServices.dart';

class WebsiteGenerator extends StatefulWidget {
  const WebsiteGenerator({super.key});

  @override
  State<WebsiteGenerator> createState() => _WebsiteGeneratorState();
}

class _WebsiteGeneratorState extends State<WebsiteGenerator> {
  final TextEditingController websiteController = TextEditingController();

  String qrData = "";

  @override
  void dispose() {
    websiteController.dispose();
    super.dispose();
  }

  Future<void> generateQR() async {
    String website = websiteController.text.trim();

    if (website.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a website")));
      return;
    }

    if (!website.startsWith("http://") && !website.startsWith("https://")) {
      website = "https://$website";
    }

    setState(() {
      qrData = website;
    });

    await DatabaseHelper.instance.insertGeneratedQR(
      ScanModel(
        type: "website",
        title: "Website",
        rawData: qrData,
        date: DateTime.now().toString(),
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
        backgroundColor: const Color(0xFFFDF7F0),
        surfaceTintColor: Colors.transparent,

        iconTheme: const IconThemeData(color: Color(0xFF6B4A33)),

        title: const Text(
          "Website QR",
          style: TextStyle(
            color: Color(0xFF4A3427),
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
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: const Icon(
                Icons.language_rounded,
                color: Color(0xFF6B4A33),
                size: 52,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: websiteController,

              style: const TextStyle(color: Color(0xFF4A3427), fontSize: 16),

              decoration: InputDecoration(
                hintText: "https://example.com",

                hintStyle: const TextStyle(color: Color(0xFF9B8878)),

                prefixIcon: const Icon(
                  Icons.language,
                  color: Color(0xFF6B4A33),
                ),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),

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
                  backgroundColor: const Color(0xFF6B4A33),
                  foregroundColor: Colors.white,

                  elevation: 8,

                  shadowColor: Colors.brown,

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

                  borderRadius: BorderRadius.circular(24),

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
                  size: 240,
                  version: QrVersions.auto,
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
                        backgroundColor: const Color(0xFF6B4A33),
                        foregroundColor: Colors.white,

                        elevation: 6,

                        padding: const EdgeInsets.symmetric(vertical: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),

                        shadowColor: Colors.brown.withOpacity(.35),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ShareQRService.shareQR(context, qrData);
                      },

                      icon: const Icon(Icons.share_rounded),

                      label: const Text(
                        "Share",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: const Color(0xFF6B4A33),

                        elevation: 6,

                        side: const BorderSide(
                          color: Color(0xFFD8A15A),
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
