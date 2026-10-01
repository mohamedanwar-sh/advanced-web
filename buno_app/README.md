# Buno: screen visual tests

Flutter implementations of single Brand Board screens, built to check how
closely the supplied design translates to Flutter. Only these screens exist;
the flows between them are deliberately left out.

| Screen | Board page | Route |
|---|---|---|
| Home | 7 | `/` |
| Active rental timer | 10 | `/rental` |

```bash
flutter pub get
flutter run                    # Home
flutter run --route /rental    # Active rental (web: open /#/rental)
flutter test                   # overflow + RTL checks at 6 phone sizes, interactions
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
    buno_charge_ring.dart           charge ring (12 o'clock, clockwise, glow)
    buno_charge_bar.dart            8pt power-bank charge bar
    buno_status_pill.dart           outlined status pill
    buno_bottom_nav.dart
    map_markers.dart                station / selected station / user markers
  screens/home/
    home_screen.dart                composition + bottom sheet
    home_top_bar.dart               logo, battery pill, profile button
    mock_map.dart                   local mock map (no maps SDK)
  screens/rental/
    active_rental_screen.dart       timer ring, cost rows, nearest station, actions
assets/                             supplied SVGs + Sora / Readex Pro TTFs
docs/                               screenshots
```
