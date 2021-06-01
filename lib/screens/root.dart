import 'package:chitti/screens/chatscreen.dart';
import 'package:chitti/screens/welcomescreen.dart';
import 'package:flutter/material.dart';

enum AuthStatus{
  notLoggedIn,
  LoggedIn,
}

class RootScreen extends StatefulWidget {
  static const String id = 'Root_Screen';
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;
  @override
  Widget build(BuildContext context) {
    Widget retVal;
    if(_authStatus != null){
    return WelcomeScreen();
  }else{
      return ChatScreen();
    }

    /*switch(_authStatus){
      case AuthStatus.notLoggedIn: retVal = WelcomeScreen();
        break;
      case AuthStatus.LoggedIn:retVal = ChatScreen();
        break;
    }*/
    return retVal;
  }
}
