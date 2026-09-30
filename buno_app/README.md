# Buno: Home screen visual test

A one-screen Flutter implementation of **Brand Board page 7 (Home)**, built to
check how closely the supplied design translates to Flutter. Only this screen
exists; the other flows are deliberately left out.

```bash
flutter pub get
flutter run            # Android / iOS device or simulator
flutter test           # overflow + RTL checks at 6 phone sizes, basic interactions
```

## Layout

```
lib/
  main.dart                         MaterialApp, Arabic locale (RTL), dark theme
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
    buno_bottom_nav.dart
    map_markers.dart                station / selected station / user markers
  screens/home/
    home_screen.dart                composition + bottom sheet
    home_top_bar.dart               logo, battery pill, profile button
    mock_map.dart                   local mock map (no maps SDK)
assets/                             supplied SVGs + Sora / Readex Pro TTFs
docs/                               screenshots
```
