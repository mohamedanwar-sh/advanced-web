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
  data/phone_battery.dart           live phone battery (battery_plus)
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
assets/app_icon/                    supplied app-icon PNGs (source for the launcher icons)
assets/                             supplied SVGs + Sora / Readex Pro TTFs;
                                    assets/brand/apple-logo.svg is Simple Icons (CC0)
docs/                               screenshots
```

## App icon

Generated from the supplied `buno-design-system/app-icon` files with
`dart run flutter_launcher_icons` (config in `pubspec.yaml`):

- **iOS** — the supplied 1024 icon flattened onto its own `#0A0A0B`
  background (`assets/app_icon/buno-app-icon-1024-square.png`), because the
  App Store rejects transparency and iOS applies its own rounded mask.
- **Android** — adaptive icon: supplied foreground on `#0A0A0B`, no extra
  inset (the art already sits in the safe zone); the supplied rounded icon
  for legacy launchers.
- **Web** — the supplied 192/512 PNGs, maskable icons from the square
  version, and the supplied green favicon.

Preview: `docs/app_icon_preview.png`. After regenerating, revert the
`ios/Runner.xcodeproj/project.pbxproj` edit the tool makes
(it sets `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`
to `AppIcon`, which is a bug).

## Phone battery (Home header)

The battery pill on Home shows the phone's real charge, read with
[`battery_plus`](https://pub.dev/packages/battery_plus) in
`lib/data/phone_battery.dart`:

- updates immediately when the phone is plugged in or unplugged, every 30 s
  while the app is open, and whenever the app returns to the foreground;
- orange with the low-battery icon at 20% or less, mint otherwise; the full
  icon at 80%+; the charging bolt while charging;
- shows `--%` when the battery can't be read: the **iOS Simulator has no
  battery** (use a real iPhone), and Safari/Firefox don't expose the
  browser Battery API.

No permissions are needed on Android or iOS. States: `docs/battery_states.png`.
