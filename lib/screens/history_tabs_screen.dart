import 'package:flutter/material.dart';

import 'generated_history_screen.dart';
import 'historyScreen.dart';

class HistoryTabsScreen extends StatelessWidget {
  const HistoryTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.qr_code_scanner_rounded),
                  text: "Scanned",
                ),
                Tab(
                  icon: Icon(Icons.qr_code_2_rounded),
                  text: "Generated",
                ),
              ],
            ),

            // TabBarView is swipeable left/right by default,
            // giving you the slider behaviour between the two screens.
            const Expanded(
              child: TabBarView(
                children: [
                  HistoryScreen(),
                  GeneratedHistoryScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
