import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../theme/buno_tokens.dart';
import '../../theme/buno_tokens_ext.dart';
import '../../widgets/buno_bottom_nav.dart';
import '../../widgets/buno_dashed_button.dart';
import '../../widgets/buno_icon.dart';
import '../../widgets/buno_pressable.dart';
import '../../widgets/buno_tab_header.dart';
import '../../widgets/buno_text.dart';
import '../auth/auth_scaffold.dart' show showBunoToast;

/// Bottom-nav items shared by the tab screens.
const bunoNavItems = [
  BunoNavItem(icon: BunoIcons.home, label: 'الرئيسية'),
  BunoNavItem(icon: BunoIcons.history, label: 'رحلاتي'),
  BunoNavItem(icon: BunoIcons.wallet, label: 'المحفظة'),
  BunoNavItem(icon: BunoIcons.profile, label: 'حسابي'),
];

class WalletTransaction {
  const WalletTransaction(this.title, this.subtitle, this.amount, {this.credit = false});

  final String title;
  final String subtitle;
  final String amount;
  final bool credit;
}

/// Wallet — Brand Board page 12. Mock data only; amounts stay as the
/// board's placeholders until real pricing exists.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _gutter = 24.0;
  static const _navIndex = 2;

  static const _transactions = [
    WalletTransaction('إيجار بونو', '[اسم المكان] · امبارح', '-[السعر]'),
    WalletTransaction('شحن المحفظة', 'فيزا 4417 · السبت', '+[المبلغ]', credit: true),
    WalletTransaction('إيجار بونو', '[اسم المكان] · الخميس', '-[السعر]'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BunoDark.background,
      bottomNavigationBar: BunoBottomNav(
        items: bunoNavItems,
        currentIndex: _navIndex,
        onSelected: (i) => AppRoutes.goToTab(context, i, _navIndex),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(_gutter, 21, _gutter, 24),
          children: [
            const BunoTabHeader(title: 'المحفظة'),
            const SizedBox(height: 19.3),
            _BalanceCard(
              onTopUp: () => showBunoToast(context, 'شحن المحفظة هييجي في الخطوة الجاية'),
              onPromo: () => showBunoToast(context, 'كود الخصم هييجي في الخطوة الجاية'),
            ),
            const SizedBox(height: 19.6),
            const BunoSectionTitle('طرق الدفع'),
            const SizedBox(height: 10.6),
            const _PaymentMethodRow(label: 'فيزا تنتهي بـ 4417', primary: true),
            const SizedBox(height: 12),
            BunoDashedButton(
              label: 'ضيف طريقة دفع',
              onPressed: () => showBunoToast(context, 'إضافة كارت هتيجي في الخطوة الجاية'),
            ),
            const SizedBox(height: 18),
            const BunoSectionTitle('آخر العمليات'),
            for (final t in _transactions) _TransactionRow(t),
          ],
        ),
      ),
    );
  }
}

/// Green balance card with "top up" (ink fill) and "promo code" (outline).
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.onTopUp, required this.onPromo});

  final VoidCallback onTopUp;
  final VoidCallback onPromo;

  @override
  Widget build(BuildContext context) {
    const ink = BunoDark.on_primary;
    return Container(
      height: 181,
      padding: const EdgeInsets.fromLTRB(20, 20.4, 20, 20),
      decoration: BoxDecoration(
        color: BunoColors.primary,
        borderRadius: BorderRadius.circular(BunoRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('رصيدك', style: BunoType.bodySm.copyWith(height: 1.2, color: ink)),
          const Spacer(),
          // An amount reads left-to-right ("[balance] EGP"), as on the board.
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: '[الرصيد] ', style: BunoType.display.copyWith(fontSize: 35, height: 1.1, color: ink)),
                const TextSpan(
                  text: 'EGP',
                  style: TextStyle(
                    fontFamily: BunoFonts.sora,
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    height: 1.1,
                    letterSpacing: -1,
                    color: ink,
                  ),
                ),
              ]),
              textDirection: TextDirection.ltr,
            ),
          ),
          const SizedBox(height: 9.2),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _CardButton(label: 'اشحن المحفظة', filled: true, onTap: onTopUp),
              ),
              const SizedBox(width: 10),
              Expanded(child: _CardButton(label: 'كود خصم', filled: false, onTap: onPromo)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({required this.label, required this.filled, required this.onTap});

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BunoPressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? BunoDark.on_primary : null,
          borderRadius: BorderRadius.circular(BunoRadius.lg),
          border: filled ? null : Border.all(color: BunoDark.on_primary.withValues(alpha: 0.22)),
        ),
        child: Text(
          label,
          style: BunoType.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: filled ? BunoDark.text_primary : BunoDark.on_primary,
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({required this.label, this.primary = false});

  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: BunoDark.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BunoDark.border),
      ),
      child: Row(
        children: [
          const BunoIcon(BunoIcons.wallet, color: BunoDark.text_primary),
          const SizedBox(width: 12),
          Expanded(
            child: BunoText(
              label,
              style: BunoType.body.copyWith(fontSize: 13, fontWeight: FontWeight.w500, height: 1.2),
            ),
          ),
          if (primary)
            Text(
              'الأساسية',
              style: BunoType.caption.copyWith(color: BunoColors.secondary),
            ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow(this.t);

  final WalletTransaction t;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.5,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BunoDark.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: BunoType.title.copyWith(fontSize: 16, fontWeight: FontWeight.w700, height: 1.3)),
                BunoText(
                  t.subtitle,
                  style: BunoType.caption.copyWith(fontWeight: FontWeight.w400, height: 1.4, color: BunoDark.text_secondary),
                ),
              ],
            ),
          ),
          Text(
            t.amount,
            style: BunoType.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: t.credit ? BunoColors.secondary : BunoDark.text_primary,
            ),
          ),
        ],
      ),
    );
  }
}
