# Buno: screen visual tests

Flutter implementations of single Brand Board screens, built to check how
closely the supplied design translates to Flutter. Only these screens exist;
the flows between them are deliberately left out.

| Screen | Board page | Route |
|---|---|---|
| Onboarding (3 slides) | 1–3 | `/onboarding` |
| Login (e-mail or Sign in with Apple) | 4 | `/login` |
| Sign-up (e-mail or Sign in with Apple) | 5 | `/signup` |
| Code verification (sent to e-mail) | 6 | `/verify` |
| Home | 7 | `/` |
| Active rental timer | 10 | `/rental` |
| Wallet | 12 | `/wallet` |
| Profile | — (not on the board) | `/profile` |

Flow: onboarding → sign-up → code → Home, or onboarding → login → Home.
The bottom nav switches Home / Wallet / Profile. Auth is mocked
(`lib/data/mock_auth.dart`): nothing is sent anywhere and any 4-digit code
passes.

```bash
flutter pub get
flutter run                    # Home
flutter run --route /login     # any route above (web: open /#/login)
flutter test                   # overflow + RTL checks at 6 phone sizes, interactions
```

## Layout

```
lib/
  main.dart                         MaterialApp, Arabic locale (RTL), dark theme
  app_routes.dart                   route table, tab navigation
  data/mock_auth.dart               mocked sign-in / sign-up / code check
  theme/buno_tokens.dart            supplied Flutter tokens (verbatim)
  theme/buno_tokens_ext.dart        size / stroke / motion / type tokens from tokens.css + typography.md
  widgets/                          reusable pieces
    buno_icon.dart                  supplied SVG icons, sizes locked to 18 / 22 / 28
    buno_logo.dart                  supplied logo SVG
    buno_text.dart                  Arabic text with numbers in Sora, isolated LTR
    buno_buttons.dart               primary CTA + secondary button
    buno_search_field.dart
    buno_chip.dart
    buno_station_card.dart          station info card
    buno_charge_ring.dart           charge ring (12 o'clock, clockwise, glow)
    buno_charge_bar.dart            8pt power-bank charge bar
    buno_status_pill.dart           outlined status pill
    buno_page_dots.dart             page indicator (RTL reading order)
    buno_text_field.dart            input, checkbox, text link, "or" divider, OTP cells
    buno_back_button.dart           41pt outlined back button (44pt target)
    buno_tab_header.dart            tab-screen header + section title
    buno_dashed_button.dart         dashed "add" button
    buno_bottom_nav.dart
    map_markers.dart                station / selected station / user markers
  screens/home/
    home_screen.dart                composition + bottom sheet
    home_top_bar.dart               logo, battery pill, profile button
    mock_map.dart                   local mock map (no maps SDK)
  screens/onboarding/
    onboarding_screen.dart          3-slide PageView, skip, CTA, "have an account"
    onboarding_illustrations.dart   the three disc illustrations, drawn in code
  screens/auth/                     login, sign-up, code verification, shared frame,
                                    Sign in with Apple button
  screens/wallet/                   balance card, payment methods, transactions
  screens/profile/                  user card, account/help menus, logout
  screens/rental/
    active_rental_screen.dart       timer ring, cost rows, nearest station, actions
assets/                             supplied SVGs + Sora / Readex Pro TTFs;
                                    assets/brand/apple-logo.svg is Simple Icons (CC0)
docs/                               screenshots
```
