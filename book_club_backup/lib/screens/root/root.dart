import 'package:book_club/screens/Home/home.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/screens/noGroup/nogroup.dart';
import 'package:book_club/screens/splashScreen/splash.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus{
  unknown,
  notInGroup,
  notLoggedIn,
  InGroup

}

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);

  @override
  State<OurRoot> createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus authStatus=AuthStatus.unknown;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on state
    CurrenState currenState=Provider.of<CurrenState>(context,listen: false);
    String returnString = await currenState.onStartUp();
    if(returnString=="success"){

      if(currenState.getCurrentUser.groupId!=""){
        setState((){
          authStatus=AuthStatus.InGroup;
        });

      }else{
        setState((){
          authStatus=AuthStatus.notInGroup;
        });
      }
    }else{
      setState((){
        authStatus=AuthStatus.notLoggedIn;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget retval=OurLogin();

    switch(authStatus){
      case AuthStatus.unknown:
        retval=OurSplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retval=OurLogin();
        break;
      case AuthStatus.notInGroup:
        retval=OurnoGroup();
        break;
      case AuthStatus.InGroup:
        retval=ChangeNotifierProvider(create: (BuildContext context) =>CurrentGroup() ,
        child: HomeScreen());
        break;
      default:

    }
    return retval;
  }
}
