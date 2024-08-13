// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mint Cream background color
      body: SafeArea(
        child: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushNamed(context, "/LoginScreen");
                }
                if (state is SignSuccess) {
                  Navigator.pushNamed(context, "/SignupScreen");
                }
              },
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please Login or Signup to Continue",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF1C232B)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                                "https://img.freepik.com/free-vector/hand-drawn-business-communication-concept_23-2149167947.jpg"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Enter Via Socials",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1C232B)), // Gunmetal 2
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Color(0xFFFFFFFF), // White
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                ),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor), // Pigment Green border
                              ),
                              child: FaIcon(FontAwesomeIcons.google,
                                  size: 30,
                                  color: Theme.of(context).primaryColor), // Pigment Green
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: Color(0xFFFFFFFF), // White
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                ),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor), // Pigment Green border
                              ),
                              child: FaIcon(FontAwesomeIcons.twitter,
                                  size: 30,
                                  color: Theme.of(context).primaryColor), // Pigment Green
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFF1C232B), // Gunmetal 2
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<HomeBloc>().add(LoginSuccessEvent());
                            },
                            child: Column(
                              children: [
                                Text(
                                  "or Log in with",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1C232B)), // Gunmetal 2
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1C232B)), // Gunmetal 2
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFF1C232B), // Gunmetal 2
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(SignupSuccessEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor:Theme.of(context).primaryColor, // Pigment Green
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "You already have an account?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1C232B)), // Gunmetal 2
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(LoginSuccessEvent());
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialState()) {
    on<LoginSuccessEvent>(_onLoginSuccessEvent);
    on<SignupSuccessEvent>(_onSignupSuccessEvent);
  }
}

abstract class HomeState {}

abstract class HomeEvent {}

class InitialState extends HomeState {}

class LoginSuccess extends HomeState {}

class SignSuccess extends HomeState {}

class LoginSuccessEvent extends HomeEvent {}

class SignupSuccessEvent extends HomeEvent {}

void _onLoginSuccessEvent(LoginSuccessEvent event, Emitter<HomeState> emit) {
  emit(LoginSuccess());
}

void _onSignupSuccessEvent(SignupSuccessEvent event, Emitter<HomeState> emit) {
  emit(SignSuccess());
}
