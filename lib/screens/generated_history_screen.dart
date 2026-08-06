import 'package:flutter/material.dart';

import '../cards/generated_history_card.dart';
import '../database/database_helper.dart';
import '../models/scan_models.dart';

class GeneratedHistoryScreen extends StatefulWidget {
  const GeneratedHistoryScreen({super.key});

  @override
  State<GeneratedHistoryScreen> createState() =>
      _GeneratedHistoryScreenState();
}

class _GeneratedHistoryScreenState extends State<GeneratedHistoryScreen> {
  late Future<List<ScanModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() {
    historyFuture = DatabaseHelper.instance.getAllGeneratedQRs();
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
        return Icons.qr_code_2;
    }
  }

  Future<void> deleteDialog(BuildContext context, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete"),
        content: const Text(
          "Are you sure you want to delete this generated QR?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B3924),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await DatabaseHelper.instance.deleteGeneratedQR(index);
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
                    "No Generated QR History",
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
                  final qr = history[index];

                  return GeneratedHistoryCard(
                    title: qr.title,
                    subtitle: qr.date,
                    rawData: qr.rawData,
                    icon: getIcon(qr.type),
                    onDelete: () async {
                      await deleteDialog(context, index);
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
