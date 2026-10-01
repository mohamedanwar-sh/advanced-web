import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/buno_tokens.dart';
import '../../theme/buno_tokens_ext.dart';
import '../../widgets/buno_buttons.dart';
import '../../widgets/buno_charge_bar.dart';
import '../../widgets/buno_charge_ring.dart';
import '../../widgets/buno_icon.dart';
import '../../widgets/buno_logo.dart';
import '../../widgets/buno_status_pill.dart';
import '../../widgets/buno_text.dart';

/// Active rental — Brand Board page 10. Mock data only.
class ActiveRentalScreen extends StatefulWidget {
  const ActiveRentalScreen({
    super.key,
    this.initialElapsed = const Duration(hours: 1, minutes: 12),
    this.unitId = 7,
    this.ringProgress = 0.655,
    this.bankCharge = 0.64,
  });

  final Duration initialElapsed;
  final int unitId;

  /// Share of the ring filled (the reference shows ~65%).
  final double ringProgress;
  final double bankCharge;

  @override
  State<ActiveRentalScreen> createState() => _ActiveRentalScreenState();
}

class _ActiveRentalScreenState extends State<ActiveRentalScreen> {
  static const _gutter = 22.0;

  late Duration _elapsed = widget.initialElapsed;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _elapsed += const Duration(minutes: 1));
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toast(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BunoDark.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(_gutter, 20, _gutter, 0),
                      child: _Header(unitId: widget.unitId),
                    ),
                    const SizedBox(height: 38),
                    Center(
                      child: BunoChargeRing(
                        progress: widget.ringProgress,
                        size: 196,
                        child: _TimerReadout(elapsed: _elapsed),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _CostCard(bankCharge: widget.bankCharge),
                    const SizedBox(height: 18.7),
                    const _NearestStationCard(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(_gutter, 24, _gutter, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BunoPrimaryButton(
                            label: 'ودّيني لأقرب محطة',
                            icon: BunoIcons.location,
                            onPressed: () => _toast('الخريطة هتفتح على أقرب محطة'),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: BunoSecondaryButton(
                                  label: 'مش بيشحن',
                                  icon: BunoIcons.warning,
                                  iconColor: BunoColors.warning,
                                  height: BunoSize.touchMin,
                                  compact: true,
                                  onPressed: () => _toast('هنساعدك تبدّل البونو'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BunoSecondaryButton(
                                  label: 'تفاصيل الحساب',
                                  icon: BunoIcons.receipt,
                                  height: BunoSize.touchMin,
                                  compact: true,
                                  onPressed: () => _toast('تفاصيل الحساب'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.unitId});

  final int unitId;

  static const _logoHeight = 24.4;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final nudge = BunoLogo.inkEndInset * _logoHeight / 120;
    return Row(
      children: [
        Transform.translate(
          offset: Offset(rtl ? nudge : -nudge, 0),
          child: const BunoLogo(height: _logoHeight),
        ),
        const Spacer(),
        BunoStatusPill('إيجار شغّال · بونو #${unitId.toString().padLeft(2, '0')}'),
      ],
    );
  }
}

/// "01:12" in Sora inside the ring, with the spelled-out duration below.
class _TimerReadout extends StatelessWidget {
  const _TimerReadout({required this.elapsed});

  final Duration elapsed;

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _spoken(int h, int m) {
    final hours = switch (h) {
      0 => '',
      1 => 'ساعة',
      2 => 'ساعتين',
      _ => '$h ساعات',
    };
    if (m == 0) return hours.isEmpty ? 'لسه بادئ' : hours;
    final minutes = '$m دقيقة';
    return hours.isEmpty ? minutes : '$hours و$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final h = elapsed.inHours, m = elapsed.inMinutes % 60;
    return Semantics(
      label: 'مدة الإيجار ${_spoken(h, m)}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5.4),
          Text(
            '${_two(h)}:${_two(m)}',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: BunoFonts.sora,
              fontWeight: FontWeight.w700,
              fontSize: 46,
              height: 1,
              letterSpacing: -0.03 * 46,
              color: BunoDark.text_primary,
            ),
          ),
          const SizedBox(height: 9.4),
          BunoText(
            _spoken(h, m),
            style: BunoType.bodySm.copyWith(height: 1.2, color: BunoDark.text_secondary),
          ),
        ],
      ),
    );
  }
}

/// Cost so far, per-minute rate, time to the daily cap, power-bank charge.
class _CostCard extends StatelessWidget {
  const _CostCard({required this.bankCharge});

  final double bankCharge;

  @override
  Widget build(BuildContext context) {
    final valueStyle = BunoType.body.copyWith(height: 1.2, fontWeight: FontWeight.w700);
    return _EdgeCard(
      inset: 3.3,
      padding: const EdgeInsets.fromLTRB(18.7, 5.5, 18.7, 11.6),
      child: Column(
        children: [
          _InfoRow(
            label: 'دفعت لحد دلوقتي',
            value: Text('[السعر] جنيه', style: valueStyle.copyWith(color: BunoColors.primary)),
          ),
          _InfoRow(label: 'كل دقيقة جاية', value: Text('[السعر] قرش', style: valueStyle)),
          _InfoRow(label: 'هتوصل للحد الأقصى بعد', value: Text('[المدة]', style: valueStyle)),
          _InfoRow(
            label: 'شحن البونو',
            divider: false,
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BunoChargeBar(value: bankCharge),
                const SizedBox(width: 8),
                Text(
                  '${(bankCharge * 100).round()}%',
                  textDirection: TextDirection.ltr,
                  style: BunoType.number(BunoType.caption).copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: BunoColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.divider = true});

  final String label;
  final Widget value;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.5,
      decoration: divider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: BunoDark.border)),
            )
          : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: BunoType.body.copyWith(height: 1.2, color: BunoDark.text_secondary),
            ),
          ),
          value,
        ],
      ),
    );
  }
}

class _NearestStationCard extends StatelessWidget {
  const _NearestStationCard();

  @override
  Widget build(BuildContext context) {
    return _EdgeCard(
      inset: 6.3,
      padding: const EdgeInsets.fromLTRB(14.4, 13, 14.4, 11.6),
      child: Row(
        children: [
          const BunoIcon(BunoIcons.location, color: BunoColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أقرب محطة ترجّع فيها',
                  style: BunoType.body.copyWith(fontSize: 14, height: 1.3, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.7),
                BunoText(
                  '[اسم المكان] · [المسافة] · فيها [العدد] خانات فاضية',
                  maxLines: 1,
                  style: BunoType.caption.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    color: BunoDark.text_secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card surface placed with the reference's small screen-edge inset (the
/// board draws these two cards almost full-bleed while their content keeps
/// the 22pt gutter).
class _EdgeCard extends StatelessWidget {
  const _EdgeCard({required this.inset, required this.padding, required this.child});

  final double inset;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inset),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: BunoDark.card,
          borderRadius: BorderRadius.circular(BunoRadius.xl),
          border: Border.all(color: BunoDark.border),
        ),
        child: child,
      ),
    );
  }
}
