// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inter_business_comm_system/Database.dart';
import 'package:inter_business_comm_system/ProjectUtils/Utilities.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  bool isManager = false;
  bool isSelected = false;
  bool isobscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                Utility().showSnackbarUtil(context, "Enter Valid Details");
              }
              if (state is LoginSuccess) {
                if (isManager) {
                  Navigator.pushNamed(context, "/ManagerDashboard",
                      arguments: state.id);
                } else {
                  Navigator.pushNamed(context, "/EmployeeDashboard",
                      arguments: state.id);
                }
              }
              if (state is SignupState) {
                Navigator.pushNamed(context, "/SignupScreen");
              }
              if (state is ForgotpassState) {
                Utility().showSnackbarUtil(context, "Reset your Password",
                    isActionButton: true, label: "RESET", onPressed: () {});
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login Now",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please Login to Continue",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.26,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  "https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-83.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1723248000&semt=ais_hybrid"),
                            ),
                          ),
                        ),
                        Text(
                          "Enter Via Socials",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Utility().socialButtonUtil(
                                context, FontAwesomeIcons.google),
                            SizedBox(
                              width: 10,
                            ),
                            Utility().socialButtonUtil(
                                context, FontAwesomeIcons.twitter),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  "or Log in with",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: _key,
                          child: Column(
                            children: [
                              Utility().textfeildUtil(idController, "Id",
                                  "Enter the UniqueId", Icons.badge, context),
                              Utility().textfeildUtil(
                                  passwordController,
                                  "Password",
                                  "Enter the Password",
                                  Icons.key,
                                  context),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          shape: CircleBorder(),
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isSelected = value!;
                                            });
                                          }),
                                      Text(
                                        "Remember Me",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(ForgotpassEvent());
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            // margin: EdgeInsets.only(bottom: 10),
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: AnimatedToggleSwitch.dual(
                              current: isManager,
                              first: false,
                              second: true,
                              onChanged: (value) {
                                setState(() {
                                  isManager = value;
                                });
                              },
                              styleBuilder: (value) => ToggleStyle(
                                  backgroundColor: Color(0xFFEBF8F1),
                                  indicatorColor: value
                                      ? Colors.greenAccent
                                      : Colors.redAccent),
                              iconBuilder: (value) => value
                                  ? Icon(Icons.person)
                                  : Icon(Icons.business_center_outlined),
                              textBuilder: (value) => value
                                  ? Text(
                                      "As Employee",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "As Manager",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_key.currentState!.validate()) {
                                context
                                    .read<LoginBloc>()
                                    .add(LoginFailureEvent());
                              } else {
                                context.read<LoginBloc>().add(
                                      AuthenticateEvent(
                                          id: idController.text,
                                          password: passwordController.text,
                                          isManager: isManager),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(SignupEvent());
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(PasswordVisibilityState(isObscure: true)) {
    // on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibilityEvent);
    on<LoginSuccessEvent>(_onLoginSuccessEvent);
    on<LoginFailureEvent>(_onLoginFailureEvent);
    on<SignupEvent>(_onSignupEvent);
    on<ForgotpassEvent>(_onForgotpassEvent);
    on<AuthenticateEvent>(_onAuthenticateEvent);
  }
}

abstract class LoginState {}

abstract class LoginEvent {}

class InitialState extends LoginState {}

class LoginSuccess extends LoginState {
  String? id;

  LoginSuccess({required this.id});
}

class LoginFailure extends LoginState {}

class SignupState extends LoginState {}

class ForgotpassState extends LoginState {}

class PasswordVisibilityState extends LoginState {
  bool isObscure = true;

  PasswordVisibilityState({required this.isObscure});
}

class LoginSuccessEvent extends LoginEvent {
  String? id;

  LoginSuccessEvent({required this.id});
}

class LoginFailureEvent extends LoginEvent {}

class SignupEvent extends LoginEvent {}

class ForgotpassEvent extends LoginEvent {}

class AuthenticateEvent extends LoginEvent {
  String? id;
  String? password;
  bool? isManager;

  AuthenticateEvent({this.id, this.password, this.isManager});
}

class PasswordVisibilityEvent extends LoginEvent {
  bool? isObscure;

  PasswordVisibilityEvent({this.isObscure});
}

// class TogglePasswordVisibilityEvent extends LoginEvent {
//   bool isObscure = true;
//   TogglePasswordVisibilityEvent({required this.isObscure});
// }

// void _onTogglePasswordVisibilityEvent(
//     TogglePasswordVisibilityEvent event, Emitter<LoginState> emit) {
//   emit(PasswordVisibilityState(isObscure: !event.isObscure));
// }

void _onLoginSuccessEvent(LoginSuccessEvent event, Emitter<LoginState> emit) {
  emit(LoginSuccess(id: event.id));
}

void _onLoginFailureEvent(LoginFailureEvent event, Emitter<LoginState> emit) {
  emit(LoginFailure());
}

void _onSignupEvent(SignupEvent event, Emitter<LoginState> emit) {
  emit(SignupState());
}

void _onForgotpassEvent(ForgotpassEvent event, Emitter<LoginState> emit) {
  emit(ForgotpassState());
}

void _onAuthenticateEvent(
    AuthenticateEvent event, Emitter<LoginState> emit) async {
  Database _db = await AppDataBase().getDatabase();
  bool success = false;

  if (event.isManager!) {
    List<Map<String, dynamic>> dbData = await _db.rawQuery(
        'SELECT * FROM MANAGER WHERE mid = ? AND mpassword = ?',
        [event.id, event.password]);
    success = dbData.isNotEmpty;
  } else {
    List<Map<String, dynamic>> dbData = await _db.rawQuery(
        'SELECT * FROM EMP WHERE emp_id   = ? AND password = ?',
        [event.id, event.password]);
    success = dbData.isNotEmpty;
  }

  if (success) {
    emit(LoginSuccess(id: event.id));
  } else {
    emit(LoginFailure());
  }
}

void _onPasswordVisibilityEvent(
    PasswordVisibilityEvent event, Emitter<LoginState> emit) {}
