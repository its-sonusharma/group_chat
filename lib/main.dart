import 'package:chitti/screens/chatscreen.dart';
import 'package:chitti/screens/loginscreen.dart';
import 'package:chitti/screens/registration%20screen.dart';
import 'package:chitti/screens/root.dart';
import 'package:chitti/screens/welcomescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main(){
  runApp(ChittiApp());
}
class ChittiApp extends StatefulWidget {
  @override
  _ChittiAppState createState() => _ChittiAppState();
}

class _ChittiAppState extends State<ChittiApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        )
      ),
      initialRoute: RootScreen.id,
      routes: {
        WelcomeScreen.id: (context)=> WelcomeScreen(),
        LoginScreen.id: (context)=> LoginScreen(),
        RegistrationScreen.id: (context)=> RegistrationScreen(),
        ChatScreen.id: (context)=> ChatScreen(),
        RootScreen.id:(context) => RootScreen(),
      },
    );
  }
}

