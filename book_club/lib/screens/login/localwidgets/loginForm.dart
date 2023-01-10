import 'package:book_club/screens/Home/home.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/ourContainer.dart';

enum LoginType{
  email,
  google
}

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser({required LoginType type, String? email,String? password,BuildContext? context})async{
      CurrenState currenState = Provider.of<CurrenState>(context!,listen: false);
      String returnString="";
      try{

        switch(type){
          case LoginType.email:
            returnString=await currenState.loginUser(email!, password!);
            break;
          case LoginType.google:
            returnString= await currenState.loginUserWithGoogle();
            break;
          default:
        }

        if(returnString=="success"){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(),), (route) => false);
        }else{
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(returnString),
                duration: Duration(seconds: 2),)
          );
        }
      }catch(e){
        print(e);
      }
  }

  Widget googleButton(){
    return OutlinedButton(
       style: OutlinedButton.styleFrom(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(40)
         ),
         elevation: 0,

       ),
        onPressed: (){
         loginUser(type: LoginType.google,context: context);
        },
        child: Padding(
          padding:  EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: AssetImage("assets/google_icon.png"),height: 25,),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                child: Text("Sign in with Google",style:
                  TextStyle(fontSize: 20,color: Colors.grey),
                ),
              )
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return OurContainer(child: Column(
      children: [
       Padding(
           padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
         child: (
            Text("Log In",style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25,fontWeight: FontWeight.bold),)
         ),

       ),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(prefixIcon: Icon(Icons.alternate_email),
          hintText: "Email"),
        ),
        SizedBox(height: 20,),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(prefixIcon: Icon(Icons.lock_outline),
              hintText: "Password"),
        ),
        SizedBox(height: 20,),
        RaisedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Text("Log In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
            fontSize: 20),),
          ),
          onPressed: (){
            loginUser(type: LoginType.email,email: emailController.text,password: passwordController.text,context: context);
          },
        ),
        FlatButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OurSignup()),);
        },
            child: Text("Don't have and account? Sign up"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        googleButton()

      ],
    ),
      
    );
  }
}
