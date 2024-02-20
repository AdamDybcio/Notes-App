import 'package:flutter/material.dart';
import 'package:notes_umk/old_version/screens/home_screen.dart';

import '../../../../../core/themes/theme.dart';
import '../../bloc/cubit/auth_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
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
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(false),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: AppTheme.buttonText,
            backgroundColor: AppTheme.buttonColor,
          ),
          child: const Text('Sign In'),
        ),
        const SizedBox(height: 8.0),
        TextButton(
          onPressed: () {
            authCubit.changeForm();
          },
          child: const Text(
            'Don\'t have an account? Sign up',
            style: TextStyle(color: AppTheme.buttonColor),
          ),
        ),
      ],
    );
  }
}
