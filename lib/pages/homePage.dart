import 'package:flutter/material.dart';

import '../screens/cameraScreen.dart';
import '../screens/history_tabs_screen.dart';
import '../screens/homeScreen.dart';
import '../screens/settings_screen.dart';
import '../widgets/premium_bottom_navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index = 1;

  final List<Widget> pages = const [
    CameraScreen(),
    HomeScreen(),
    HistoryTabsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      extendBody: true,

      appBar: AppBar(
        centerTitle: true,
        title: const Text("QR Generator"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.outlineVariant,
                  ),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: cs.onSecondaryContainer,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          color: cs.surface,
        ),
        child: IndexedStack(
          index: index,
          children: pages,
        ),
      ),

      bottomNavigationBar: PremiumBottomNavigation(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
