import 'package:book_club/screens/Home/home.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus{
  notLoggedIn,
  LoggedIn
}

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus authStatus=AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on state
    CurrenState currenState=Provider.of(context,listen: false);
    String returnString = await currenState.onStartUp();
    if(returnString=="success"){
      setState((){
        authStatus=AuthStatus.LoggedIn;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget retval=OurLogin();

    switch(authStatus){
      case AuthStatus.notLoggedIn:
        retval=OurLogin();
        break;
      case AuthStatus.LoggedIn:
        retval=HomeScreen();
        break;
      default:

    }
    return retval;
  }
}
