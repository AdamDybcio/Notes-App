import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_form_state.dart';

class AuthCubit extends Cubit<AuthFormState> {
  AuthCubit() : super(AuthLoginForm());

  void changeForm() {
    if (state is AuthLoginForm) {
      emit(AuthChangingForm(AuthLoginForm()));
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        emit(AuthRegisterForm());
      });
    } else if (state is AuthRegisterForm) {
      emit(AuthChangingForm(AuthRegisterForm()));
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        emit(AuthLoginForm());
      });
    }
  }
}
