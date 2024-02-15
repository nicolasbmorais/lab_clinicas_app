// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/services/login_service.dart';
import 'package:signals_flutter/signals_flutter.dart';

class LoginController with MessageStateMixin {
  final UserLoginServiceInterface _userLoginService;
  LoginController({
    required UserLoginServiceInterface userLoginService,
  }) : _userLoginService = userLoginService;

  final _obscurePassword = signal(true);
  bool get obscurePassword => _obscurePassword();

  final _logged = signal(false);
  bool get logged => _logged();

  void passwordToogle() => _obscurePassword.value = !_obscurePassword.value;

  Future<void> login(String email, String password) async {
    final response =
        await _userLoginService.execute(email, password).asyncLoader();

    switch (response) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: _):
      _logged.value = true;
    }
  }
}
