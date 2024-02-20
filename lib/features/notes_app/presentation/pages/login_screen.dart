import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme.dart';
import '../bloc/cubit/auth_cubit.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/register_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Notes Storage',
              style: TextStyle(
                color: AppTheme.lightTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const SizedBox(height: 60.0), // Wolne miejsce na logo aplikacji
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: state is AuthChangingForm ? 0.0 : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: AppTheme.backgroundColor,
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.shadowColor,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: state is AuthLoginForm
                          ? LoginForm(authCubit: authCubit)
                          : (state is AuthRegisterForm
                              ? RegisterForm(authCubit: authCubit)
                              : state is AuthChangingForm
                                  ? (state.prevState is AuthLoginForm
                                      ? LoginForm(authCubit: authCubit)
                                      : RegisterForm(authCubit: authCubit))
                                  : null),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
