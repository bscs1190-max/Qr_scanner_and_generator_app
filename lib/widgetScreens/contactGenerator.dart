import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/database_helper.dart';
import '../models/scan_models.dart';
import '../services/saveQrServices.dart';
import '../services/shareQrServices.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();

  String qrData = "";

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  Future<void> generateQR() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter contact name")),
      );
      return;
    }

    setState(() {
      qrData =
          '''
BEGIN:VCARD
VERSION:3.0
FN:${nameController.text.trim()}
ORG:${companyController.text.trim()}
TEL:${phoneController.text.trim()}
EMAIL:${emailController.text.trim()}
ADR:${addressController.text.trim()}
URL:${websiteController.text.trim()}
END:VCARD
''';
    });

    await DatabaseHelper.instance.insertGeneratedQR(
      ScanModel(
        type: "contact",
        title: "Contact",
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
          "Contact QR",
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
                Icons.contact_page_rounded,
                size: 52,
                color: Color(0xFF8C6A4A),
              ),
            ),

            const SizedBox(height: 30),
            _field(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 16),

            _field(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            _field(
              controller: emailController,
              hint: "Email Address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            _field(
              controller: companyController,
              hint: "Company",
              icon: Icons.business_outlined,
            ),

            const SizedBox(height: 16),

            _field(
              controller: addressController,
              hint: "Address",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),

            _field(
              controller: websiteController,
              hint: "Website",
              icon: Icons.language_outlined,
            ),

            const SizedBox(height: 30),

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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF4A3325), fontSize: 16),
      decoration: fieldDecoration(hint, icon),
    );
  }
}
