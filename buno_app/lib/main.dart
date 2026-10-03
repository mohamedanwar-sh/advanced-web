import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_routes.dart';
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
      // `flutter run --route /login` etc. opens a screen directly
      // (on web: `/#/login`). See AppRoutes for the list.
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
