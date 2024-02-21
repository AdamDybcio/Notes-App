part of 'auth_form_cubit.dart';

class AuthFormState {
  AuthFormState();
}

class AuthLoginForm extends AuthFormState {
  AuthLoginForm();
}

class AuthChangingForm extends AuthFormState {
  final AuthFormState prevState;
  AuthChangingForm(this.prevState);
}

class AuthRegisterForm extends AuthFormState {
  AuthRegisterForm();
}
