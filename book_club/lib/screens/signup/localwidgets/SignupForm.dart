import 'package:book_club/screens/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/ourContainer.dart';

class OurSignUpForm extends StatefulWidget {
  const OurSignUpForm({Key? key}) : super(key: key);

  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  @override
  Widget build(BuildContext context) {
    return OurContainer(child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
          child: (
              Text("Sign Up",style: TextStyle(color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25,fontWeight: FontWeight.bold),)
          ),

        ),
        TextFormField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline),
              hintText: "Name"),
        ),
        SizedBox(height: 20,),
        TextFormField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.alternate_email),
              hintText: "Email"),
        ),
        SizedBox(height: 20,),

        TextFormField(
          obscureText: true,
          decoration: InputDecoration(prefixIcon: Icon(Icons.lock_outline),
              hintText: "Password"),
        ),
        SizedBox(height: 20,),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(prefixIcon: Icon(Icons.lock_open),
              hintText: "Confirm Password"),
        ),
        SizedBox(height: 20,),

        RaisedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                fontSize: 20),),
          ),
          onPressed: (){},
        ),


      ],
    ),

    );
  }
}
