import 'package:flutter/material.dart';

import '../../../../../../core/themes/theme.dart';
import '../../../bloc/cubit/auth_form_cubit.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.authCubit,
  });

  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Repeat password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Implementuj logikę logowania/rejestracji
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: AppTheme.buttonText,
            backgroundColor: AppTheme.buttonColor,
          ),
          child: const Text('Create an acccount'),
        ),
        const SizedBox(height: 8.0),
        TextButton(
          onPressed: () {
            authCubit.changeForm();
          },
          child: const Text(
            'Have an account? Sign in',
            style: TextStyle(color: AppTheme.buttonColor),
          ),
        ),
      ],
    );
  }
}
