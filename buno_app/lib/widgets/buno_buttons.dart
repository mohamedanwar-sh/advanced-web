import 'package:flutter/widgets.dart';

import '../theme/buno_tokens.dart';
import '../theme/buno_tokens_ext.dart';
import 'buno_icon.dart';
import 'buno_pressable.dart';

/// Primary button (components.md): 56 high, radius 16, `--color-primary`
/// fill, label always `#0A0A0B` (never white). One per screen.
class BunoPrimaryButton extends StatelessWidget {
  const BunoPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final BunoIcons? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BunoPressable(
      onTap: onPressed,
      semanticLabel: label,
      child: Container(
        height: BunoSize.buttonLg,
        decoration: BoxDecoration(
          color: BunoColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              BunoIcon(icon!, color: BunoDark.on_primary),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: BunoType.button.copyWith(
                color: BunoDark.on_primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Secondary button (components.md): transparent, 1px `--color-border`,
/// radius 16, label `--color-text-primary` 600.
class BunoSecondaryButton extends StatelessWidget {
  const BunoSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.icon,
    this.iconColor = BunoDark.text_secondary,
    this.compact = false,
    this.labelSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final BunoIcons? icon;
  final Color iconColor;

  /// Half-width variant (pair of buttons): 18pt icon, 13pt label.
  final bool compact;

  /// Overrides the label size (defaults: 14, or 13 when [compact]).
  final double? labelSize;

  @override
  Widget build(BuildContext context) {
    return BunoPressable(
      onTap: onPressed,
      semanticLabel: label,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BunoDark.border, width: BunoStroke.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              BunoIcon(
                icon!,
                color: iconColor,
                size: compact ? BunoSize.iconSm : BunoSize.iconMd,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: BunoType.button.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: labelSize ?? (compact ? 13 : 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
