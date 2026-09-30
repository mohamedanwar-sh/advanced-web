import 'package:flutter/material.dart';

import '../../theme/buno_tokens.dart';
import '../../widgets/buno_bottom_nav.dart';
import '../../widgets/buno_buttons.dart';
import '../../widgets/buno_icon.dart';
import '../../widgets/buno_search_field.dart';
import '../../widgets/buno_station_card.dart';
import '../../widgets/map_markers.dart';
import 'home_top_bar.dart';
import 'mock_map.dart';

/// Home — Brand Board page 7. Mock data only.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  /// Horizontal screen margin measured on the reference (22pt).
  static const _gutter = 22.0;

  static const _station = StationInfo(
    name: '[اسم المكان]',
    meta: '[المسافة] · مشي [الوقت] · مفتوح لحد [الساعة]',
    readyCount: 5,
    highestCharge: 96,
    chips: ['[السعر] أول ساعة', 'بعدها بالدقيقة', 'رجّعه في أي محطة'],
  );

  static const _navItems = [
    BunoNavItem(icon: BunoIcons.home, label: 'الرئيسية'),
    BunoNavItem(icon: BunoIcons.history, label: 'رحلاتي'),
    BunoNavItem(icon: BunoIcons.wallet, label: 'المحفظة'),
    BunoNavItem(icon: BunoIcons.profile, label: 'حسابي'),
  ];

  void _onScan() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('الماسح هييجي في الخطوة الجاية'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BunoDark.background,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              // The profile button's 44pt touch target overhangs its 40pt
              // circle by 2pt; the reference aligns the circle to the gutter.
              padding: const EdgeInsetsDirectional.fromSTEB(
                  _gutter, 18, _gutter - 2, 12),
              child: Column(
                children: [
                  const HomeTopBar(batteryPercent: 18),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(end: 2),
                    child: BunoSearchField(hint: 'دوّر على محطة أو مكان'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // The map runs under the sheet so its rounded corners show map.
                const Positioned.fill(
                  bottom: -40,
                  child: MockMap(
                    stations: [
                      MapStation(Offset(78.5, 74), StationAvailability.available),
                      MapStation(Offset(318.2, 119.5), StationAvailability.low),
                      MapStation(Offset(296.3, 285.7), StationAvailability.available),
                    ],
                    selected: Offset(205.5, 164.2),
                    selectedReadyCount: 5,
                    user: Offset(140.1, 255.7),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _StationSheet(
                    gutter: _gutter,
                    station: _station,
                    onScan: _onScan,
                    onShowAll: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // In the Scaffold slot so toasts float above it (components.md Toast).
      bottomNavigationBar: BunoBottomNav(
        items: _navItems,
        currentIndex: _tab,
        onSelected: (i) => setState(() => _tab = i),
      ),
    );
  }
}

/// Bottom sheet holding the selected station (components.md "Bottom sheet":
/// radius 28 top corners, 40x5 grab handle).
class _StationSheet extends StatelessWidget {
  const _StationSheet({
    required this.gutter,
    required this.station,
    required this.onScan,
    required this.onShowAll,
  });

  final double gutter;
  final StationInfo station;
  final VoidCallback onScan;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BunoDark.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(BunoRadius.xxl)),
        border: Border(
          top: BorderSide(color: BunoDark.border),
          left: BorderSide(color: BunoDark.border),
          right: BorderSide(color: BunoDark.border),
        ),
      ),
      padding: EdgeInsets.fromLTRB(gutter, 13, gutter, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: BunoDark.border,
                borderRadius: BorderRadius.circular(BunoRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 11),
          BunoStationCard(station: station),
          const SizedBox(height: 12),
          BunoPrimaryButton(
            label: 'امسح وخد بونو',
            icon: BunoIcons.scan,
            onPressed: onScan,
          ),
          const SizedBox(height: 12),
          // The reference draws this action 44pt high (the touch minimum),
          // not the 52pt default of the secondary-button spec.
          BunoSecondaryButton(
            label: 'وريني كل المحطات القريبة',
            height: 44,
            onPressed: onShowAll,
          ),
        ],
      ),
    );
  }
}
