import 'package:flutter/widgets.dart';

import '../../theme/buno_tokens.dart';
import '../../theme/buno_tokens_ext.dart';
import '../../widgets/buno_icon.dart';
import '../../widgets/buno_logo.dart';
import '../../widgets/buno_pressable.dart';

/// Logo on the start side (right in RTL); battery status and profile on the
/// end side (left in RTL).
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.batteryPercent, this.onProfile});

  final int batteryPercent;
  final VoidCallback? onProfile;

  /// Logo box height that makes the wordmark ink 59pt wide, as in the reference.
  static const _logoHeight = 26.9;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Pull the SVG's built-in right padding out so the ring's outer edge sits
    // on the content edge, like the search field below it.
    final logoNudge = BunoLogo.inkEndInset * _logoHeight / 120;
    return SizedBox(
      height: BunoSize.touchMin,
      child: Row(
        children: [
          Transform.translate(
            offset: Offset(rtl ? logoNudge : -logoNudge, 0),
            child: const BunoLogo(height: _logoHeight),
          ),
          const Spacer(),
          _BatteryStatus(percent: batteryPercent),
          const SizedBox(width: 8),
          _ProfileButton(onTap: onProfile),
        ],
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BunoPressable(
      onTap: onTap ?? () {},
      semanticLabel: 'حسابي',
      // 44pt touch target around the 40pt visual.
      child: SizedBox.square(
        dimension: BunoSize.touchMin,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BunoDark.card,
              border: Border.all(color: BunoDark.border, width: BunoStroke.hairline),
            ),
            child: const BunoIcon(BunoIcons.profile, color: BunoDark.text_primary),
          ),
        ),
      ),
    );
  }
}

/// Phone battery status pill ("18%" in Sora, warning colour when low).
class _BatteryStatus extends StatelessWidget {
  const _BatteryStatus({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final color = percent <= 20 ? BunoColors.warning : BunoColors.secondary;
    return Semantics(
      label: 'شحن موبايلك $percent%',
      excludeSemantics: true,
      child: Container(
        height: 32,
        padding: const EdgeInsetsDirectional.only(start: 10, end: 12),
        decoration: BoxDecoration(
          color: BunoDark.card,
          borderRadius: BorderRadius.circular(BunoRadius.pill),
          border: Border.all(color: BunoDark.border, width: BunoStroke.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BunoIcon(BunoIcons.battery, size: BunoSize.iconSm, color: color),
            const SizedBox(width: 4),
            Text(
              '$percent%',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: BunoFonts.sora,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
