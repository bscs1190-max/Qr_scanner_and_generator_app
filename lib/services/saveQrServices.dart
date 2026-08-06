import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SaveQRService {
  static Future<void> saveQR(
      BuildContext context,
      String data,
      ) async {
    try {
      final painter = QrPainter(
        data: data,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      final ui.Image image = await painter.toImage(1000);

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception("Unable to generate QR.");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();

      final file = File(
        "${dir.path}/QR_${DateTime.now().millisecondsSinceEpoch}.png",
      );

      await file.writeAsBytes(pngBytes);

      await Gal.putImage(file.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("QR Saved to Gallery"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}