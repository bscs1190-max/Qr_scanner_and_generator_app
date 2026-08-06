import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cards/history_card.dart';
import '../database/database_helper.dart';
import '../models/scan_models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScanModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() {
    historyFuture = DatabaseHelper.instance.getAllScans();
  }

  Future<void> refreshHistory() async {
    setState(() {
      loadHistory();
    });
  }

  IconData getIcon(String type) {
    switch (type) {
      case "website":
        return Icons.language;

      case "wifi":
        return Icons.wifi;

      case "phone":
        return Icons.phone;

      case "sms":
        return Icons.sms;

      case "email":
        return Icons.email;

      case "location":
        return Icons.location_on;

      case "contact":
        return Icons.person;

      default:
        return Icons.qr_code;
    }
  }

  Future<void> openQR(String type, String data) async {
    Uri? uri;

    switch (type) {
      case "website":
        if (!data.startsWith("http")) {
          uri = Uri.parse("https://$data");
        } else {
          uri = Uri.parse(data);
        }
        break;

      case "phone":
        uri = Uri.parse(data);
        break;

      case "sms":
        uri = Uri.parse(data);
        break;

      case "email":
        uri = Uri.parse(data);
        break;

      case "location":
        uri = Uri.parse(data);
        break;

      default:
        return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> deleteDialog(BuildContext context, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure you want to delete this scan?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel",style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B3924)),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );

    if (result == true) {
      await DatabaseHelper.instance.deleteScan(index);
      refreshHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshHistory,
          child: FutureBuilder<List<ScanModel>>(
            future: historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Scan History",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                    ),
                  ),
                );
              }

              final history = snapshot.data!;
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final scan = history[index];

                  return HistoryCard(
                    title: scan.title,
                    subtitle: scan.date,
                    rawData: scan.rawData,
                    icon: getIcon(scan.type),

                    isWifi: scan.type == "wifi",

                    ssid: scan.type == "wifi"
                        ? scan.rawData
                              .split(";")
                              .firstWhere(
                                (e) => e.startsWith("S:"),
                                orElse: () => "",
                              )
                              .replaceFirst("S:", "")
                        : "",

                    password: scan.type == "wifi"
                        ? scan.rawData
                              .split(";")
                              .firstWhere(
                                (e) => e.startsWith("P:"),
                                orElse: () => "",
                              )
                              .replaceFirst("P:", "")
                        : "",

                    encryption: scan.type == "wifi"
                        ? scan.rawData
                              .split(";")
                              .firstWhere(
                                (e) => e.startsWith("T:"),
                                orElse: () => "",
                              )
                              .replaceFirst("T:", "")
                        : "",

                    onConnect: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("WiFi Connect Coming Soon"),
                        ),
                      );
                    },

                    onDelete: () async {
                      await deleteDialog(context, index);
                    },

                    onOpen: () async {
                      await openQR(scan.type, scan.rawData);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
