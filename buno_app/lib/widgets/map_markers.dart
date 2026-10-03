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
  const StationMarker({
    super.key,
    required this.availability,
    this.onTap,
    this.size = 30,
    this.strokeWidth = BunoStroke.emphasis,
  });

  final StationAvailability availability;
  final VoidCallback? onTap;
  final double size;
  final double strokeWidth;

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
                  width: strokeWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Selected station: a Buno-green ring on a soft green halo, showing the
/// ready count in Sora (Home) or, when [readyCount] is null, a solid centre
/// dot (onboarding illustration).
class SelectedStationMarker extends StatelessWidget {
  const SelectedStationMarker({
    super.key,
    this.readyCount,
    this.size = 40,
    this.haloSize = 60,
    this.strokeWidth = BunoStroke.emphasis,
    this.haloOpacity = 0.18,
    this.dotSize = 15,
  });

  final int? readyCount;
  final double size;
  final double haloSize;
  final double strokeWidth;
  final double haloOpacity;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: readyCount == null ? 'المحطة المختارة' : 'المحطة المختارة، $readyCount جاهزين',
      child: Container(
        width: haloSize,
        height: haloSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BunoColors.primary.withValues(alpha: haloOpacity),
        ),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BunoDark.background,
            border: Border.all(color: BunoColors.primary, width: strokeWidth),
          ),
          child: readyCount == null
              ? Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BunoColors.primary,
                  ),
                )
              : Text(
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
  const UserLocationMarker({super.key, this.size = 21, this.borderWidth = BunoStroke.emphasis});

  final double size;
  final double borderWidth;

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
          border: Border.all(color: BunoDark.background, width: borderWidth),
        ),
      ),
    );
  }
}
