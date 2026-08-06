import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/scan_models.dart';
import 'pages/landingPage.dart';
import 'pages/homePage.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';

const Color _brown = Color(0xFF5B3924);
const Color _darkBrown = Color(0xFF3D2B1F);
const Color _cream = Color(0xFFF7EFE6);
const Color _creamCard = Color(0xFFFDF7F0);
const Color _lightBrown = Color(0xFFF3E4D4);
const Color _mediumBrown = Color(0xFF8B6B52);
const Color _borderLight = Color(0xFFE7D8CA);
const Color _gold = Color(0xFFD8A15A);

const Color _darkBg = Color(0xFF1A110D);
const Color _darkSurface = Color(0xFF2B1D16);
const Color _darkCard = Color(0xFF3A271E);
const Color _darkText = Color(0xFFE6D2BF);
const Color _darkBorder = Color(0xFF5A4031);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ScanModelAdapter());

  await Hive.openBox<ScanModel>('scan_history');
  await Hive.openBox<ScanModel>('generated_qr_history');

  final prefs = await SharedPreferences.getInstance();
  final showLanding = !(prefs.getBool('has_launched') ?? false);

  runApp(MyApp(showLanding: showLanding));
}

class MyApp extends StatelessWidget {
  final bool showLanding;
  const MyApp({super.key, required this.showLanding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: _cream,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: _brown,
                onPrimary: Colors.white,
                primaryContainer: _lightBrown,
                onPrimaryContainer: _darkBrown,
                secondary: _mediumBrown,
                onSecondary: Colors.white,
                secondaryContainer: Color(0xFFF0DCC6),
                onSecondaryContainer: Color(0xFF6B4B35),
                surface: _cream,
                onSurface: _darkBrown,
                surfaceContainerHighest: _creamCard,
                surfaceContainerLow: Color(0xFFF8EFE5),
                onSurfaceVariant: _mediumBrown,
                outline: _borderLight,
                outlineVariant: _gold,
                error: Color(0xFFBA1A1A),
                onError: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: _cream,
                iconTheme: IconThemeData(color: Color(0xFF6B4B35)),
                titleTextStyle: TextStyle(
                  color: _darkBrown,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: _darkBg,
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: _gold,
                onPrimary: _darkBg,
                primaryContainer: _darkCard,
                onPrimaryContainer: _darkText,
                secondary: Color(0xFFBFA388),
                onSecondary: _darkBg,
                secondaryContainer: _darkSurface,
                onSecondaryContainer: _darkText,
                surface: _darkBg,
                onSurface: _darkText,
                surfaceContainerHighest: _darkCard,
                surfaceContainerLow: Color(0xFF221712),
                onSurfaceVariant: Color(0xFFBFA388),
                outline: _darkBorder,
                outlineVariant: Color(0xFF6B4B35),
                error: Color(0xFFCF6679),
                onError: Color(0xFF1A110D),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: _darkSurface,
                iconTheme: IconThemeData(color: _darkText),
                titleTextStyle: TextStyle(
                  color: _darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            home: Scaffold(
              body: showLanding ? const Landingpage() : const Homepage(),
            ),
          );
        },
      ),
    );
  }
}
