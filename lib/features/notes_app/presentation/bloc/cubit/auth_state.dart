part of 'auth_cubit.dart';

class AuthState {
  AuthState();
}

class AuthLoginForm extends AuthState {
  AuthLoginForm();
}

class AuthChangingForm extends AuthState {
  final AuthState prevState;
  AuthChangingForm(this.prevState);
}

class AuthRegisterForm extends AuthState {
  AuthRegisterForm();
}

class AuthTry extends AuthState {
  AuthTry();
}

class AuthSuccess extends AuthState {
  AuthSuccess();
}

class AuthError extends AuthState {
  AuthError();
}
