import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../data/mock_auth.dart';
import '../../theme/buno_tokens.dart';
import '../../theme/buno_tokens_ext.dart';
import '../../widgets/buno_buttons.dart';
import '../../widgets/buno_icon.dart';
import '../../widgets/buno_text_field.dart';
import 'apple_sign_in_button.dart';
import 'auth_scaffold.dart';

/// Sign-up — Brand Board page 5, with e-mail instead of phone and a
/// "Sign in with Apple" (iCloud) option under the main action.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _agreed = true;
  bool _busy = false;
  String? _nameError, _emailError, _passwordError, _termsError;
  late final _termsTap = TapGestureRecognizer()
    ..onTap = () => showBunoToast(context, 'الشروط والأحكام');
  late final _privacyTap = TapGestureRecognizer()
    ..onTap = () => showBunoToast(context, 'سياسة الخصوصية');

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _nameError = _name.text.trim().isEmpty ? 'اكتب اسمك' : null;
      _emailError = MockAuth.isValidEmail(_email.text)
          ? null
          : 'اكتب إيميل صحيح';
      _passwordError = MockAuth.isValidPassword(_password.text)
          ? null
          : 'كلمة السر لازم تكون 8 حروف على الأقل';
      _termsError = _agreed ? null : 'لازم توافق على الشروط الأول';
    });
    final errors = [_nameError, _emailError, _passwordError, _termsError];
    if (errors.any((e) => e != null)) return;
    setState(() => _busy = true);
    await MockAuth.signUp(_name.text, _email.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    Navigator.of(context).pushNamed(AppRoutes.verify);
  }

  Future<void> _apple() async {
    await MockAuth.signInWithApple();
    if (mounted) AppRoutes.enterApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final link = BunoType.body.copyWith(fontSize: 13);
    return AuthScaffold(
      footer: AuthFooter(
        question: 'عندك حساب بالفعل؟',
        action: BunoTextLink(
          'سجّل دخول',
          style: BunoType.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(AppRoutes.login),
        ),
      ),
      children: [
        const SizedBox(height: 36),
        const AuthTitle(
          title: 'اعمل حساب',
          subtitle: 'دقيقة واحدة وتبقى جاهز تاخد أول بونو.',
        ),
        const SizedBox(height: 26.4),
        BunoTextField(
          label: 'الاسم',
          hint: 'اسمك بالكامل',
          icon: BunoIcons.profile,
          controller: _name,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          errorText: _nameError,
        ),
        const SizedBox(height: 16),
        BunoTextField(
          label: 'الإيميل',
          hint: 'name@email.com',
          icon: BunoIcons.mail,
          controller: _email,
          ltrContent: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: _emailError,
        ),
        const SizedBox(height: 16),
        BunoTextField(
          label: 'كلمة السر',
          hint: '8 حروف على الأقل',
          icon: BunoIcons.lock,
          controller: _password,
          obscure: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          errorText: _passwordError,
        ),
        // The whole row toggles the box, so the 22pt checkbox keeps a full
        // touch target while sitting 10pt from its label as on the board.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _agreed = !_agreed),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: BunoSize.touchMin),
            child: Row(
              children: [
                Semantics(
                  checked: _agreed,
                  child: BunoCheckbox.bare(value: _agreed),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: link.copyWith(color: BunoDark.text_secondary),
                      children: [
                        const TextSpan(text: 'موافق على '),
                        TextSpan(
                          text: 'الشروط والأحكام',
                          style: const TextStyle(
                            color: BunoColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: _termsTap,
                        ),
                        const TextSpan(text: ' و'),
                        TextSpan(
                          text: 'سياسة الخصوصية',
                          style: const TextStyle(
                            color: BunoColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: _privacyTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_termsError != null)
          Text(
            _termsError!,
            style: BunoType.caption.copyWith(color: BunoColors.error),
          ),
        const SizedBox(height: 10),
        BunoPrimaryButton(
          label: 'إنشاء الحساب',
          loading: _busy,
          onPressed: _submit,
        ),
        const SizedBox(height: 24),
        const BunoOrDivider(),
        const SizedBox(height: 24),
        AppleSignInButton(label: 'التسجيل بـ Apple', onPressed: _apple),
      ],
    );
  }
}
