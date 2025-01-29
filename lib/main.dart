import 'package:flutter/material.dart';
import 'package:sign_in/Screens/instructions.dart';
import 'package:sign_in/Screens/sign_up.dart';
import 'package:sign_in/screens/sign_in_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.purpleAccent,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/login': (context) => SignInScreen(),
        '/register': (context) => SignUpScreen(),
      },
    );
  }
}
