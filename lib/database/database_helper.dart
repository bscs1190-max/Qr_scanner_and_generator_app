import 'package:hive/hive.dart';
import '../models/scan_models.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String boxName = 'scan_history';
  static const String generatedBoxName = 'generated_qr_history';

  Future<Box<ScanModel>> get _box async {
    return await Hive.openBox<ScanModel>(boxName);
  }

  Future<Box<ScanModel>> get _generatedBox async {
    return await Hive.openBox<ScanModel>(generatedBoxName);
  }

  // ---------------- SCANNED HISTORY ----------------

  /// INSERT
  Future<void> insertScan(ScanModel scan) async {
    final box = await _box;
    await box.add(scan);
  }

  /// GET ALL
  Future<List<ScanModel>> getAllScans() async {
    final box = await _box;
    return box.values.toList().reversed.toList();
  }

  /// DELETE ONE (Fixed for reversed list)
  Future<void> deleteScan(int index) async {
    final box = await _box;

    // Because history is shown in reverse order
    final actualIndex = box.length - 1 - index;

    if (actualIndex >= 0 && actualIndex < box.length) {
      await box.deleteAt(actualIndex);
    }
  }

  /// DELETE ALL
  Future<void> deleteAll() async {
    final box = await _box;
    await box.clear();
  }

  /// SEARCH
  Future<List<ScanModel>> search(String keyword) async {
    final box = await _box;

    return box.values
        .where(
          (scan) =>
      scan.title.toLowerCase().contains(keyword.toLowerCase()) ||
          scan.rawData.toLowerCase().contains(keyword.toLowerCase()),
    )
        .toList()
        .reversed
        .toList();
  }

  /// UPDATE
  Future<void> updateScan(int index, ScanModel scan) async {
    final box = await _box;

    final actualIndex = box.length - 1 - index;

    if (actualIndex >= 0 && actualIndex < box.length) {
      await box.putAt(actualIndex, scan);
    }
  }

  /// TOTAL SCANS
  Future<int> totalScans() async {
    final box = await _box;
    return box.length;
  }

  // ---------------- GENERATED QR HISTORY ----------------

  /// INSERT
  Future<void> insertGeneratedQR(ScanModel qr) async {
    final box = await _generatedBox;
    await box.add(qr);
  }

  /// GET ALL
  Future<List<ScanModel>> getAllGeneratedQRs() async {
    final box = await _generatedBox;
    return box.values.toList().reversed.toList();
  }

  /// DELETE ONE (index is position in the reversed list shown on screen,
  /// same convention as deleteScan above)
  Future<void> deleteGeneratedQR(int index) async {
    final box = await _generatedBox;

    final actualIndex = box.length - 1 - index;

    if (actualIndex >= 0 && actualIndex < box.length) {
      await box.deleteAt(actualIndex);
    }
  }

  /// DELETE ALL
  Future<void> deleteAllGeneratedQRs() async {
    final box = await _generatedBox;
    await box.clear();
  }

  /// TOTAL GENERATED
  Future<int> totalGeneratedQRs() async {
    final box = await _generatedBox;
    return box.length;
  }

  // ---------------- SHARED ----------------

  /// CLOSE
  Future<void> close() async {
    final box = await _box;
    final generatedBox = await _generatedBox;
    await box.close();
    await generatedBox.close();
  }
}
