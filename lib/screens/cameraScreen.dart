import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../database/database_helper.dart';
import '../models/scan_models.dart';
import '../services/qr_actions.dart';
import '../utils/qr_parser.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();

  bool scanned = false;

  late AnimationController scanController;

  @override
  void initState() {
    super.initState();

    scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2219),

      body: Stack(
        children: [
          /// CAMERA
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (scanned) return;

              final barcode = capture.barcodes.first;
              final value = barcode.rawValue;

              if (value == null || value.isEmpty) return;

              scanned = true;

              try {
                final result = QRParser.parse(value);

                String title = "";

                switch (result.type) {
                  case QRType.website:
                    title = "Website";
                    break;

                  case QRType.wifi:
                    title = "WiFi";
                    break;

                  case QRType.phone:
                    title = "Phone";
                    break;

                  case QRType.sms:
                    title = "SMS";
                    break;

                  case QRType.email:
                    title = "Email";
                    break;

                  case QRType.location:
                    title = "Location";
                    break;

                  case QRType.contact:
                    title = "Contact";
                    break;

                  case QRType.text:
                    title = "Text";
                    break;
                }

                await DatabaseHelper.instance.insertScan(
                  ScanModel(
                    type: result.type.name,
                    title: title,
                    rawData: value,
                    date: DateTime.now().toString(),
                  ),
                );

                if (!mounted) return;

                await Future.delayed(const Duration(milliseconds: 300));

                await QRActions.performAction(context, result);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF5A4031),
                      content: Text(
                        e.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }

              await Future.delayed(const Duration(seconds: 2));

              scanned = false;
            },
          ),

          /// DARK OVERLAY
          Container(color: Colors.black.withOpacity(.28)),

          /// QR OVERLAY
          QRScannerOverlay(
            overlayColor: Colors.black.withOpacity(.72),
            borderColor: const Color(0xFFE6D2BF),
            borderRadius: 28,
            scanAreaWidth: 285,
            scanAreaHeight: 285,
          ),

          /// SCAN ANIMATION
          Center(
            child: AnimatedBuilder(
              animation: scanController,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(0, -145 + (scanController.value * 290)),
                  child: Container(
                    width: 288,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6D2BF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE6D2BF).withOpacity(.9),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// TOP PREMIUM CARD
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3526).withOpacity(.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFE6D2BF).withOpacity(.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Color(0xFFE6D2BF),
                    size: 28,
                  ),

                  SizedBox(width: 12),

                  Text(
                    "Scan QR Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// TOP CARD
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3325).withOpacity(.95),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: const Color(0xFFE6D2BF).withOpacity(.45),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.40),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Color(0xFFE6D2BF),
                    size: 28,
                  ),

                  SizedBox(width: 12),

                  Text(
                    "Scan QR Code",
                    style: TextStyle(
                      color: Color(0xFFF8F2EA),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// FLASH BUTTON
          Positioned(
            bottom: 120,
            right: 55,
            child: FloatingActionButton(
              heroTag: "flash",
              elevation: 8,

              backgroundColor: const Color(0xFFE6D2BF),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),

                side: const BorderSide(color: Color(0xFFE6D2BF), width: 1.5),
              ),

              onPressed: () {
                controller.toggleTorch();
              },

              child: const Icon(
                Icons.flash_on_rounded,
                color:Color(0xFF4A3325),
                size: 28,
              ),
            ),
          ),

          /// SWITCH CAMERA
          Positioned(
            bottom: 120,
            left: 55,
            child: FloatingActionButton(
              heroTag: "camera",
              elevation: 8,

              backgroundColor: const Color(0xFFE6D2BF),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),

                side: const BorderSide(color: Color(0xFFE6D2BF), width: 1.5),
              ),

              onPressed: () {
                controller.switchCamera();
              },

              child: const Icon(
                Icons.cameraswitch_rounded,
                color: Color(0xFF4A3325),
                size: 28,
              ),
            ),
          ),

          /// Bottom Instruction
          Positioned(
            bottom: 35,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3325).withOpacity(.88),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE6D2BF).withOpacity(.25),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.center_focus_strong,
                    color: Color(0xFFE6D2BF),
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Align QR code within the frame",
                    style: TextStyle(
                      color: Color(0xFFF5E7D6),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
