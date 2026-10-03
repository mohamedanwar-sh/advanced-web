import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/verify_code_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/rental/active_rental_screen.dart';
import 'screens/wallet/wallet_screen.dart';

/// Route names. `flutter run --route <name>` (or `/#<name>` on web) opens a
/// screen directly.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const verify = '/verify';
  static const rental = '/rental';
  static const wallet = '/wallet';
  static const profile = '/profile';

  /// Bottom-nav tabs, in nav order. `null` = not built yet (رحلاتي).
  static const tabs = [home, null, wallet, profile];

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget? page = switch (settings.name) {
      home => const HomeScreen(),
      onboarding => const OnboardingScreen(),
      login => const LoginScreen(),
      signup => const SignupScreen(),
      verify => const VerifyCodeScreen(),
      rental => const ActiveRentalScreen(),
      wallet => const WalletScreen(),
      profile => const ProfileScreen(),
      _ => null,
    };
    if (page == null) return null;
    // Switching tabs is instant, like a tab bar; everything else slides.
    if (tabs.contains(settings.name)) {
      return PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (_, _, _) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  /// Bottom-nav handler shared by Home, Wallet and Profile.
  static void goToTab(BuildContext context, int index, int current) {
    if (index == current) return;
    final name = tabs[index];
    if (name == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('رحلاتي هتكون جاهزة قريب'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ));
      return;
    }
    Navigator.of(context).pushReplacementNamed(name);
  }

  /// Leaves the auth flow for the app, clearing the back stack.
  static void enterApp(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil(home, (_) => false);
}
