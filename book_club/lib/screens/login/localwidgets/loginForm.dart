import 'package:book_club/screens/Home/home.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/ourContainer.dart';

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser(String email,String password,BuildContext context)async{
      CurrenState currenState = Provider.of<CurrenState>(context,listen: false);
      try{
        if(await currenState.loginUser(email, password)){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>HomeScreen(),
            )
          );
        }else{
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Incorrect"),
                duration: Duration(seconds: 2),)
          );
        }
      }catch(e){
        print(e);
      }
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
            loginUser(emailController.text,passwordController.text,context);
          },
        ),
        FlatButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OurSignup()),);
        },
            child: Text("Don't have and account? Sign up"),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )

      ],
    ),
      
    );
  }
}
