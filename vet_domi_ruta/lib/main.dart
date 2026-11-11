import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database_helper.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Asegura la inicialización y semillero de SQLite al arrancar
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Database initialization notice: $e');
  }

  runApp(
    const ProviderScope(
      child: VetDomiRutaApp(),
    ),
  );
}

class VetDomiRutaApp extends StatelessWidget {
  const VetDomiRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetDomiRuta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}
