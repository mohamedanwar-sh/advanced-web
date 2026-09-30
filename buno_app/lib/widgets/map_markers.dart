import 'package:flutter/widgets.dart';

import '../theme/buno_tokens.dart';
import '../theme/buno_tokens_ext.dart';

/// Availability state of a station, which drives the marker ring colour.
enum StationAvailability { available, low, none }

extension on StationAvailability {
  Color get ringColor => switch (this) {
        StationAvailability.available => BunoColors.secondary,
        StationAvailability.low => BunoColors.warning,
        StationAvailability.none => BunoDark.text_disabled,
      };
}

/// Nearby (unselected) station marker: 30pt dark disc with a 3pt ring.
class StationMarker extends StatelessWidget {
  const StationMarker({super.key, required this.availability, this.onTap});

  static const size = 30.0;

  final StationAvailability availability;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: 'محطة بونو',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        // 44pt hit area around the 30pt visual.
        child: SizedBox.square(
          dimension: BunoSize.touchMin,
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BunoDark.background,
                border: Border.all(
                  color: availability.ringColor,
                  width: BunoStroke.emphasis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Selected station: 40pt ring in Buno green with the ready count in Sora,
/// sitting on a 60pt soft green halo.
class SelectedStationMarker extends StatelessWidget {
  const SelectedStationMarker({super.key, required this.readyCount});

  static const haloSize = 60.0;
  static const size = 40.0;

  final int readyCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'المحطة المختارة، $readyCount جاهزين',
      child: Container(
        width: haloSize,
        height: haloSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BunoColors.primary.withValues(alpha: 0.18),
        ),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BunoDark.background,
            border: Border.all(color: BunoColors.primary, width: BunoStroke.emphasis),
          ),
          child: Text(
            '$readyCount',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: BunoFonts.sora,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1,
              color: BunoDark.text_primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// The user's position: white dot with a dark outline.
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  static const size = 21.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'موقعك',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Pure white in the reference (#FFFFFF), brighter than text-primary.
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: BunoDark.background, width: BunoStroke.emphasis),
        ),
      ),
    );
  }
}
