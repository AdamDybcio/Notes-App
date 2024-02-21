import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme.dart';
import '../bloc/cubit/auth_form_cubit.dart';
import '../widgets/login_screen/auth_forms/login_form.dart';
import '../widgets/login_screen/auth_forms/register_form.dart';
import '../widgets/login_screen/footer/author_footer.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Welcome!',
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
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child: Image.asset('lib/core/assets/app_logo.png')
                        .animate()
                        .scale(duration: 1500.ms, curve: Curves.bounceOut)
                        .shimmer(
                            delay: 1500.ms,
                            duration: 2500.ms,
                            curve: Curves.linear),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              BlocBuilder<AuthCubit, AuthFormState>(
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
                  ).animate().scale(
                      delay: 1000.ms,
                      duration: 1500.ms,
                      curve: Curves.bounceOut);
                },
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: const AuthorFooter()
                      .animate()
                      .fadeIn(duration: 750.ms, curve: Curves.linear),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
