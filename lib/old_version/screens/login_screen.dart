import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: loginController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          passwordFocus.requestFocus();
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        focusNode: passwordFocus,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
