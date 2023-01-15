import 'package:book_club/screens/signup/localwidgets/SignupForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OurSignup extends StatelessWidget {
  const OurSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButton(),
                    ],
                  ),
                  SizedBox(height: 40,),
                  OurSignUpForm()


                ],
              )
          )
        ],
      ),
    );
  }
}
