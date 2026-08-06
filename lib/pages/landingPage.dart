import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_scanner_app/pages/homePage.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2B1D16),
              Color(0xFF3A271E),
              Color(0xFF4A3325),
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(
              children: [

                const SizedBox(height: 40),

                /// LOGO

                const SizedBox(height: 28),

                const Text(
                  "QR Generator",
                  style: TextStyle(
                    color: Color(0xFFE6D2BF),
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Generate & Scan QR Codes\nBeautiful • Fast • Secure",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD8A15A),
                    fontSize: 17,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 35),

                /// Logo Image

                Padding(
                  padding: const EdgeInsets.all(18),

                  child: Image.asset(
                    "assets/images/qr_generator_refined_logo.png",
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFE6D2BF),
                      foregroundColor: const Color(0xFF2B1D16),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_launched', true);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Homepage(),
                        ),
                      );
                    },

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(width: 10),

                        Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Powered by QR Generator",
                  style: TextStyle(
                    color: Color(0xFFBFA388),
                    letterSpacing: 1,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}