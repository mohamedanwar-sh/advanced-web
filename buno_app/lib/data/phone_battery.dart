import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/widgets.dart';

/// One reading of the phone's battery.
@immutable
class BatteryReading {
  const BatteryReading({required this.percent, required this.charging});

  /// Not readable on this device (e.g. the iOS Simulator, or browsers
  /// without the Battery Status API).
  const BatteryReading.unknown()
      : percent = null,
        charging = false;

  /// 0–100, or null when unknown.
  final int? percent;
  final bool charging;

  bool get isKnown => percent != null;

  @override
  bool operator ==(Object other) =>
      other is BatteryReading && other.percent == percent && other.charging == charging;

  @override
  int get hashCode => Object.hash(percent, charging);
}

/// Where readings come from. The real implementation uses `battery_plus`;
/// tests pass a fake.
abstract class BatteryReader {
  Future<int> level();
  Future<BatteryState> state();
  Stream<BatteryState> get stateChanges;
}

class PlusBatteryReader implements BatteryReader {
  PlusBatteryReader([Battery? battery]) : _battery = battery ?? Battery();

  final Battery _battery;

  @override
  Future<int> level() => _battery.batteryLevel;

  @override
  Future<BatteryState> state() => _battery.batteryState;

  @override
  Stream<BatteryState> get stateChanges => _battery.onBatteryStateChanged;
}

/// Live phone battery level for the UI.
///
/// The platforms only push charging-state changes, not level changes, so the
/// level is re-read when the state changes, every [pollEvery] while the app
/// is in the foreground, and whenever the app comes back to the foreground.
class PhoneBattery extends ChangeNotifier with WidgetsBindingObserver {
  PhoneBattery({BatteryReader? reader, this.pollEvery = const Duration(seconds: 30)})
      : _reader = reader ?? PlusBatteryReader();

  /// App-wide instance used by the screens. Tests may replace it.
  static PhoneBattery shared = PhoneBattery();

  final BatteryReader _reader;
  final Duration pollEvery;

  BatteryReading _reading = const BatteryReading.unknown();
  BatteryReading get reading => _reading;

  StreamSubscription<BatteryState>? _stateSub;
  Timer? _poll;
  int _listeners = 0;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (_listeners++ == 0) _start();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (--_listeners == 0) _stop();
  }

  void _start() {
    WidgetsBinding.instance.addObserver(this);
    _stateSub = _reader.stateChanges.listen(
      (_) => refresh(),
      onError: (Object _) => _set(const BatteryReading.unknown()),
    );
    _poll = Timer.periodic(pollEvery, (_) => refresh());
    refresh();
  }

  void _stop() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSub?.cancel();
    _stateSub = null;
    _poll?.cancel();
    _poll = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
      _poll ??= Timer.periodic(pollEvery, (_) => refresh());
    } else if (state == AppLifecycleState.paused) {
      _poll?.cancel();
      _poll = null;
    }
  }

  /// Reads the battery now.
  Future<void> refresh() async {
    try {
      final level = await _reader.level();
      final state = await _reader.state();
      // Some devices report -1 instead of throwing when the level is unknown.
      if (level < 0 || level > 100) return _set(const BatteryReading.unknown());
      _set(BatteryReading(
        percent: level,
        charging: state == BatteryState.charging,
      ));
    } catch (_) {
      _set(const BatteryReading.unknown());
    }
  }

  void _set(BatteryReading r) {
    if (r == _reading) return;
    _reading = r;
    notifyListeners();
  }
}
