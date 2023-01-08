import 'package:book_club/screens/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/ourContainer.dart';

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({Key? key}) : super(key: key);

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
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
        RaisedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Text("Log In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
            fontSize: 20),),
          ),
          onPressed: (){},
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
