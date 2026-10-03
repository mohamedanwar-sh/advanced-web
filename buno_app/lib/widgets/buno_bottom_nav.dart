import 'package:flutter/widgets.dart';

import '../theme/buno_tokens.dart';
import '../theme/buno_tokens_ext.dart';
import 'buno_icon.dart';

class BunoNavItem {
  const BunoNavItem({required this.icon, required this.label});

  final BunoIcons icon;
  final String label;
}

/// Bottom navigation (components.md): 72 high, up to 4 items, icon 22 +
/// label, active item in `--color-primary`, 1px top border, safe-area
/// padding added below.
class BunoBottomNav extends StatelessWidget {
  const BunoBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<BunoNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: BunoDark.background,
        border: Border(
          top: BorderSide(color: BunoDark.border, width: BunoStroke.hairline),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: BunoSize.bottomNav,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BunoNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? BunoColors.primary : BunoDark.text_secondary;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BunoIcon(item.icon, color: color),
            const SizedBox(height: 5),
            AnimatedDefaultTextStyle(
              duration: BunoMotion.fast,
              style: BunoType.caption.copyWith(
                fontSize: 11,
                height: 1.2,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
