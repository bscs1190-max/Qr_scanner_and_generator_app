import 'package:flutter/material.dart';
import 'package:qr_scanner_app/widgetScreens/contactGenerator.dart';
import 'package:qr_scanner_app/widgetScreens/wifiGenerator.dart';

import '../cards/qr_cards.dart';
import '../cards/qr_items.dart';
import '../widgetScreens/emailGenerator.dart';
import '../widgetScreens/phoneGenerator.dart';
import '../widgetScreens/smsGenerator.dart';
import '../widgetScreens/textGenerator.dart';
import '../widgetScreens/vCardGenerator.dart';
import '../widgetScreens/website_gen.dart';
import '../widgetScreens/whatsAppGenerator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,

      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: qrItems.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 18,
              mainAxisExtent: 132,
            ),

            itemBuilder: (context, index) {
              return QRCard(
                icon: qrItems[index]['icon'],
                title: qrItems[index]['title'],

                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WebsiteGenerator(),
                        ),
                      );
                      break;

                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TextGenerator(),
                        ),
                      );
                      break;

                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmailGenerator(),
                        ),
                      );
                      break;

                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PhoneGenerator(),
                        ),
                      );
                      break;

                    case 4:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactScreen(),
                        ),
                      );
                      break;

                    case 5:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SmsGenerator(),
                        ),
                      );
                      break;

                    case 6:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VCardGenerator(),
                        ),
                      );
                      break;

                    case 7:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WhatsAppGenerator(),
                        ),
                      );
                      break;

                    case 8:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WifiScreen(),
                        ),
                      );
                      break;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
