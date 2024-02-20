import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/repository.dart';
import '../screens/home_screen.dart';
import '../widgets/login_screen/title_text_widget.dart';
import '../widgets/login_screen/login_textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late FocusNode loginFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode repeatPasswordFocusNode;

  bool isLogging = false;
  bool isSigningUp = false;
  bool isNewUser = true;

  String mainText = 'Sign In';

  var userData;

  final Future<SharedPreferences> loadPrefs = SharedPreferences.getInstance();

  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();

  Future<SharedPreferences> loadData() async {
    final SharedPreferences prefs = await loadPrefs;
    return prefs;
  }

  @override
  void initState() {
    loginFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    repeatPasswordFocusNode = FocusNode();
    loadData().then((prefs) {
      if (prefs.getString('login') != null &&
          prefs.getString('password') != null) {
        login.text = prefs.getString('login').toString();
        password.text = prefs.getString('password').toString();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginFocusNode.dispose();
    passwordFocusNode.dispose();
    repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  Future loginUser({required String login, required String password}) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: '$login@notesapp.com', password: password)
        .then((value) {
      var document =
          FirebaseFirestore.instance.doc('users/${value.user!.uid.toString()}');
      document.get().then((doc) => userData = doc.data()).then((_) => {
            setState(() {
              isLogging = false;
            }),
            loadData().then((prefs) {
              prefs.setString('login', login.toString());
              prefs.setString('password', password.toString());
            }),
            Repository().checkIfNewUser(isNewUser).then((value) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: ((context) =>
                      HomeScreen(value, userData: userData))));
            }),
          });
    }).onError((error, stackTrace) {
      if (error.toString().contains('too-many-requests')) {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Too many login attempts. Please try again later.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      } else if (error.toString().contains('network-request-failed')) {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Check your internet connection.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      } else {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Incorrect login details.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      }
    });
  }

  Future registerUser({required String login, required String password}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: '$login@notesapp.com', password: password)
        .then((value) {
      var document = FirebaseFirestore.instance.collection('users');
      document.doc(value.user!.uid.toString()).set({
        'nickname': "",
        'login': login,
      }).then((_) async {
        var ref1 = await document.doc(value.user!.uid.toString()).get();
        var ref2 = ref1.data();
        userData = ref2;
        setState(() {
          isLogging = false;
        });
        loadData().then((prefs) {
          prefs.setString('login', login.toString());
          prefs.setString('password', password.toString());
        });
        Repository().checkIfNewUser(isNewUser).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => HomeScreen(value, userData: userData))));
        });
      });
    }).onError((error, stackTrace) {
      if (error.toString().contains('too-many-requests')) {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Too many registration attempts. Please try again later.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      } else if (error.toString().contains('email-already-in-use')) {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'An account with the given login already exists.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      } else if (error.toString().contains('network-request-failed')) {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Check your internet connection.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      } else {
        setState(() {
          isLogging = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Incorrect registration details.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loginFocusNode.unfocus();
        passwordFocusNode.unfocus();
        repeatPasswordFocusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 31, 29, 29),
        body: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
              spawnMaxRadius: 125,
              spawnMinRadius: 50,
              spawnMinSpeed: 1,
              particleCount: 12,
              spawnMaxSpeed: 3,
              minOpacity: 0.3,
              spawnOpacity: 0.4,
              baseColor: Colors.redAccent.shade400,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                TitleTextWidget(mainText: mainText),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: Container(
                    height: !isSigningUp
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.shade400.withOpacity(0.9),
                            Colors.white60.withOpacity(0.8),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(3.0, 3.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginTextFieldWidget(
                          nextFocusNode: passwordFocusNode,
                          currentFocusNode: loginFocusNode,
                          controller: login,
                          textFieldText: 'Login',
                          obscureText: false,
                        ),
                        LoginTextFieldWidget(
                          nextFocusNode: repeatPasswordFocusNode,
                          currentFocusNode: passwordFocusNode,
                          controller: password,
                          textFieldText: 'Password',
                          obscureText: true,
                        ),
                        if (isSigningUp)
                          LoginTextFieldWidget(
                            nextFocusNode: null,
                            currentFocusNode: repeatPasswordFocusNode,
                            controller: repeatPassword,
                            textFieldText: 'Repeat password',
                            obscureText: true,
                          ),
                        if (!isSigningUp)
                          Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: isLogging
                                  ? null
                                  : () {
                                      if (login.text != "" &&
                                          password.text != "") {
                                        setState(() {
                                          isLogging = true;
                                        });
                                        loginUser(
                                            login: login.text,
                                            password: password.text);
                                      } else {
                                        setState(() {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: Text(
                                              'Enter your login details.',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ));
                                        });
                                      }
                                    },
                              child: isLogging
                                  ? CircularProgressIndicator(
                                      color: Colors.redAccent.shade400,
                                    )
                                  : Text(
                                      'Sign in',
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        color: Colors.redAccent.shade400,
                                      ),
                                    ),
                            ),
                          ),
                        if (!isSigningUp)
                          Text(
                            'or',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: isLogging
                                ? null
                                : () {
                                    if (isSigningUp == false) {
                                      setState(() {
                                        isSigningUp = true;
                                        login.text = '';
                                        password.text = '';
                                        repeatPassword.text = '';
                                        mainText = 'Sign Up';
                                      });
                                    } else {
                                      if (login.text != "" &&
                                          password.text != "" &&
                                          repeatPassword.text != "") {
                                        if (password.text ==
                                            repeatPassword.text) {
                                          if (password.text.length >= 6) {
                                            setState(() {
                                              isLogging = true;
                                            });
                                            registerUser(
                                                login: login.text,
                                                password: password.text);
                                          } else {
                                            setState(() {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                content: Text(
                                                  'The password should contain at least 6 characters.',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ));
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              content: Text(
                                                'The passwords provided are not the same.',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lato(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ));
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: Text(
                                              'Enter your registration details.',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ));
                                        });
                                      }
                                    }
                                  },
                            child: (isLogging && isSigningUp)
                                ? CircularProgressIndicator(
                                    color: Colors.redAccent.shade400,
                                  )
                                : Text(
                                    'Sign up',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      color: Colors.redAccent.shade400,
                                    ),
                                  ),
                          ),
                        ),
                        if (isSigningUp)
                          Text(
                            'or',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        if (isSigningUp)
                          Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01,
                            ),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: isLogging
                                  ? null
                                  : () {
                                      setState(() {
                                        isSigningUp = false;
                                        mainText = 'Sign In';
                                        login.text = '';
                                        password.text = '';
                                        repeatPassword.text = '';
                                      });
                                    },
                              child: Text(
                                'Sign in',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.redAccent.shade400,
                                ),
                              ),
                            ),
                          ),
                      ],
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
