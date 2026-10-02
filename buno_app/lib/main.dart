import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/rental/active_rental_screen.dart';
import 'theme/buno_tokens.dart';
import 'theme/buno_tokens_ext.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: const Color(0x00000000),
    systemNavigationBarColor: BunoDark.background,
  ));
  runApp(const BunoApp());
}

class BunoApp extends StatelessWidget {
  const BunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buno',
      debugShowCheckedModeBanner: false,
      // Arabic locale => Flutter lays the whole tree out right-to-left.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: BunoFonts.readex,
        scaffoldBackgroundColor: BunoDark.background,
        colorScheme: const ColorScheme.dark(
          primary: BunoColors.primary,
          onPrimary: BunoDark.on_primary,
          surface: BunoDark.surface,
          onSurface: BunoDark.text_primary,
          error: BunoColors.error,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: BunoColors.primary,
          selectionHandleColor: BunoColors.primary,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: BunoDark.elevated,
          contentTextStyle: BunoType.body,
        ),
      ),
      // `flutter run --route /onboarding` opens pages 1-3, `--route /rental`
      // opens page 10 (on web: `/#/onboarding`, `/#/rental`).
      routes: {
        '/': (_) => const HomeScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/rental': (_) => const ActiveRentalScreen(),
      },
    );
  }
}
