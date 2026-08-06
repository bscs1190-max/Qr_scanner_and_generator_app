import 'package:hive/hive.dart';

part 'scan_models.g.dart';

@HiveType(typeId: 0)
class ScanModel extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  String title;

  @HiveField(2)
  String rawData;

  @HiveField(3)
  String date;

  ScanModel({
    required this.type,
    required this.title,
    required this.rawData,
    required this.date,
  });
}